//
//  GDMonitorOscillogramWindowManager.h
//  AFNetworking
//
//  Created by beilu on 2021/11/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GDMonitorOscillogramWindowManager : NSObject

+ (GDMonitorOscillogramWindowManager *)shareInstance;

- (void)resetLayout;

@end

NS_ASSUME_NONNULL_END
