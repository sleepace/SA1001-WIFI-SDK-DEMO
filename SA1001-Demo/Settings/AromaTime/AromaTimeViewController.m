//
//  AromaTimeViewController.m
//  SA1001-2-demo
//
//  Created by jie yang on 2018/11/14.
//  Copyright © 2018年 jie yang. All rights reserved.
//

#import "AromaTimeViewController.h"

#import "TitleSubTitleArrowCell.h"
#import <SA1001/SALTimeAromaInfo.h>
#import <SA1001/SA1001.h>
#import "TimePickerSelectView.h"
#import "HourMinutePicker.h"
#import <SLPMLan/SLPLanTCPCommon.h>


@interface AromaTimeViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property (nonatomic, strong) SLPTimingDataModel *timeDataNew;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@end

@implementation AromaTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}

- (void)setUI
{
    
    if (self.pageType == AromaTimePageType_edit) {
        self.timeDataNew = self.originTimeData;
        self.titleLabel.text = LocalizedString(@"edit_timer");
        [self.timeDataNew fillDataWith:self.originTimeData];
        self.deleteBtn.hidden = NO;
    }else{
        self.timeDataNew = [[SLPTimingDataModel alloc] init];
        self.titleLabel.text = LocalizedString(@"add_timer");
        self.deleteBtn.hidden = YES;
    }
    
    [self.deleteBtn setTitle:LocalizedString(@"sa_delete") forState:UIControlStateNormal];
    [self.deleteBtn setTitleColor:[Theme C7] forState:UIControlStateNormal];
    [self.saveBtn setTitle:LocalizedString(@"save") forState:UIControlStateNormal];
}


- (IBAction)saveAction:(id)sender {
    
    SALTimeAromaInfo *info = [[SALTimeAromaInfo alloc] init];
    info.hour = self.timeDataNew.hour;
    info.minute = self.timeDataNew.minute;
    info.duration = self.timeDataNew.lastMin;
    if (self.pageType == AromaTimePageType_Add) {
        info.ID = self.addID;
    }else{
        info.ID = [self.timeDataNew.seqId intValue];
    }
    info.enable = YES;
    info.flag = 0x7f;
    info.rate = 2;
    
    NSArray *timeList = [NSArray arrayWithObjects:info, nil];
    
    if (![SLPLanTCPCommon isReachableViaWiFi]) {
        [Utils showMessage:LocalizedString(@"wifi_not_connected") controller:self];
        return;
    }
    
     [self showLoadingView];
    __weak typeof(self) weakSelf = self;
    [SLPSharedMLanManager sal:SharedDataManager.deviceName editeTimeAromaList:timeList timeout:0 callback:^(SLPDataTransferStatus status, id data) {
        [weakSelf unshowLoadingView];
        if (status != SLPDataTransferStatus_Succeed) {
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
        }else{
            if ([weakSelf.delegate respondsToSelector:@selector(editAromaTimeAndShouldReload)]) {
                [weakSelf.delegate editAromaTimeAndShouldReload];
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TitleSubTitleArrowCell *cell = (TitleSubTitleArrowCell *)[SLPUtils tableView:tableView cellNibName:@"TitleSubTitleArrowCell"];
    if (indexPath.row == 0) {
        cell.titleLabel.text = LocalizedString(@"sa_start_time");
        
        cell.subTitleLabel.text = [SLPUtils timeStringFrom:self.timeDataNew.hour minute:self.timeDataNew.minute isTimeMode24:[SLPUtils isTimeMode24]];
    }else {
        cell.titleLabel.text =LocalizedString(@"sa_last_time");
        
        NSInteger hour = self.timeDataNew.lastMin / 60;
        NSInteger minute = self.timeDataNew.lastMin % 60;
        
        if (minute == 0) {
            cell.subTitleLabel.text = [NSString stringWithFormat:@"%ld%@", hour, LocalizedString(@"hour")];
        }else if (hour == 0){
            cell.subTitleLabel.text = [NSString stringWithFormat:@"%ld%@", minute, LocalizedString(@"min")];
        }else{
            cell.subTitleLabel.text = [NSString stringWithFormat:@"%ld%@%ld%@", hour, LocalizedString(@"hour"), minute, LocalizedString(@"min")];
        }
        
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        [self showTimePicker];
    }else if (indexPath.row == 1){
        [self showHourMinutePicker];
    }

}

- (void)showHourMinutePicker
{
    NSInteger hour = self.timeDataNew.lastMin / 60;
    NSInteger minute = self.timeDataNew.lastMin % 60;
    HourMinutePicker *picker = [HourMinutePicker hourMinutePickerSelectView];
    
    __weak typeof(self) weakSelf = self;
    [picker showInView:[UIApplication sharedApplication].keyWindow hour:hour minute:minute finishHandle:^(NSInteger hour, NSInteger minute) {
        if (hour == 0 && minute == 0) {
            [Utils showMessage:LocalizedString(@"timer_no_0") controller:weakSelf];
            return;
        }
        
        weakSelf.timeDataNew.lastMin = hour * 60 + minute;
        [weakSelf.tableView reloadData];
    } cancelHandle:^{
        
    }];
}

- (void)showTimePicker
{
    SLPTime24 *time24 = [[SLPTime24 alloc] init];
    time24.hour = self.timeDataNew.hour;
    time24.minute = self.timeDataNew.minute;
    
    __weak typeof(self) weakSelf = self;
    TimePickerSelectView *timePick = [TimePickerSelectView timePickerSelectView];
    [timePick showInView:[UIApplication sharedApplication].keyWindow mode:![SLPUtils isTimeMode24] time:time24 finishHandle:^(SLPTime24 * _Nonnull time24) {
        weakSelf.timeDataNew.hour = time24.hour;
        weakSelf.timeDataNew.minute = time24.minute;
        [weakSelf.tableView reloadData];
    } cancelHandle:^{
        
    }];
}

- (IBAction)deleteAction:(id)sender {
    if (![SLPLanTCPCommon isReachableViaWiFi]) {
        [Utils showMessage:LocalizedString(@"wifi_not_connected") controller:self];
        return;
    }
    __weak typeof(self) weakSelf = self;
    UInt64 seqId = [self.timeDataNew.seqId intValue];
    [SLPSharedMLanManager sal:SharedDataManager.deviceName deleteTimeAroma:seqId timeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (status != SLPDataTransferStatus_Succeed) {
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
        }else{
            if ([weakSelf.delegate respondsToSelector:@selector(editAromaTimeAndShouldReload)]) {
                [weakSelf.delegate editAromaTimeAndShouldReload];
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}
@end
