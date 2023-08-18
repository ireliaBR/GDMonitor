//
//  NSString+Monitor.h
//  GDMonitor
//
//  Created by fdd on 2023/8/18.
//

#import "GDRuntimeConstants.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSString (GDTypeEncoding)

///@return whether this type starts with the const specifier
@property (nonatomic, readonly) BOOL gd_typeIsConst;
/// @return the first char in the type encoding that is not the const specifier
@property (nonatomic, readonly) GDTypeEncoding gd_firstNonConstType;
/// @return the first char in the type encoding after the pointer specifier, if it is a pointer
@property (nonatomic, readonly) GDTypeEncoding gd_pointeeType;
/// @return whether this type is an objc object of any kind, even if it's const
@property (nonatomic, readonly) BOOL gd_typeIsObjectOrClass;
/// @return the class named in this type encoding if it is of the form \c @"MYClass"
@property (nonatomic, readonly) Class gd_typeClass;
/// Includes C strings and selectors as well as regular pointers
@property (nonatomic, readonly) BOOL gd_typeIsNonObjcPointer;

@end

@interface NSString (KeyPaths)

- (NSString *)gd_stringByRemovingLastKeyPathComponent;
- (NSString *)gd_stringByReplacingLastKeyPathComponent:(NSString *)replacement;

@end

NS_ASSUME_NONNULL_END
