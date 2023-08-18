//
//  GDMonitorHomeWindow.h
//  GDMonitor
//
//  Created by beilu on 2021/11/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GDMonitorHomeWindow : UIWindow

@property (nonatomic, strong) UINavigationController *nav;

+ (GDMonitorHomeWindow *)shareInstance;

// open plugin vc
+ (void)openPlugin:(UIViewController *)vc;

- (void)show;
- (void)hide;

@end

NS_ASSUME_NONNULL_END
