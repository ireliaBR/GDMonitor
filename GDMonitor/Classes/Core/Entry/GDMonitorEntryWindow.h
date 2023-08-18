//
//  GDMonitorEntryWindow.h
//  GDMonitor
//
//  Created by beilu on 2021/11/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GDMonitorEntryWindow : UIWindow

/// 是否自动停靠，默认为YES
@property (nonatomic, assign) BOOL autoDock;

- (instancetype)initWithStartPoint:(CGPoint)startingPosition;
- (void)show;

@end

NS_ASSUME_NONNULL_END
