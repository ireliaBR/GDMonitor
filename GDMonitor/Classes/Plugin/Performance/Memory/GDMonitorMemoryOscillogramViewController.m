//
//  GDMonitorMemoryOscillogramViewController.m
//  GDMonitor
//
//  Created by beilu on 2021/11/10.
//

#import "GDMonitorMemoryOscillogramViewController.h"
#import "GDMonitorOscillogramView.h"
#import "UIView+Monitor.h"
#import "GDMonitorMemoryUtil.h"
#import "GDMonitorDefine.h"
#import "GDMonitorCacheManager.h"
#import "GDMonitorMemoryOscillogramWindow.h"
#import "GDMonitorRealtimeFeedback.h"

@interface GDMonitorMemoryOscillogramViewController () <GDMonitorRealtimeFeedbackDelegate>

@end

@implementation GDMonitorMemoryOscillogramViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [GDMonitorRealtimeFeedback.feedback addDelegate:self];
}

- (NSString *)title{
    return @"内存检测";
}

- (NSString *)lowValue{
    return @"0";
}

- (NSString *)highValue{
    return [NSString stringWithFormat:@"%zi",[self deviceMemory]];
}

- (void)closeBtnClick{
    [[GDMonitorCacheManager manager] saveMemorySwitch:NO];
    [[GDMonitorMemoryOscillogramWindow shareInstance] hide];
}

//每一秒钟采样一次内存使用率
- (void)doSecondFunction{
}

- (NSUInteger)deviceMemory {
    return 1000;
}

- (void)feedbackMemory:(NSInteger)memory {
    NSUInteger totalMemoryForDevice = [self deviceMemory];
    
    // 0~totalMemoryForDevice   对应 高度0~_oscillogramView.doraemon_height
    [self.oscillogramView addHeightValue:memory*self.oscillogramView.monitor_height/totalMemoryForDevice andTipValue:[NSString stringWithFormat:@"%zi",memory]];
}

@end
