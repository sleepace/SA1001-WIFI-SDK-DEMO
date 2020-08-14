//
//  AlarmListViewController.m
//  SA1001-2-demo
//
//  Created by jie yang on 2018/11/13.
//  Copyright © 2018年 jie yang. All rights reserved.
//

#import "AlarmListViewController.h"

#import "SLPWeekDay.h"
#import "AlarmDataModel.h"
#import "AlarmViewController.h"
#import "TitleValueSwitchCellTableViewCell.h"

#import <SLPTCP/SA1001AlarmInfo.h>

@interface AlarmListViewController ()<UITableViewDataSource, UITableViewDelegate, AlarmViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (weak, nonatomic) IBOutlet UILabel *emptyLbl;
@property (nonatomic, copy) NSArray *alramList;

@end

@implementation AlarmListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadData];
    
    [self setUI];
}

- (void)loadData
{
    __weak typeof(self) weakSelf = self;
    [SLPSharedHTTPManager getAlarmListWithDeviceInfo:SharedDataManager.deviceName deviceType:SLPDeviceType_Sal timeOut:0 completion:^(BOOL result, id  _Nonnull responseObject, NSString * _Nonnull error) {
        if (result) {
            NSDictionary *data = responseObject[@"data"];
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSString *configJson = data[@"configJson"];
                if (configJson) {
                    NSData *jsonData = [configJson dataUsingEncoding:NSUTF8StringEncoding];
                    NSError *err;
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
                    
                    NSArray *alarms = dic[@"alarms"];
                    NSMutableArray *alramList = [NSMutableArray array];
                    if ([alarms isKindOfClass:[NSArray class]]) {
                        NSInteger count = alarms.count;
                        for (int i = 0; i < count; i++) {
                            NSDictionary *alarmDic = [alarms objectAtIndex:i];
                            
                            SA1001AlarmInfo *info = [SA1001AlarmInfo new];
                            info.alarmID = [alarmDic[@"alarmId"] longLongValue];
                            info.isOpen = [alarmDic[@"alarmFlag"] boolValue];
                            info.hour = [alarmDic[@"hour"] integerValue];
                            info.minute = [alarmDic[@"min"] integerValue];
                            info.flag = [alarmDic[@"week"] integerValue];
                            info.snoozeTime = [alarmDic[@"lazyTime"] integerValue];
                            info.snoozeLength = [alarmDic[@"lazyTimes"] integerValue];
                            info.volume = [alarmDic[@"volum"] integerValue];
                            info.brightness = [alarmDic[@"lightStrength"] integerValue];
                            info.shake = [alarmDic[@"oscillator"] boolValue];
                            info.musicID = [alarmDic[@"musicId"] integerValue];

                            info.aromaRate = [alarmDic[@"aromatherapyRate"] integerValue];
                            info.timestamp = [alarmDic[@"timeStamp"] intValue];
                            info.smartFlag = [alarmDic[@"smartFlag"] intValue];
                            info.smartOffset = [alarmDic[@"smartOffset"] intValue];

                            [alramList addObject:info];
                        }
                    }
                    
                    weakSelf.alramList = alramList;
                    if (weakSelf.alramList && weakSelf.alramList.count > 0) {
                        weakSelf.emptyView.hidden = YES;
                        weakSelf.tableView.hidden = NO;
                        [weakSelf.tableView reloadData];
                    }else{
                        weakSelf.emptyView.hidden = NO;
                        weakSelf.tableView.hidden = YES;
                    }
                }
            }
        }

    }];
}

- (void)setUI
{
    self.titleLabel.text = LocalizedString(@"alarm");
    self.emptyLbl.text = LocalizedString(@"sa_no_alarm");
    [self.addButton setTitle:LocalizedString(@"add") forState:UIControlStateNormal];
    
    if (self.alramList && self.alramList.count > 0) {
        self.tableView.hidden = NO;
        self.emptyView.hidden = YES;
    }else{
        self.tableView.hidden = YES;
        self.emptyView.hidden = NO;
    }
}

- (IBAction)addAlarm:(id)sender {
    [self goAddAlarm];
}

- (void)goAddAlarm
{
    if (self.alramList.count >= 5) {
        [Utils showMessage:LocalizedString(@"more_5") controller:self];
        return;
    }
    
    SA1001AlarmInfo *alarmInfo = [self.alramList lastObject];
    NSInteger alarmID = alarmInfo.alarmID + 1;
    
    AlarmViewController *vc = [AlarmViewController new];
    vc.addAlarmID = alarmID;
    vc.delegate = self;
    vc.alarmPageType = AlarmPageType_Add;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.alramList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TitleValueSwitchCellTableViewCell *cell = (TitleValueSwitchCellTableViewCell *)[SLPUtils tableView:tableView cellNibName:@"TitleValueSwitchCellTableViewCell"];
    
    SA1001AlarmInfo *alarmData = [self.alramList objectAtIndex:indexPath.row];
    cell.titleLabel.text = [self getAlarmTimeStringWithDataModle:alarmData];
    cell.subTitleLbl.text = [SLPWeekDay getAlarmRepeatDayStringWithWeekDay:alarmData.flag];
    cell.switcher.on = alarmData.isOpen;
    
    __weak typeof(self) weakSelf = self;
    cell.switchBlock = ^(UISwitch *sender) {
        if (sender.on) {
            [weakSelf turnOnAlarmWithAlarm:alarmData];
        }else{
            [weakSelf turnOffAlarmWithAlarm:alarmData];
        }
    };
    
    return cell;
}

- (void)turnOnAlarmWithAlarm:(SA1001AlarmInfo *)alarmInfo
{
    __weak typeof(self) weakSelf = self;
    
    [SLPSharedLTcpManager salEnableAlarm:alarmInfo.alarmID deviceInfo:SharedDataManager.deviceName timeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (status != SLPDataTransferStatus_Succeed) {
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
            [weakSelf.tableView reloadData];
        }else{
            alarmInfo.isOpen = YES;
        }
    }];
}

- (void)turnOffAlarmWithAlarm:(SA1001AlarmInfo *)alarmInfo
{
    __weak typeof(self) weakSelf = self;
    
    [SLPSharedLTcpManager salDisableAlarm:alarmInfo.alarmID deviceInfo:SharedDataManager.deviceName timeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (status != SLPDataTransferStatus_Succeed) {
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
            [weakSelf.tableView reloadData];
        }else{
            alarmInfo.isOpen = YES;
        }
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SA1001AlarmInfo *alarmData = [self.alramList objectAtIndex:indexPath.row];
    
    [self goAlarmVCWithAlarmData:alarmData];
}

- (void)goAlarmVCWithAlarmData:(SA1001AlarmInfo *)alarmData
{
    AlarmViewController *vc = [AlarmViewController new];
    vc.delegate = self;
    vc.orignalAlarmData = alarmData;
    vc.alarmPageType = AlarmPageType_edit;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSString *)getAlarmTimeStringWithDataModle:(SA1001AlarmInfo *)dataModel {
    return [SLPUtils timeStringFrom:dataModel.hour minute:dataModel.minute isTimeMode24:[SLPUtils isTimeMode24]];
}

- (void)editAlarmInfoAndShouldReload
{
    [self loadData];
}
@end
