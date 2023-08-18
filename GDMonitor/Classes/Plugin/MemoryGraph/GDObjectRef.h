//
//  GDObjectRef.h
//  GDMonitor
//
//  Created by fdd on 2023/8/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GDObjectRef : NSObject

@property (nonatomic, strong) id object;
@property (nonatomic, strong) Class cls;
/// For example, "NSString 0x1d4085d0" or "NSLayoutConstraint _object"
@property (nonatomic, strong) NSString *reference;

- (instancetype)initWithObject:(id)object;
- (instancetype)initWithObject:(id)object cls:(Class _Nullable)cls;
- (instancetype)initWithObject:(id)object ivarName:(NSString *_Nullable)ivar cls:(Class)cls;

@end

NS_ASSUME_NONNULL_END
