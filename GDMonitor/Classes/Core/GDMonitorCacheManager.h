//
//  GDMonitorCacheManager.h
//  GDMonitor
//
//  Created by beilu on 2021/11/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GDMonitorCacheManager : NSObject

@property (nonatomic, strong, readonly, class) GDMonitorCacheManager *manager;

- (void)saveFpsSwitch:(BOOL)on;

- (BOOL)fpsSwitch;

- (void)saveCpuSwitch:(BOOL)on;

- (BOOL)cpuSwitch;

- (void)saveMemorySwitch:(BOOL)on;

- (BOOL)memorySwitch;

@end

NS_ASSUME_NONNULL_END
