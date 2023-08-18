//
//  GDMonitorCacheManager.m
//  GDMonitor
//
//  Created by beilu on 2021/11/10.
//

#import "GDMonitorCacheManager.h"

static NSString * const kGDMonitorFpsKey = @"doraemon_fps_key";
static NSString * const kGDMonitorCpuKey = @"doraemon_cpu_key";
static NSString * const kGDMonitorMemoryKey = @"doraemon_memory_key";

@interface GDMonitorCacheManager()

@property (nonatomic, strong) NSUserDefaults *defaults;

@end

@implementation GDMonitorCacheManager

+ (GDMonitorCacheManager *)manager {
    static GDMonitorCacheManager *ME = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ME = [GDMonitorCacheManager new];
    });
    return ME;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.defaults = [[NSUserDefaults alloc] initWithSuiteName:@"com.gaoding.monitor"];
    }
    return self;
}

- (void)saveFpsSwitch:(BOOL)on{
    [_defaults setBool:on forKey:kGDMonitorFpsKey];
    [_defaults synchronize];
}

- (BOOL)fpsSwitch{
    return [_defaults boolForKey:kGDMonitorFpsKey];
}

- (void)saveCpuSwitch:(BOOL)on{
    [_defaults setBool:on forKey:kGDMonitorCpuKey];
    [_defaults synchronize];
}

- (BOOL)cpuSwitch{
    return [_defaults boolForKey:kGDMonitorCpuKey];
}

- (void)saveMemorySwitch:(BOOL)on{
    [_defaults setBool:on forKey:kGDMonitorMemoryKey];
    [_defaults synchronize];
}

- (BOOL)memorySwitch{
    return [_defaults boolForKey:kGDMonitorMemoryKey];
}

@end
