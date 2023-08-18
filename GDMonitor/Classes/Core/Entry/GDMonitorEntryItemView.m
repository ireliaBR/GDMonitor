//
//  GDMonitorEntryItemView.m
//  GDMonitor
//
//  Created by beilu on 2021/11/9.
//

#import "GDMonitorEntryItemView.h"
#import "GDMonitorDefine.h"
@import Masonry;

@interface GDMonitorEntryItemView()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *memoLabel;

@end

@implementation GDMonitorEntryItemView

// MARK: - LifeCycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.memoLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self);
        }];
        [self.memoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(self);
        }];
    }
    return self;
}

// MARK: - Override

// MARK: - Public

- (void)setColor:(UIColor *)color {
    _color = color;
    self.titleLabel.textColor = color;
    self.memoLabel.textColor = color;
}

- (void)setText:(NSString *)text {
    self.titleLabel.text = text;
}

- (void)setMemo:(NSString *)memo {
    self.memoLabel.text = memo;
}

// MARK: - Private Setup

// MARK: - Private

// MARK: - UITableViewDelegate

// MARK: - Custom Accessors

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
    }
    return _titleLabel;
}

- (UILabel *)memoLabel {
    if (!_memoLabel) {
        _memoLabel = [UILabel new];
        _memoLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
    }
    return _memoLabel;
}

@end
