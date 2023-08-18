//
//  GDMonitorMemoryOscillogramWindow.m
//  GDMonitor
//
//  Created by beilu on 2021/11/10.
//

#import "GDMonitorMemoryOscillogramWindow.h"
#import "GDMonitorMemoryOscillogramViewController.h"

@implementation GDMonitorMemoryOscillogramWindow

+ (GDMonitorMemoryOscillogramWindow *)shareInstance{
    static dispatch_once_t once;
    static GDMonitorMemoryOscillogramWindow *instance;
    dispatch_once(&once, ^{
        instance = [[GDMonitorMemoryOscillogramWindow alloc] initWithFrame:CGRectZero];
    });
    return instance;
}

- (void)addRootVc{
    GDMonitorMemoryOscillogramViewController *vc = [[GDMonitorMemoryOscillogramViewController alloc] init];
    self.rootViewController = vc;
    self.vc = vc;
}

@end
