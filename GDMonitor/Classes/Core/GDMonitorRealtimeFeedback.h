//
//  GDMonitorRealtimeFeedback.h
//  AFNetworking
//
//  Created by beilu on 2021/11/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GDMonitorRealtimeFeedbackDelegate;

@interface GDMonitorRealtimeFeedback : NSObject

@property (nonatomic, strong, readonly, class) GDMonitorRealtimeFeedback *feedback;

@property (nonatomic, assign) NSInteger fps;
@property (nonatomic, assign) NSInteger memory;
@property (nonatomic, assign) CGFloat cpu;

- (void)addDelegate:(id<GDMonitorRealtimeFeedbackDelegate>)delegate;

- (void)start;
- (void)end;

@end

@protocol GDMonitorRealtimeFeedbackDelegate <NSObject>

@optional
- (void)feedbackMemory:(NSInteger)memory;
- (void)feedbackFPS:(NSInteger)FPS;
- (void)feedbackCPU:(CGFloat)CPU;

@end

NS_ASSUME_NONNULL_END
