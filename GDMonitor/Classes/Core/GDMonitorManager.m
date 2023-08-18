//
//  GDMonitorManager.m
//  GDMonitor
//
//  Created by beilu on 2021/11/9.
//

#import "GDMonitorManager.h"
#import "GDMonitorEntryWindow.h"
#import "GDMonitorDefine.h"

@interface GDMonitorManager()

@property (nonatomic, strong) GDMonitorEntryWindow *entryWindow;

@end

@implementation GDMonitorManager

// MARK: - LifeCycle

// MARK: - Override

// MARK: - Public

+ (GDMonitorManager *)manager {
    static GDMonitorManager *ME = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ME = [GDMonitorManager new];
    });
    return ME;
}

- (void)install {
    [self __initEntry:GDMonitorStartingPosition];
}

// MARK: - Private Setup

- (void)__initEntry:(CGPoint)startingPosition{
    self.entryWindow = [[GDMonitorEntryWindow alloc] initWithStartPoint:startingPosition];
    [self.entryWindow show];
    self.entryWindow.autoDock = YES;
}

// MARK: - Private

// MARK: - UITableViewDelegate

// MARK: - Custom Accessors

@end
