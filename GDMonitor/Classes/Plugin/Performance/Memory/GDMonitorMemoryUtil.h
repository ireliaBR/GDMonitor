//
//  GDMonitorMemoryUtil.h
//  AFNetworking
//
//  Created by beilu on 2021/11/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GDMonitorMemoryUtil : NSObject

//当前app内存使用量
+ (NSInteger)useMemoryForApp;

//设备总的内存
+ (NSInteger)totalMemoryForDevice;

@end

NS_ASSUME_NONNULL_END
