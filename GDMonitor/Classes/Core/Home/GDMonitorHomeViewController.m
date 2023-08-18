//
//  GDMonitorHomeViewController.m
//  GDMonitor
//
//  Created by beilu on 2021/11/10.
//

#import "GDMonitorHomeViewController.h"
#import "GDmonitorCacheManager.h"
#import "GDMonitorOscillogramWindow.h"
#import "GDMonitorFPSOscillogramWindow.h"
#import "GDMonitorCPUOscillogramWindow.h"
#import "GDMonitorMemoryOscillogramWindow.h"
#import "GDMonitorMemoryBlockController.h"

@interface GDMonitorHomeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation GDMonitorHomeViewController

// MARK: - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"性能监控";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

// MARK: - Override

// MARK: - Public

// MARK: - Private Setup

- (void)switchAction:(UISwitch *)view {
    GDMonitorOscillogramWindow *window = nil;
    switch (view.tag) {
        case 0:
            window = GDMonitorCPUOscillogramWindow.shareInstance;
            break;
        case 1:
            window = GDMonitorFPSOscillogramWindow.shareInstance;
            break;
        case 2:
            window = GDMonitorMemoryOscillogramWindow.shareInstance;
            break;
            
        default:
            break;
    }
    if (view.on) {
        [window show];
    } else {
        [window hide];
    }
}

// MARK: - Private

// MARK: - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    UISwitch *switchView = [UISwitch new];
    [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    switchView.tag = indexPath.row;
    cell.accessoryView = switchView;
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"CPU";
            switchView.on = GDMonitorCacheManager.manager.cpuSwitch;
            break;
        case 1:
            cell.textLabel.text = @"FPS";
            switchView.on = GDMonitorCacheManager.manager.fpsSwitch;
            break;
        case 2:
            cell.textLabel.text = @"Memory";
            switchView.on = GDMonitorCacheManager.manager.memorySwitch;
            break;
        case 3:
            cell.textLabel.text = @"内存";
            cell.accessoryView = nil;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 3) {
        GDMonitorMemoryBlockController *memoryBlockCtrl = [GDMonitorMemoryBlockController new];
        [self.navigationController pushViewController:memoryBlockCtrl animated:YES];
    }
}

// MARK: - Custom Accessors

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"UITableViewCell"];
    }
    return _tableView;
}

@end
