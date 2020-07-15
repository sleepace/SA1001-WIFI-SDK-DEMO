//
//  AromaTimeListViewController.m
//  SA1001-2-demo
//
//  Created by jie yang on 2018/11/14.
//  Copyright © 2018年 jie yang. All rights reserved.
//

#import "AromaTimeListViewController.h"

#import "TitleValueSwitchCellTableViewCell.h"
#import "SLPTimingDataModel.h"

#import "AromaTimeViewController.h"
#import <SA1001/SA1001.h>
#import <SA1001/SALTimeAromaInfo.h>

@interface AromaTimeListViewController ()<UITableViewDelegate, UITableViewDataSource, AromaTimeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSArray *aromaTimeList;
@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (weak, nonatomic) IBOutlet UILabel *emptyLabel;

@end

@implementation AromaTimeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self  setUI];
    
    [self loadData];
}

- (void)loadData
{
    __weak typeof(self) weakSelf = self;
    [SLPSharedMLanManager sal:SharedDataManager.deviceName getTimeAromaTimeout:0 callback:^(SLPDataTransferStatus status, id data) {
        NSArray *timeList = data;
        self.aromaTimeList = timeList;
        if (self.aromaTimeList && self.aromaTimeList.count > 0) {
            self.emptyView.hidden = YES;
            self.tableView.hidden = NO;
            [weakSelf.tableView reloadData];
        }else{
            self.emptyView.hidden = NO;
            self.tableView.hidden = YES;
        }
    }];
}

- (void)setUI
{
    self.titleLabel.text = LocalizedString(@"sa_timer_on");
    
    [self.addBtn setTitle:LocalizedString(@"add") forState:UIControlStateNormal];
    
    self.emptyLabel.text = LocalizedString(@"sa_no_timer");
    
    if (self.aromaTimeList && self.aromaTimeList.count > 0) {
        self.emptyView.hidden = YES;
        self.tableView.hidden = NO;
    }else{
        self.emptyView.hidden = NO;
        self.tableView.hidden = YES;
    }
}


- (IBAction)goAddAromaTime:(id)sender {
    if (self.aromaTimeList.count >= 5) {
        [Utils showMessage:LocalizedString(@"more_5") controller:self];
        return;
    }
    
    SALTimeAromaInfo *aromaInfo = [self.aromaTimeList lastObject];
    NSInteger ID = aromaInfo.ID + 1;
    
    AromaTimeViewController *vc = [AromaTimeViewController new];
    vc.addID = ID;
    vc.delegate = self;
    vc.pageType = AromaTimePageType_Add;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.aromaTimeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TitleValueSwitchCellTableViewCell *cell = (TitleValueSwitchCellTableViewCell *)[SLPUtils tableView:tableView cellNibName:@"TitleValueSwitchCellTableViewCell"];
    
    SALTimeAromaInfo *timeData = [self.aromaTimeList objectAtIndex:indexPath.row];
    cell.titleLabel.text = [SLPUtils timeStringFrom:timeData.hour minute:timeData.minute isTimeMode24:[SLPUtils isTimeMode24]];
    
    NSInteger hour = timeData.duration / 60;
    NSInteger minute = timeData.duration % 60;
    
    if (minute == 0) {
        cell.subTitleLbl.text = [NSString stringWithFormat:@"%@: %ld%@", LocalizedString(@"sa_last_time"), hour, LocalizedString(@"hour")];
    }else if (hour == 0){
        cell.subTitleLbl.text = [NSString stringWithFormat:@"%@: %ld%@", LocalizedString(@"sa_last_time"), minute, LocalizedString(@"min")];
    }else{
        cell.subTitleLbl.text = [NSString stringWithFormat:@"%@: %ld%@%ld%@", LocalizedString(@"sa_last_time"), hour, LocalizedString(@"hour"), minute, LocalizedString(@"min")];
    }
    
    cell.switcher.on = timeData.enable;
    
    __weak typeof(self) weakSelf = self;
    cell.switchBlock = ^(UISwitch *sender) {
        [weakSelf turnTimeInfoWithTimeInfo:timeData isOpen:sender.on];
    };
    
    return cell;
}

- (void)turnTimeInfoWithTimeInfo:(SALTimeAromaInfo *)timeInfo isOpen:(BOOL)isOpen
{
    BOOL oriEnable = timeInfo.enable;
    
    timeInfo.enable = isOpen;
    
    if (![SLPBLESharedManager blueToothIsOpen]) {
        timeInfo.enable = oriEnable;
        [self.tableView reloadData];
        [Utils showMessage:LocalizedString(@"phone_bluetooth_not_open") controller:self];
        return;
    }
    __weak typeof(self) weakSelf = self;
    [SLPSharedMLanManager sal:SharedDataManager.deviceName editeTimeAromaList:self.aromaTimeList timeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (status != SLPDataTransferStatus_Succeed) {
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
            timeInfo.enable = oriEnable;
            [weakSelf.tableView reloadData];
        }
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SALTimeAromaInfo *timeData = [self.aromaTimeList objectAtIndex:indexPath.row];
    [self goAromeTimePageWith:timeData];
}

- (void)goAromeTimePageWith:(SALTimeAromaInfo *)timeData
{
    SLPTimingDataModel *dataModel = [[SLPTimingDataModel alloc] init];
    dataModel.hour = timeData.hour;
    dataModel.minute = timeData.minute;
    dataModel.isOpen = timeData.flag;
    dataModel.seqId = @(timeData.ID);
    dataModel.lastMin = timeData.duration;
    
    AromaTimeViewController *vc = [AromaTimeViewController new];
    vc.delegate = self;
    vc.pageType = AromaTimePageType_edit;
    vc.originTimeData = dataModel;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)editAromaTimeAndShouldReload
{
    [self loadData];
}
@end
