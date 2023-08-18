//
//  GDMonitorMemoryBlockController.m
//  AFNetworking
//
//  Created by beilu on 2021/12/5.
//

#import "GDMonitorMemoryBlockController.h"
#import "GDHeapUtil.h"
#import "GDLiveObjectManager.h"
@import Masonry;

@interface GDMonitorMemoryBlockController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GDLiveObjectManager *liveObjectManager;

@end

@implementation GDMonitorMemoryBlockController

#pragma mark - 🛩 ClassMethods

#pragma mark - 🚑 LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"live Object";
    [self.liveObjectManager loadLiveObject];
    [self.tableView reloadData];
}

#pragma mark - 🚌 Public

#pragma mark - 🚓 UIEvents

#pragma mark - 👨‍👦Override

#pragma mark - 🚗 Private

#pragma mark - 🚲 Private - Setup

#pragma mark - 🛴 Delegate
#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.liveObjectManager.snapshot.classNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class) forIndexPath:indexPath];
    NSString *className = self.liveObjectManager.snapshot.classNames[indexPath.row];
    NSNumber *count = self.liveObjectManager.snapshot.instanceCountsForClassNames[className];
    NSNumber *size = self.liveObjectManager.snapshot.instanceSizesForClassNames[className];
    unsigned long totalSize = count.unsignedIntegerValue * size.unsignedIntegerValue;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%ld, %@)",
        className, (long)[count integerValue],
        [NSByteCountFormatter
            stringFromByteCount:totalSize
            countStyle:NSByteCountFormatterCountStyleFile
        ]
    ];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - 🛰 KVO

#pragma mark - 🚁 Notification

#pragma mark - 🚚 Custom Accessors

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    }
    return _tableView;
}

- (GDLiveObjectManager *)liveObjectManager {
    if (!_liveObjectManager) {
        _liveObjectManager = [GDLiveObjectManager new];
    }
    return _liveObjectManager;
}

@end
