//
//  GDMonitorOscillogramViewController.m
//  AFNetworking
//
//  Created by beilu on 2021/11/10.
//

#import "GDMonitorOscillogramViewController.h"
#import "GDMonitorOscillogramWindowManager.h"
#import "GDMonitorDefine.h"
#import "UIView+Monitor.h"
#import "UIImage+Monitor.h"

@interface GDMonitorOscillogramViewController ()

//每秒运行一次
@property (nonatomic, strong) NSTimer *secondTimer;

@end

@implementation GDMonitorOscillogramViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = [self title];
    titleLabel.font = [UIFont systemFontOfSize:kGDMonitorSizeFrom750_Landscape(20)];
    titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLabel];
    [titleLabel sizeToFit];
    titleLabel.frame = CGRectMake(kGDMonitorSizeFrom750_Landscape(20), kGDMonitorSizeFrom750_Landscape(10), titleLabel.monitor_width, titleLabel.monitor_height);
    
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn setImage:[UIImage monitor_xcassetImageNamed:@"monitor_close_white"] forState:UIControlStateNormal];
    closeBtn.frame = CGRectMake((kInterfaceOrientationPortrait ? GDMonitorScreenWidth : GDMonitorScreenHeight)-kGDMonitorSizeFrom750_Landscape(80), 0, kGDMonitorSizeFrom750_Landscape(80), kGDMonitorSizeFrom750_Landscape(80));
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    _closeBtn = closeBtn;
    
    _oscillogramView = [[GDMonitorOscillogramView alloc] initWithFrame:CGRectMake(0, titleLabel.monitor_bottom+kGDMonitorSizeFrom750_Landscape(12), (kInterfaceOrientationPortrait ? GDMonitorScreenWidth : GDMonitorScreenHeight), kGDMonitorSizeFrom750_Landscape(184))];
    _oscillogramView.backgroundColor = [UIColor clearColor];
    [_oscillogramView setLowValue:[self lowValue]];
    [_oscillogramView setHightValue:[self highValue]];
    [self.view addSubview:_oscillogramView];
}

- (NSString *)title{
    return @"";
}

- (NSString *)lowValue{
    return @"0";
}

- (NSString *)highValue{
    return @"100";
}

- (void)closeBtnClick{
}

- (void)startRecord{
    if(!_secondTimer){
//        _secondTimer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(doSecondFunction) userInfo:nil repeats:YES];
//        [[NSRunLoop currentRunLoop] addTimer:_secondTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)doSecondFunction{
    
}

- (void)endRecord{
    if(_secondTimer){
        [_secondTimer invalidate];
        _secondTimer = nil;
        [self.oscillogramView clear];
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[GDMonitorOscillogramWindowManager shareInstance] resetLayout];
    });
}

@end
