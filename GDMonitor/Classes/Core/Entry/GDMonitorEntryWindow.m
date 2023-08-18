//
//  GDMonitorEntryWindow.m
//  GDMonitor
//
//  Created by beilu on 2021/11/9.
//

#import "GDMonitorEntryWindow.h"
#import "GDMonitorDefine.h"
#import "GDMonitorStatusBarViewController.h"
#import "GDMonitorEntryItemView.h"
#import "GDMonitorRealtimeFeedback.h"
#import "GDMonitorHomeWindow.h"
@import Masonry;

static NSInteger const kMonitorLimitMemory = 500;
static NSInteger const kMonitorLimitFPS = 45;
static CGFloat const kMonitorLimitCPU = 85;

@interface GDMonitorEntryWindow() <GDMonitorRealtimeFeedbackDelegate>

@property (nonatomic, strong) UIButton *backgroundBtn;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) GDMonitorEntryItemView *cpuItemView;
@property (nonatomic, strong) GDMonitorEntryItemView *fpsItemView;
@property (nonatomic, strong) GDMonitorEntryItemView *memoryItemView;

@property (nonatomic, assign) CGFloat kEntryViewSize;
@property (nonatomic, assign) CGPoint startingPosition;

@end

@implementation GDMonitorEntryWindow

// MARK: - LifeCycle

- (instancetype)initWithStartPoint:(CGPoint)startingPosition {
    self.startingPosition = startingPosition;
    self.kEntryViewSize = 76;
    CGFloat x = self.startingPosition.x;
    CGFloat y = self.startingPosition.y;
    CGPoint defaultPosition = GDMonitorStartingPosition;
    if (x < 0 || x > (GDMonitorScreenWidth - self.kEntryViewSize)) {
        x = defaultPosition.x;
    }
    
    if (y < 0 || y > (GDMonitorScreenHeight - self.kEntryViewSize)) {
        y = defaultPosition.y;
    }
    
    self = [super initWithFrame:CGRectMake(x, y, self.kEntryViewSize, self.kEntryViewSize)];
    if (self) {
        #if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
            if (@available(iOS 13.0, *)) {
                UIScene *scene = [[UIApplication sharedApplication].connectedScenes anyObject];
                if (scene) {
                    self.windowScene = (UIWindowScene *)scene;
                }
            }
        #endif
        self.backgroundColor = [UIColor clearColor];
        self.windowLevel = UIWindowLevelStatusBar + 100.f;
        self.layer.masksToBounds = YES;
        
        // 统一使用 DoraemonStatusBarViewController
        // 对系统的版本处理放入 DoraemonStatusBarViewController 类中
        if (!self.rootViewController) {
            self.rootViewController = [GDMonitorStatusBarViewController new];
        }

        [self.rootViewController.view addSubview:self.stackView];
        [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.rootViewController.view).inset(5);
        }];
        
        [self.rootViewController.view addSubview:self.backgroundBtn];
        [self.backgroundBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.rootViewController.view);
        }];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

// MARK: - Override

// MARK: - Public

- (void)show {
    self.hidden = NO;
    [GDMonitorRealtimeFeedback.feedback addDelegate:self];
    [GDMonitorRealtimeFeedback.feedback start];
}

- (void)setAutoDock:(BOOL)autoDock {
    _autoDock = autoDock;
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"FloatViewCenterLocation"];
    if (dict && dict[@"x"] && dict[@"y"]) {
        self.center = CGPointMake([dict[@"x"] integerValue], [dict[@"y"] integerValue]);
    }
}

// MARK: - Private Setup

- (void)pan:(UIPanGestureRecognizer *)pan{
    if (self.autoDock) {
        [self __autoDocking:pan];
    }else{
        [self __normalMode:pan];
    }
}

- (void)backgroundBtnAction:(UIButton *)btn {
    if ([GDMonitorHomeWindow shareInstance].hidden) {
        [[GDMonitorHomeWindow shareInstance] show];
    }else{
        [[GDMonitorHomeWindow shareInstance] hide];
    }
}

// MARK: - Private

