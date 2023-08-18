//
//  GDMonitorOscillogramWindow.h
//  AFNetworking
//
//  Created by beilu on 2021/11/10.
//

#import <UIKit/UIKit.h>
#import "GDMonitorOscillogramViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol GDMonitorOscillogramWindowDelegate <NSObject>

- (void)monitorOscillogramWindowClosed;

@end

@interface GDMonitorOscillogramWindow : UIWindow

+ (GDMonitorOscillogramWindow *)shareInstance;

@property (nonatomic, strong) GDMonitorOscillogramViewController *vc;

//需要子类重写
- (void)addRootVc;

- (void)show;

- (void)hide;

- (void)addDelegate:(id<GDMonitorOscillogramWindowDelegate>) delegate;

- (void)removeDelegate:(id<GDMonitorOscillogramWindowDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
