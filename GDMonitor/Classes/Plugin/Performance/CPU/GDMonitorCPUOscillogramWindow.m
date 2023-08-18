//
//  GDMonitorCPUOscillogramWindow.m
//  GDMonitor
//
//  Created by beilu on 2021/11/10.
//

#import "GDMonitorCPUOscillogramWindow.h"
#import "GDMonitorCPUOscillogramViewController.h"

@implementation GDMonitorCPUOscillogramWindow

+ (GDMonitorCPUOscillogramWindow *)shareInstance{
    static dispatch_once_t once;
    static GDMonitorCPUOscillogramWindow *instance;
    dispatch_once(&once, ^{
        instance = [[GDMonitorCPUOscillogramWindow alloc] initWithFrame:CGRectZero];
    });
    return instance;
}

- (void)addRootVc{
    GDMonitorCPUOscillogramViewController *vc = [[GDMonitorCPUOscillogramViewController alloc] init];
    self.rootViewController = vc;
    self.vc = vc;
}

@end
