//
//  GDMonitorFPSOscillogramWindow.m
//  GDMonitor
//
//  Created by beilu on 2021/11/10.
//

#import "GDMonitorFPSOscillogramWindow.h"
#import "GDMonitorFPSOscillogramViewController.h"

@implementation GDMonitorFPSOscillogramWindow

+ (GDMonitorFPSOscillogramWindow *)shareInstance{
    static dispatch_once_t once;
    static GDMonitorFPSOscillogramWindow *instance;
    dispatch_once(&once, ^{
        instance = [[GDMonitorFPSOscillogramWindow alloc] initWithFrame:CGRectZero];
    });
    return instance;
}

- (void)addRootVc{
    GDMonitorFPSOscillogramViewController *vc = [[GDMonitorFPSOscillogramViewController alloc] init];
    self.rootViewController = vc;
    self.vc = vc;
}

@end
