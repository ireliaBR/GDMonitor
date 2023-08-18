//
//  GDObjectRef.m
//  GDMonitor
//
//  Created by fdd on 2023/8/18.
//

#import "GDObjectRef.h"
#import "GDRuntimeUtility.h"

@implementation GDObjectRef

- (instancetype)initWithObject:(id)object {
    return [self initWithObject:object ivarName:nil cls:nil];
}

- (instancetype)initWithObject:(id)object cls:(Class)cls {
    return [self initWithObject:object ivarName:nil cls:cls];
}

- (instancetype)initWithObject:(id)object ivarName:(NSString *)ivar cls:(Class)cls {
    self = [super init];
    if (self) {
        self.object = object;
        self.cls = cls;
        NSString *class = [GDRuntimeUtility safeClassNameForObject:object];
        if (ivar) {
            self.reference = [NSString stringWithFormat:@"%@ %@", class, ivar];
        } else {
            self.reference = class;
        }
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %@>",
        [self class], self.reference
    ];
}

@end
