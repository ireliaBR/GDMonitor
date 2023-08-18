//
//  GDMonitorFPSOscillogramViewController.m
//  GDMonitor
//
//  Created by beilu on 2021/11/10.
//

#import "GDMonitorFPSOscillogramViewController.h"
#import "GDMonitorOscillogramView.h"
#import "GDMonitorDefine.h"
#import "GDMonitorCacheManager.h"
#import "GDMonitorFPSOscillogramWindow.h"
#import "GDMonitorFPSUtil.h"
#import "GDMonitorRealtimeFeedback.h"

@interface GDMonitorFPSOscillogramViewController () <GDMonitorRealtimeFeedbackDelegate>


@end

@implementation GDMonitorFPSOscillogramViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [GDMonitorRealtimeFeedback.feedback addDelegate:self];
}

- (NSString *)title{
    return @"帧率检测";
}

- (NSString *)lowValue{
    return @"0";
}

- (NSString *)highValue{
    return @"60";
}


- (void)closeBtnClick{
    [[GDMonitorCacheManager manager] saveFpsSwitch:NO];
    [[GDMonitorFPSOscillogramWindow shareInstance] hide];
}

- (void)startRecord{
    
}

- (void)endRecord{
    
}

- (void)feedbackFPS:(NSInteger)FPS {
    // 0~60   对应 高度0~_oscillogramView.doraemon_height
    [self.oscillogramView addHeightValue:FPS*self.oscillogramView.monitor_height/60. andTipValue:[NSString stringWithFormat:@"%zi", FPS]];
}

@end
