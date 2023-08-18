//
//  GDMonitorOscillogramViewController.h
//  AFNetworking
//
//  Created by beilu on 2021/11/10.
//

#import <UIKit/UIKit.h>
#import "GDMonitorOscillogramView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GDMonitorOscillogramViewController : UIViewController

@property (nonatomic, strong) GDMonitorOscillogramView *oscillogramView;
@property (nonatomic, strong) UIButton *closeBtn;

- (NSString *)title;
- (NSString *)lowValue;
- (NSString *)highValue;
- (void)closeBtnClick;
- (void)startRecord;
- (void)endRecord;
- (void)doSecondFunction;

@end

NS_ASSUME_NONNULL_END
