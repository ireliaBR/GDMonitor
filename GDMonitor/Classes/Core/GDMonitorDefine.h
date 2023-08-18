//
//  GDMonitorDefine.h
//  Pods
//
//  Created by beilu on 2021/11/9.
//

#ifndef GDMonitorDefine_h
#define GDMonitorDefine_h

#import "UIView+Monitor.h"

//#define GDMonitor_OpenLog

#ifdef GDMonitor_OpenLog
#define GDMonitorLog(...) NSLog(@"GDMonitorLog -> %s\n %@ \n\n",__func__,[NSString stringWithFormat:__VA_ARGS__]);
#else
#define GDMonitorLog(...)
#endif

#define GDMonitorScreenWidth [UIScreen mainScreen].bounds.size.width
#define GDMonitorScreenHeight [UIScreen mainScreen].bounds.size.height

//GDMonitor默认位置
#define GDMonitorStartingPosition            CGPointMake(0, GDMonitorScreenHeight/3.0)
//GDMonitor全屏默认位置
#define GDMonitorFullScreenStartingPosition  CGPointZero

//根据750*1334分辨率计算size
#define kGDMonitorSizeFrom750(x) ((x)*GDMonitorScreenWidth/750)
// 如果横屏显示
#define kGDMonitorSizeFrom750_Landscape(x) (kInterfaceOrientationLandscape ? ((x)*GDMonitorScreenHeight/750) : kGDMonitorSizeFrom750(x))

#define kInterfaceOrientationPortrait UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)

#define kInterfaceOrientationLandscape UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)

//#define IS_IPHONE_X_Series [DoraemonAppInfoUtil isIPhoneXSeries]
//#define IPHONE_NAVIGATIONBAR_HEIGHT  (IS_IPHONE_X_Series ? 88 : 64)
//#define IPHONE_STATUSBAR_HEIGHT      (IS_IPHONE_X_Series ? 44 : 20)
//#define IPHONE_SAFEBOTTOMAREA_HEIGHT (IS_IPHONE_X_Series ? 34 : 0)
//#define IPHONE_TOPSENSOR_HEIGHT      (IS_IPHONE_X_Series ? 32 : 0)

#define UIColorFromRGBA(rgbValue, alphaValue) [UIColor \
        colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
        green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
        blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]

#define UIColorFromRGB(rgbValue) UIColorFromRGBA(rgbValue, 1.0)

#endif /* GDMonitorDefine_h */
