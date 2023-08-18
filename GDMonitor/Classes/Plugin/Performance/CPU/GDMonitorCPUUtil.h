//
//  GDMonitorCPUUtil.h
//  AFNetworking
//
//  Created by beilu on 2021/11/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GDMonitorCPUUtil : NSObject

//获取CPU使用率
+ (CGFloat)cpuUsageForApp;

@end

NS_ASSUME_NONNULL_END
