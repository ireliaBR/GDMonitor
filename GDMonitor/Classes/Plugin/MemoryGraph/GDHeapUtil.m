//
//  GDHeapUtil.m
//  GDMonitor
//
//  Created by fdd on 2023/8/18.
//

#import "GDHeapUtil.h"
#import <malloc/malloc.h>
#import <mach/mach.h>
#import <objc/runtime.h>
#import "GDObjectRef.h"
#import "GDObjcInternal.h"
#import "NSString+Monitor.h"

static CFMutableSetRef registeredClasses;

// Mimics the objective-c object structure for checking if a range of memory is an object.
typedef struct {
    Class isa;
} gd_maybe_object_t;

static void range_callback(task_t task, void *context, unsigned type, vm_range_t *ranges, unsigned rangeCount) {
    if (!context) {
        return;
    }
    
    for (unsigned int i = 0; i < rangeCount; i++) {
        vm_range_t range = ranges[i];
        gd_maybe_object_t *tryObject = (gd_maybe_object_t *)range.address;
        Class tryClass = NULL;
#ifdef __arm64__
        // See http://www.sealiesoftware.com/blog/archive/2013/09/24/objc_explain_Non-pointer_isa.html
        extern uint64_t objc_debug_isa_class_mask WEAK_IMPORT_ATTRIBUTE;
        tryClass = (__bridge Class)((void *)((uint64_t)tryObject->isa & objc_debug_isa_class_mask));
#else
        tryClass = tryObject->isa;
#endif
        // If the class pointer matches one in our set of class pointers from the runtime, then we should have an object.
        if (CFSetContainsValue(registeredClasses, (__bridge const void *)(tryClass))) {
            (*(gd_object_enumeration_block_t __unsafe_unretained *)context)((__bridge id)tryObject, tryClass);
        }
    }
}

static kern_return_t reader(__unused task_t remote_task, vm_address_t remote_address, __unused vm_size_t size, void **local_memory) {
    *local_memory = (void *)remote_address;
    return KERN_SUCCESS;
}

@implementation GDHeapUtil

+ (void)enumerateLiveObjectsUsingBlock:(gd_object_enumeration_block_t)block {
    if (!block) {
        return;
    }
    
    // Refresh the class list on every call in case classes are added to the runtime.
    [self updateRegisteredClasses];
    
    // Inspired by:
    // https://llvm.org/svn/llvm-project/lldb/tags/RELEASE_34/final/examples/darwin/heap_find/heap/heap_find.cpp
    // https://gist.github.com/samdmarshall/17f4e66b5e2e579fd396
    
    vm_address_t *zones = NULL;
    unsigned int zoneCount = 0;
    kern_return_t result = malloc_get_all_zones(TASK_NULL, reader, &zones, &zoneCount);
    
    if (result == KERN_SUCCESS) {
        for (unsigned int i = 0; i < zoneCount; i++) {
            malloc_zone_t *zone = (malloc_zone_t *)zones[i];
            malloc_introspection_t *introspection = zone->introspect;

            // This may explain why some zone functions are
            // sometimes invalid; perhaps not all zones support them?
            if (!introspection) {
                continue;
            }

            void (*lock_zone)(malloc_zone_t *zone)   = introspection->force_lock;
            void (*unlock_zone)(malloc_zone_t *zone) = introspection->force_unlock;

            // Callback has to unlock the zone so we freely allocate memory inside the given block
            gd_object_enumeration_block_t callback = ^(__unsafe_unretained id object, __unsafe_unretained Class actualClass) {
                unlock_zone(zone);
                block(object, actualClass);
                lock_zone(zone);
            };
            
            BOOL lockZoneValid = GDPointerIsReadable(lock_zone);
            BOOL unlockZoneValid =  GDPointerIsReadable(unlock_zone);

            // There is little documentation on when and why
            // any of these function pointers might be NULL
            // or garbage, so we resort to checking for NULL
            // and whether the pointer is readable
            if (introspection->enumerator && lockZoneValid && unlockZoneValid) {
                lock_zone(zone);
                introspection->enumerator(TASK_NULL, (void *)&callback, MALLOC_PTR_IN_USE_RANGE_TYPE, (vm_address_t)zone, reader, &range_callback);
                unlock_zone(zone);
            }
        }
    }
}

+ (void)updateRegisteredClasses {
    if (!registeredClasses) {
        registeredClasses = CFSetCreateMutable(NULL, 0, NULL);
    } else {
        CFSetRemoveAllValues(registeredClasses);
    }
    unsigned int count = 0;
    Class *classes = objc_copyClassList(&count);
    for (unsigned int i = 0; i < count; i++) {
        CFSetAddValue(registeredClasses, (__bridge const void *)(classes[i]));
    }
    free(classes);
}