- (void)__normalMode:(UIPanGestureRecognizer *)panGestureRecognizer{
    //1、获得拖动位移
    CGPoint offsetPoint = [panGestureRecognizer translationInView:panGestureRecognizer.view];
    //2、清空拖动位移
    [panGestureRecognizer setTranslation:CGPointZero inView:panGestureRecognizer.view];
    //3、重新设置控件位置
    UIView *panView = panGestureRecognizer.view;
    CGFloat newX = panView.center.x + offsetPoint.x;
    CGFloat newY = panView.center.y + offsetPoint.y;
    if (newX < self.kEntryViewSize/2) {
        newX = self.kEntryViewSize/2;
    }
    if (newX > GDMonitorScreenWidth - self.kEntryViewSize/2) {
        newX = GDMonitorScreenWidth - self.kEntryViewSize/2;
    }
    if (newY < self.kEntryViewSize/2) {
        newY = self.kEntryViewSize/2;
    }
    if (newY > GDMonitorScreenHeight - self.kEntryViewSize/2) {
        newY = GDMonitorScreenHeight - self.kEntryViewSize/2;
    }
    panView.center = CGPointMake(newX, newY);
}

- (void)__autoDocking:(UIPanGestureRecognizer *)panGestureRecognizer {
    UIView *panView = panGestureRecognizer.view;
    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [panGestureRecognizer translationInView:panView];
            [panGestureRecognizer setTranslation:CGPointZero inView:panView];
            panView.center = CGPointMake(panView.center.x + translation.x, panView.center.y + translation.y);
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            CGPoint location = panView.center;
            CGFloat centerX;
            CGFloat safeBottom = 0;
            if (@available(iOS 11.0, *)) {
               safeBottom = self.safeAreaInsets.bottom;
            }
            CGFloat centerY = MAX(MIN(location.y, CGRectGetMaxY([UIScreen mainScreen].bounds) - safeBottom), [UIApplication sharedApplication].statusBarFrame.size.height);
            if(location.x > CGRectGetWidth([UIScreen mainScreen].bounds) / 2.f)
            {
                centerX = CGRectGetWidth([UIScreen mainScreen].bounds) - self.kEntryViewSize/2;
            }
            else
            {
                centerX = self.kEntryViewSize / 2;
            }
            [[NSUserDefaults standardUserDefaults] setObject:@{
                                                               @"x":[NSNumber numberWithFloat:centerX],
                                                               @"y":[NSNumber numberWithFloat:centerY]
                                                               } forKey:@"FloatViewCenterLocation"];
            [UIView animateWithDuration:0.3 animations:^{
                panView.center = CGPointMake(centerX, centerY);
            }];
        }

        default:
            break;
    }
}

- (UIColor *)__colorWithCurrent:(CGFloat)current limit:(CGFloat)limit {
    return current >= limit ? [UIColor redColor] : UIColorFromRGB(0x3D3939);
}

// MARK: - GDMonitorRealtimeFeedbackDelegate

- (void)feedbackMemory:(NSInteger)memory {
    self.memoryItemView.text = [NSString stringWithFormat:@"%ld", (long)memory];
    self.memoryItemView.color = [self __colorWithCurrent:memory limit:kMonitorLimitMemory];
}

- (void)feedbackCPU:(CGFloat)CPU {
    self.cpuItemView.text = [NSString stringWithFormat:@"%.1f%%", CPU];
    self.cpuItemView.color = [self __colorWithCurrent:CPU limit:kMonitorLimitCPU];
}

- (void)feedbackFPS:(NSInteger)FPS {
    self.fpsItemView.text = [NSString stringWithFormat:@"%ld", (long)FPS];
    self.fpsItemView.color = [self __colorWithCurrent:1.f / FPS limit: 1.f / kMonitorLimitFPS];
}

// MARK: - Custom Accessors

- (UIButton *)backgroundBtn {
    if (!_backgroundBtn) {
        _backgroundBtn = [UIButton new];
        _backgroundBtn.backgroundColor = UIColorFromRGBA(0x000000, 0.4);
        [_backgroundBtn addTarget:self action:@selector(backgroundBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backgroundBtn;
}

- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.cpuItemView, self.fpsItemView, self.memoryItemView]];
        _stackView.axis = UILayoutConstraintAxisVertical;
        _stackView.distribution = UIStackViewDistributionFillEqually;
        _stackView.alignment = UIStackViewAlignmentFill;
    }
    return _stackView;
}

- (GDMonitorEntryItemView *)cpuItemView {
    if (!_cpuItemView) {
        _cpuItemView = [GDMonitorEntryItemView new];
        _cpuItemView.memo = @"CPU";
    }
    return _cpuItemView;
}

- (GDMonitorEntryItemView *)fpsItemView {
    if (!_fpsItemView) {
        _fpsItemView = [GDMonitorEntryItemView new];
        _fpsItemView.memo = @"FPS";
    }
    return _fpsItemView;
}

- (GDMonitorEntryItemView *)memoryItemView {
    if (!_memoryItemView) {
        _memoryItemView = [GDMonitorEntryItemView new];
        _memoryItemView.memo = @"MB";
    }
    return _memoryItemView;
}

@end
