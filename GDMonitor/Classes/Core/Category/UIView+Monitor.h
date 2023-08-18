//
//  UIView+Monitor.h
//  AFNetworking
//
//  Created by beilu on 2021/11/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Monitor)

/** View's X Position */
@property (nonatomic, assign) CGFloat   monitor_x;

/** View's Y Position */
@property (nonatomic, assign) CGFloat   monitor_y;

/** View's width */
@property (nonatomic, assign) CGFloat   monitor_width;

/** View's height */
@property (nonatomic, assign) CGFloat   monitor_height;

/** View's origin - Sets X and Y Positions */
@property (nonatomic, assign) CGPoint   monitor_origin;

/** View's size - Sets Width and Height */
@property (nonatomic, assign) CGSize    monitor_size;

/** Y value representing the bottom of the view **/
@property (nonatomic, assign) CGFloat   monitor_bottom;

/** X Value representing the right side of the view **/
@property (nonatomic, assign) CGFloat   monitor_right;

/** X Value representing the top of the view (alias of x) **/
@property (nonatomic, assign) CGFloat   monitor_left;

/** Y Value representing the top of the view (alias of y) **/
@property (nonatomic, assign) CGFloat   monitor_top;

/** X value of the object's center **/
@property (nonatomic, assign) CGFloat   monitor_centerX;

/** Y value of the object's center **/
@property (nonatomic, assign) CGFloat   monitor_centerY;

- (UIViewController *)monitor_viewController;

@end

NS_ASSUME_NONNULL_END
