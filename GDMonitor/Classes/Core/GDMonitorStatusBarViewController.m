//
//  GDMonitorStatusBarViewController.m
//  AFNetworking
//
//  Created by beilu on 2021/11/9.
//

#import "GDMonitorStatusBarViewController.h"

@interface GDMonitorStatusBarViewController ()

@end

@implementation GDMonitorStatusBarViewController

// iOS9.0的系统中，新建的window设置的rootViewController默认没有显示状态栏

#if __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_9_3

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#endif

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
