//
//  GDMonitorFPSUtil.h
//  AFNetworking
//
//  Created by beilu on 2021/11/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GDMonitorFPSUtil : NSObject

- (void)start;
- (void)end;
- (void)addFPSBlock:(void(^)(NSInteger fps))block;

@end

NS_ASSUME_NONNULL_END
