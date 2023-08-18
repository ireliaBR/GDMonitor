//
//  GDMonitorCPUOscillogramViewController.m
//  GDMonitor
//
//  Created by beilu on 2021/11/10.
//

#import "GDMonitorCPUOscillogramViewController.h"
#import "GDMonitorOscillogramView.h"
#import "GDMonitorCPUUtil.h"
#import "GDMonitorDefine.h"
#import "GDMonitorCPUOscillogramWindow.h"
#import "GDMonitorCacheManager.h"
#import "GDMonitorRealtimeFeedback.h"

@interface GDMonitorCPUOscillogramViewController () <GDMonitorRealtimeFeedbackDelegate>

@end

@implementation GDMonitorCPUOscillogramViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [GDMonitorRealtimeFeedback.feedback addDelegate:self];
}

- (NSString *)title{
    return @"CPU检测";
}

- (NSString *)lowValue{
    return @"0";
}

- (NSString *)highValue{
    return @"100";
}

- (void)closeBtnClick{
    [[GDMonitorCacheManager manager] saveCpuSwitch:NO];
    [[GDMonitorCPUOscillogramWindow shareInstance] hide];
}

//每一秒钟采样一次cpu使用率
- (void)doSecondFunction{
}

- (void)feedbackCPU:(CGFloat)CPU {
    CGFloat cpuUsage = CPU / 100.f;
    if (cpuUsage * 100 > 100) {
        cpuUsage = 100;
    }else{
        cpuUsage = cpuUsage * 100;
    }
    // 0~100   对应 高度0~_oscillogramView.doraemon_height
    [self.oscillogramView addHeightValue:cpuUsage*self.oscillogramView.monitor_height/100. andTipValue:[NSString stringWithFormat:@"%.f",cpuUsage]];
}

@end
