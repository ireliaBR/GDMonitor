//
//  UIView+Monitor.m
//  AFNetworking
//
//  Created by beilu on 2021/11/10.
//

#import "UIView+Monitor.h"

#define Monitor_SCREEN_SCALE                    ([[UIScreen mainScreen] scale])
#define Monitor_PIXEL_INTEGRAL(pointValue)      (round(pointValue * Monitor_SCREEN_SCALE) / Monitor_SCREEN_SCALE)

@implementation UIView (Monitor)

@dynamic monitor_x, monitor_y, monitor_width, monitor_height, monitor_origin, monitor_size;

// Setters
-(void)setMonitor_x:(CGFloat)x{
    self.frame      = CGRectMake(Monitor_PIXEL_INTEGRAL(x), self.monitor_y, self.monitor_width, self.monitor_height);
}

-(void)setMonitor_y:(CGFloat)y{
    self.frame      = CGRectMake(self.monitor_x, Monitor_PIXEL_INTEGRAL(y), self.monitor_width, self.monitor_height);
}

-(void)setMonitor_width:(CGFloat)width{
    self.frame      = CGRectMake(self.monitor_x, self.monitor_y, Monitor_PIXEL_INTEGRAL(width), self.monitor_height);
}

-(void)setMonitor_height:(CGFloat)height{
    self.frame      = CGRectMake(self.monitor_x, self.monitor_y, self.monitor_width, Monitor_PIXEL_INTEGRAL(height));
}

-(void)setMonitor_origin:(CGPoint)origin{
    self.monitor_x          = origin.x;
    self.monitor_y          = origin.y;
}

-(void)setMonitor_size:(CGSize)size{
    self.monitor_width      = size.width;
    self.monitor_height     = size.height;
}

-(void)setMonitor_right:(CGFloat)right {
    self.monitor_x          = right - self.monitor_width;
}

-(void)setMonitor_bottom:(CGFloat)bottom {
    self.monitor_y          = bottom - self.monitor_height;
}

-(void)setMonitor_left:(CGFloat)left{
    self.monitor_x          = left;
}

-(void)setMonitor_top:(CGFloat)top{
    self.monitor_y          = top;
}

-(void)setMonitor_centerX:(CGFloat)centerX {
    self.center     = CGPointMake(Monitor_PIXEL_INTEGRAL(centerX), self.center.y);
}

-(void)setMonitor_centerY:(CGFloat)centerY {
    self.center     = CGPointMake(self.center.x, Monitor_PIXEL_INTEGRAL(centerY));
}

// Getters
-(CGFloat)monitor_x{
    return self.frame.origin.x;
}

-(CGFloat)monitor_y{
    return self.frame.origin.y;
}

-(CGFloat)monitor_width{
    return self.frame.size.width;
}

-(CGFloat)monitor_height{
    return self.frame.size.height;
}

-(CGPoint)monitor_origin{
    return CGPointMake(self.monitor_x, self.monitor_y);
}

-(CGSize)monitor_size{
    return CGSizeMake(self.monitor_width, self.monitor_height);
}

-(CGFloat)monitor_right {
    return self.frame.origin.x + self.frame.size.width;
}

-(CGFloat)monitor_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

-(CGFloat)monitor_left{
    return self.monitor_x;
}

-(CGFloat)monitor_top{
    return self.monitor_y;
}

-(CGFloat)monitor_centerX {
    return self.center.x;
}

-(CGFloat)monitor_centerY {
    return self.center.y;
}

-(UIViewController *)monitor_viewController{
    for(UIView *next =self.superview ; next ; next = next.superview){
        UIResponder*nextResponder = [next nextResponder];
        if([nextResponder isKindOfClass:[UIViewController class]]){
            return(UIViewController*)nextResponder;
        }
    }
    return nil;
}

@end
