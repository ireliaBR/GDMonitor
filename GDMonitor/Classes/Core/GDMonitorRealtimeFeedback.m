//
//  GDMonitorRealtimeFeedback.m
//  AFNetworking
//
//  Created by beilu on 2021/11/9.
//

#import "GDMonitorRealtimeFeedback.h"
#import "GDMonitorCPUUtil.h"
#import "GDMonitorMemoryUtil.h"
#import "GDMonitorFPSUtil.h"

@interface GDMonitorRealtimeFeedback()

@property (nonatomic, strong) GDMonitorFPSUtil *fpsUtil;
@property (nonatomic, strong) NSHashTable<id<GDMonitorRealtimeFeedbackDelegate>> *delegates;

@end

@implementation GDMonitorRealtimeFeedback

+ (GDMonitorRealtimeFeedback *)feedback {
    static GDMonitorRealtimeFeedback *ME = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ME = [GDMonitorRealtimeFeedback new];
    });
    return ME;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        __weak __typeof(&*self) weakSelf = self;
        self.fpsUtil = [GDMonitorFPSUtil new];
        [self.fpsUtil addFPSBlock:^(NSInteger fps) {
            weakSelf.memory = [GDMonitorMemoryUtil useMemoryForApp];
            weakSelf.cpu = [GDMonitorCPUUtil cpuUsageForApp] * 100;
            weakSelf.fps = fps;
            for (id<GDMonitorRealtimeFeedbackDelegate> delegate in weakSelf.delegates.allObjects) {
                if ([delegate respondsToSelector:@selector(feedbackMemory:)]) {
                    [delegate feedbackMemory:weakSelf.memory];
                }
                if ([delegate respondsToSelector:@selector(feedbackFPS:)]) {
                    [delegate feedbackFPS:weakSelf.fps];
                }
                if ([delegate respondsToSelector:@selector(feedbackCPU:)]) {
                    [delegate feedbackCPU:weakSelf.cpu];
                }
            }
        }];
    }
    return self;
}

- (void)addDelegate:(id<GDMonitorRealtimeFeedbackDelegate>)delegate {
    if ([self.delegates.allObjects containsObject:delegate]) {
        return;
    }
    [self.delegates addObject:delegate];
}

- (void)start {
    [self.fpsUtil start];
}

- (void)end {
    [self.fpsUtil end];
}

- (NSHashTable<id<GDMonitorRealtimeFeedbackDelegate>> *)delegates {
    if (!_delegates) {
        _delegates = [NSHashTable weakObjectsHashTable];
    }
    return _delegates;
}

@end
