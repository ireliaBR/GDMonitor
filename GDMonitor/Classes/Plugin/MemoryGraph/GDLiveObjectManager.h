//
//  GDLiveObjectManager.h
//  GDMonitor
//
//  Created by fdd on 2023/8/18.
//

#import <Foundation/Foundation.h>
#import "GDHeapUtil.h"

NS_ASSUME_NONNULL_BEGIN

@interface GDLiveObjectManager : NSObject

@property (nonatomic, strong, readonly) GDHeapSnapshot *snapshot;

- (void)loadLiveObject;

@end

NS_ASSUME_NONNULL_END
