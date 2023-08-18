//
//  GDLiveObjectManager.m
//  GDMonitor
//
//  Created by fdd on 2023/8/18.
//

#import "GDLiveObjectManager.h"
#import <objc/runtime.h>
#import "GDObjectRef.h"
#import "GDObjcInternal.h"

@interface GDLiveObjectManager ()

@property (nonatomic, strong) GDHeapSnapshot *snapshot;
@property (nonatomic, strong) NSArray<GDObjectRef *> *liveObjects;

@end

@implementation GDLiveObjectManager

- (void)loadLiveObject {
    // Set up a CFMutableDictionary with class pointer keys and NSUInteger values.
    // We abuse CFMutableDictionary a little to have primitive keys through judicious casting, but it gets the job done.
    // The dictionary is intialized with a 0 count for each class so that it doesn't have to expand during enumeration.
    // While it might be a little cleaner to populate an NSMutableDictionary with class name string keys to NSNumber counts,
    // we choose the CF/primitives approach because it lets us enumerate the objects in the heap without allocating any memory during enumeration.
    // The alternative of creating one NSString/NSNumber per object on the heap ends up polluting the count of live objects quite a bit.
    unsigned int classCount = 0;
    Class *classes = objc_copyClassList(&classCount);
    CFMutableDictionaryRef mutableCountsForClasses = CFDictionaryCreateMutable(NULL, classCount, NULL, NULL);
    for (unsigned int i = 0; i < classCount; i++) {
        CFDictionarySetValue(mutableCountsForClasses, (__bridge const void *)classes[i], (const void *)0);
    }
    
    NSMutableArray<GDObjectRef *> *liveObjects = [NSMutableArray new];
    // Enumerate all objects on the heap to build the counts of instances for each class.
    [GDHeapUtil enumerateLiveObjectsUsingBlock:^(__unsafe_unretained id object, __unsafe_unretained Class actualClass) {
        NSUInteger instanceCount = (NSUInteger)CFDictionaryGetValue(mutableCountsForClasses, (__bridge const void *)actualClass);
        instanceCount++;
        CFDictionarySetValue(mutableCountsForClasses, (__bridge const void *)actualClass, (const void *)instanceCount);
        
//        if (!GDPointerIsValidObjcObject((__bridge void *)object)) {
//            return;
//        }
//        GDObjectRef *obj = [[GDObjectRef alloc] initWithObject:object cls:actualClass];
//        [liveObjects addObject:obj];
    }];
    
    // Convert our CF primitive dictionary into a nicer mapping of class name strings to counts that we will use as the table's model.
    NSMutableDictionary<NSString *, NSNumber *> *mutableCountsForClassNames = [NSMutableDictionary new];
    NSMutableDictionary<NSString *, NSNumber *> *mutableSizesForClassNames = [NSMutableDictionary new];
    for (unsigned int i = 0; i < classCount; i++) {
        Class class = classes[i];
        NSUInteger instanceCount = (NSUInteger)CFDictionaryGetValue(mutableCountsForClasses, (__bridge const void *)(class));
        NSString *className = @(class_getName(class));
        if (instanceCount > 0) {
            [mutableCountsForClassNames setObject:@(instanceCount) forKey:className];
        }
        [mutableSizesForClassNames setObject:@(class_getInstanceSize(class)) forKey:className];
    }
    free(classes);
    
//    self.liveObjects = [liveObjects copy];
    GDHeapSnapshot *snapshot = [[GDHeapSnapshot alloc] init];
    snapshot.classNames = mutableCountsForClassNames.allKeys;
    snapshot.instanceCountsForClassNames = [mutableCountsForClassNames copy];
    snapshot.instanceSizesForClassNames = [mutableSizesForClassNames copy];
    self.snapshot = snapshot;
}

@end
