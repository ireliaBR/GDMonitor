//
//  GDHeapUtil.h
//  GDMonitor
//
//  Created by fdd on 2023/8/18.
//

#import <Foundation/Foundation.h>
@class GDObjectRef, GDHeapSnapshot;

NS_ASSUME_NONNULL_BEGIN

typedef void (^gd_object_enumeration_block_t)(__unsafe_unretained id object, __unsafe_unretained Class actualClass);

@interface GDHeapUtil : NSObject

/// Use carefully; this method puts a global lock on the heap in between callbacks.
///
/// Inspired by:
/// [heap_find.cpp](https://llvm.org/svn/llvm-project/lldb/tags/RELEASE_34/final/examples/darwin/heap_find/heap/heap_find.cpp)
/// and [samdmarshall](https://gist.github.com/samdmarshall/17f4e66b5e2e579fd396)
+ (void)enumerateLiveObjectsUsingBlock:(gd_object_enumeration_block_t)callback
NS_SWIFT_UNAVAILABLE("Use one of the other methods instead.");

/// Returned references are not validated beyond containing a valid isa.
/// To validate them yourself, pass each reference's object to \c FLEXPointerIsValidObjcObject
+ (NSArray<GDObjectRef *> *)instancesOfClassWithName:(NSString *)className retained:(BOOL)retain;

/// Returned references have been validated via \c FLEXPointerIsValidObjcObject
/// @param object the object to find references to
/// @param retain whether to retain the objects referencing \c object
+ (NSArray<GDObjectRef *> *)objectsWithReferencesToObject:(id)object retained:(BOOL)retain;

/// Capture all live objects on the heap and do with this information what you will.
+ (GDHeapSnapshot *)generateHeapSnapshot;

@end

@interface GDHeapSnapshot : NSObject

@property (nonatomic, strong) NSArray<NSString *> *classNames;
@property (nonatomic, strong) NSDictionary<NSString *, NSNumber *> *instanceCountsForClassNames;
@property (nonatomic, strong) NSDictionary<NSString *, NSNumber *> *instanceSizesForClassNames;

@end

NS_ASSUME_NONNULL_END
