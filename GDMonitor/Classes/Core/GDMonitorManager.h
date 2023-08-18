//
//  GDMonitorManager.h
//  GDMonitor
//
//  Created by beilu on 2021/11/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GDMonitorManager : NSObject

@property (nonatomic, strong, readonly, class) GDMonitorManager *manager;

- (void)install;

@end

NS_ASSUME_NONNULL_END