+ (NSArray<GDObjectRef *> *)instancesOfClassWithName:(NSString *)className retained:(BOOL)retain {
    const char *classNameCString = className.UTF8String;
    NSMutableArray *instances = [NSMutableArray new];
    [GDHeapUtil enumerateLiveObjectsUsingBlock:^(__unsafe_unretained id object, __unsafe_unretained Class actualClass) {
        if (strcmp(classNameCString, class_getName(actualClass)) == 0) {
            // Note: objects of certain classes crash when retain is called.
            // It is up to the user to avoid tapping into instance lists for these classes.
            // Ex. OS_dispatch_queue_specific_queue
            // In the future, we could provide some kind of warning for classes that are known to be problematic.
            
            if (malloc_size((__bridge const void *)(object)) > 0) {
                [instances addObject:object];
            }
        }
    }];
    
    NSMutableArray<GDObjectRef *> *array = [NSMutableArray new];
    for (id object in instances) {
        GDObjectRef *objectRef = [[GDObjectRef alloc] initWithObject:object];
        [array addObject:objectRef];
    }
    return [array copy];
}

+ (NSArray<GDObjectRef *> *)objectsWithReferencesToObject:(id)object retained:(BOOL)retain {
    NSMutableArray<GDObjectRef *> *instances = [NSMutableArray new];
    [GDHeapUtil enumerateLiveObjectsUsingBlock:^(__unsafe_unretained id tryObject, __unsafe_unretained Class actualClass) {
        // Skip known-invalid objects
        if (!GDPointerIsValidObjcObject((__bridge void *)tryObject)) {
            return;
        }
        
        // Get all the ivars on the object. Start with the class and and travel up the
        // inheritance chain. Once we find a match, record it and move on to the next object.
        // There's no reason to find multiple matches within the same object.
        Class tryClass = actualClass;
        while (tryClass) {
            unsigned int ivarCount = 0;
            Ivar *ivars = class_copyIvarList(tryClass, &ivarCount);

            for (unsigned int ivarIndex = 0; ivarIndex < ivarCount; ivarIndex++) {
                Ivar ivar = ivars[ivarIndex];
                NSString *typeEncoding = @(ivar_getTypeEncoding(ivar) ?: "");

                if (typeEncoding.gd_typeIsObjectOrClass) {
                    ptrdiff_t offset = ivar_getOffset(ivar);
                    uintptr_t *fieldPointer = (__bridge void *)tryObject + offset;

                    if (*fieldPointer == (uintptr_t)(__bridge void *)object) {
                        NSString *ivarName = @(ivar_getName(ivar) ?: "???");
                        id ref = [[GDObjectRef alloc] initWithObject:tryObject ivarName:ivarName cls:tryClass];
                        [instances addObject:ref];
                        return;
                    }
                }
            }

            free(ivars);
            tryClass = class_getSuperclass(tryClass);
        }
    }];

    return instances;
}

+ (GDHeapSnapshot *)generateHeapSnapshot {
    // Set up a CFMutableDictionary with class pointer keys and NSUInteger values.
    // We abuse CFMutableDictionary a little to have primitive keys through judicious casting, but it gets the job done.
    // The dictionary is intialized with a 0 count for each class so that it doesn't have to expand during enumeration.
    // While it might be a little cleaner to populate an NSMutableDictionary with class name string keys to NSNumber
    // counts, we choose the CF/primitives approach because it lets us enumerate the objects in the heap without
    // allocating any memory during enumeration. The alternative of creating one NSString/NSNumber per object
    // on the heap ends up polluting the count of live objects quite a bit.
    unsigned int classCount = 0;
    Class *classes = objc_copyClassList(&classCount);
    CFMutableDictionaryRef mutableCountsForClasses = CFDictionaryCreateMutable(NULL, classCount, NULL, NULL);
    for (unsigned int i = 0; i < classCount; i++) {
        CFDictionarySetValue(mutableCountsForClasses, (__bridge const void *)classes[i], (const void *)0);
    }
    
    // Enumerate all objects on the heap to build the counts of instances for each class
    [GDHeapUtil enumerateLiveObjectsUsingBlock:^(__unsafe_unretained id object, __unsafe_unretained Class cls) {
        NSUInteger instanceCount = (NSUInteger)CFDictionaryGetValue(
            mutableCountsForClasses, (__bridge const void *)cls
        );
        instanceCount++;
        CFDictionarySetValue(
            mutableCountsForClasses, (__bridge const void *)cls, (const void *)instanceCount
        );
    }];
    
    // Convert our CF primitive dictionary into a nicer mapping of class name strings to instance counts
    NSMutableDictionary<NSString *, NSNumber *> *countsForClassNames = [NSMutableDictionary new];
    NSMutableDictionary<NSString *, NSNumber *> *sizesForClassNames = [NSMutableDictionary new];
    for (unsigned int i = 0; i < classCount; i++) {
        Class class = classes[i];
        NSUInteger instanceCount = (NSUInteger)CFDictionaryGetValue(mutableCountsForClasses, (__bridge const void *)(class));
        NSString *className = @(class_getName(class));
        
        if (instanceCount > 0) {
            countsForClassNames[className] = @(instanceCount);
            sizesForClassNames[className] = @(class_getInstanceSize(class));
        }
    }
    free(classes);
    
    GDHeapSnapshot *snapshot = [[GDHeapSnapshot alloc] init];
    snapshot.classNames = countsForClassNames.allKeys;
    snapshot.instanceCountsForClassNames = countsForClassNames;
    snapshot.instanceSizesForClassNames = sizesForClassNames;
    
    return snapshot;
}

@end

@implementation GDHeapSnapshot

@end
