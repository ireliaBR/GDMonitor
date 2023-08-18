//
//  GDMonitorOscillogramWindowManager.m
//  AFNetworking
//
//  Created by beilu on 2021/11/10.
//

#import "GDMonitorOscillogramWindowManager.h"
#import "GDMonitorFPSOscillogramWindow.h"
#import "GDMonitorCPUOscillogramWindow.h"
#import "GDMonitorMemoryOscillogramWindow.h"
#import "GDMonitorDefine.h"

@interface GDMonitorOscillogramWindowManager()

@property (nonatomic, strong) GDMonitorFPSOscillogramWindow *fpsWindow;
@property (nonatomic, strong) GDMonitorCPUOscillogramWindow *cpuWindow;
@property (nonatomic, strong) GDMonitorMemoryOscillogramWindow *memoryWindow;

@end

@implementation GDMonitorOscillogramWindowManager

+ (GDMonitorOscillogramWindowManager *)shareInstance{
    static dispatch_once_t once;
    static GDMonitorOscillogramWindowManager *instance;
    dispatch_once(&once, ^{
        instance = [[GDMonitorOscillogramWindowManager alloc] init];
    });
    return instance;
}

- (instancetype)init{
    if (self = [super init]) {
        _fpsWindow = [GDMonitorFPSOscillogramWindow shareInstance];
        _cpuWindow = [GDMonitorCPUOscillogramWindow shareInstance];
        _memoryWindow = [GDMonitorMemoryOscillogramWindow shareInstance];
    }
    return self;
}

- (void)resetLayout{
    CGFloat offsetY = 0;
    CGFloat width = 0;
    CGFloat height = kGDMonitorSizeFrom750_Landscape(240);
    if (kInterfaceOrientationPortrait){
        width = GDMonitorScreenWidth;
        offsetY = 40;
    }else{
        width = GDMonitorScreenHeight;
    }
    if (!_cpuWindow.hidden) {
        _cpuWindow.frame = CGRectMake(0, offsetY, width, height);
        offsetY += _cpuWindow.monitor_height+kGDMonitorSizeFrom750_Landscape(4);
    }

    if (!_fpsWindow.hidden) {
        _fpsWindow.frame = CGRectMake(0, offsetY, width, height);
        offsetY += _fpsWindow.monitor_height+kGDMonitorSizeFrom750_Landscape(4);
    }

    if (!_memoryWindow.hidden) {
        _memoryWindow.frame = CGRectMake(0, offsetY, width, height);
        offsetY += _memoryWindow.monitor_height+kGDMonitorSizeFrom750_Landscape(4);
    }

}

@end
