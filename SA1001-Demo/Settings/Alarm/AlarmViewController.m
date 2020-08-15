//
//  AlarmViewController.m
//  SA1001-2-demo
//
//  Created by jie yang on 2018/11/14.
//  Copyright © 2018年 jie yang. All rights reserved.
//

#import "AlarmViewController.h"

#import "SLPTableSectionData.h"
#import "TitleSwitchCell.h"
#import "SLPWeekDay.h"
#import "SLPViewInfo.h"
#import "SLPLabelFooter.h"
#import "SLPAlarmFooter.h"
#import "SLPMinuteSelectView.h"
#import "WeekdaySelectViewController.h"
#import "MusicListViewController.h"
#import "TitleSubTitleArrowCell.h"
#import "SLPLabelCell.h"
#import "MusicInfo.h"
#import "TimePickerSelectView.h"

#import <SLPTCP/SA1001AlarmInfo.h>
#import <SLPTCP/SLPLTcpCommon.h>

static NSString *const kSection_SetDeviceInfo = @"kSection_SetDeviceInfo";

static NSString *const kRowTime = @"kRowTime";
static NSString *const kRowRepeat = @"kRowRepeat";
static NSString *const kRowMusic = @"kRowMusic";
static NSString *const kRowMusicVolumn = @"kRowMusicVolumn";
static NSString *const kRowLightWake = @"kRowLightWake";
static NSString *const kRowAromaWake = @"kRowAromaWake";
static NSString *const kRowSmartWake = @"kRowSmartWake";
static NSString *const kRowWakeTime = @"kRowWakeTime";
static NSString *const kRowSmartWakeTip = @"kRowSmartWakeTip";

static NSString *const kRowSnooze = @"kRowSnooze";
static NSString *const kRowSnoozeTime = @"kRowSnoozeTime";

@interface AlarmViewController ()<UITableViewDataSource, UITableViewDelegate, SLPAlarmFooterDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray <SLPTableSectionData *>* sectionDataList;

//section的footer
@property (nonatomic, strong) NSMutableArray<SLPViewInfo *> *sectionFooterList;

@property (nonatomic,strong) SLPAlarmFooter *alarmFooter;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property (nonatomic, strong) NSMutableArray *musicList;

@property (strong, nonatomic) SA1001AlarmInfo *alarmDataNew;

@end

@implementation AlarmViewController

-(NSMutableArray *)musicList{
    if (!_musicList) {
        _musicList = [NSMutableArray array];
        
        MusicInfo *musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31051;
        musicInfo.musicName = LocalizedString(@"alarm_list_1");
        [_musicList addObject:musicInfo];
        
        musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31052;
        musicInfo.musicName = LocalizedString(@"alarm_list_2");
        [_musicList addObject:musicInfo];
        
        musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31054;
        musicInfo.musicName = LocalizedString(@"alarm_list_3");
        [_musicList addObject:musicInfo];
        
        musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31055;
        musicInfo.musicName = LocalizedString(@"alarm_list_4");
        [_musicList addObject:musicInfo];
        
        musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31056;
        musicInfo.musicName = LocalizedString(@"alarm_list_5");
        [_musicList addObject:musicInfo];
        
        musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31057;
        musicInfo.musicName = LocalizedString(@"alarm_list_6");
        [_musicList addObject:musicInfo];
        
        musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31058;
        musicInfo.musicName = LocalizedString(@"alarm_list_7");
        [_musicList addObject:musicInfo];
        
        musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31059;
        musicInfo.musicName = LocalizedString(@"alarm_list_8");
        [_musicList addObject:musicInfo];
        
        musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31060;
        musicInfo.musicName = LocalizedString(@"alarm_list_9");
        [_musicList addObject:musicInfo];
    }
    
    return _musicList;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
    [self loadSectionData];
    
    [self createFooterList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)setUI
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15, 0, self.view.frame.size.width - 30, 0.001)];
    self.tableView.tableHeaderView = view;
    self.alarmDataNew = [[SA1001AlarmInfo alloc] init];
    if (self.alarmPageType == AlarmPageType_Add) {
        self.titleLabel.text = LocalizedString(@"add_alarm");
        
        [self initDefaultAlarmData];
    }else{
        self.titleLabel.text = LocalizedString(@"edit_alarm");
        
        [self initAlarmDataWithOriginal];
    }
    
    [self.saveBtn setTitle:LocalizedString(@"save") forState:UIControlStateNormal];
}

- (void)initAlarmDataWithOriginal
{
    self.alarmDataNew.alarmID = self.orignalAlarmData.alarmID;
    self.alarmDataNew.isOpen = self.orignalAlarmData.isOpen;
    self.alarmDataNew.hour = self.orignalAlarmData.hour;
    self.alarmDataNew.minute = self.orignalAlarmData.minute;
    self.alarmDataNew.flag = self.orignalAlarmData.flag;
    self.alarmDataNew.snoozeTime = self.orignalAlarmData.snoozeTime;
    self.alarmDataNew.snoozeLength = self.orignalAlarmData.snoozeLength;
    self.alarmDataNew.volume = self.orignalAlarmData.volume;
    self.alarmDataNew.brightness = self.orignalAlarmData.brightness;
    self.alarmDataNew.shake = self.orignalAlarmData.shake;
    self.alarmDataNew.musicID = self.orignalAlarmData.musicID;
    self.alarmDataNew.aromaRate = self.orignalAlarmData.aromaRate;
    self.alarmDataNew.timestamp = [[NSDate date] timeIntervalSince1970];
    self.alarmDataNew.smartFlag = self.orignalAlarmData.smartFlag;
    self.alarmDataNew.smartOffset = self.orignalAlarmData.smartOffset;
}

- (void)initDefaultAlarmData
{
    self.alarmDataNew.alarmID = self.addAlarmID;
    self.alarmDataNew.isOpen = true;
    self.alarmDataNew.hour = 8;
    self.alarmDataNew.minute = 0;
    self.alarmDataNew.flag = 0;
    self.alarmDataNew.snoozeTime = 0;
    self.alarmDataNew.snoozeLength = 5;
    self.alarmDataNew.volume = 16;
    self.alarmDataNew.brightness = 100;
    self.alarmDataNew.shake = 0;
    self.alarmDataNew.musicID = 31051;
    self.alarmDataNew.aromaRate = 2;
    self.alarmDataNew.timestamp = [[NSDate date] timeIntervalSince1970];
    self.alarmDataNew.smartFlag = 0;
    self.alarmDataNew.smartOffset = 20;
}

- (void)loadSectionData
{
    NSMutableArray *aSectionList = [NSMutableArray array];
    
    SLPTableSectionData *sectionData1 = [[SLPTableSectionData alloc] init];
    sectionData1.sectionEnum = kSection_SetDeviceInfo;
    NSMutableArray *rowEnumList1 = [NSMutableArray arrayWithObjects:kRowTime, kRowRepeat, kRowMusic, kRowMusicVolumn, kRowLightWake, kRowAromaWake, kRowSmartWake, nil];
    if (self.alarmDataNew.smartFlag) {
        [rowEnumList1 addObject:kRowWakeTime];
        [rowEnumList1 addObject:kRowSmartWakeTip];
    }
    [rowEnumList1 addObject:kRowSnooze];

    if (self.alarmDataNew.snoozeTime) {
        [rowEnumList1 addObject:kRowSnoozeTime];
    }
    sectionData1.rowEnumList = rowEnumList1;
    [aSectionList addObject:sectionData1];
    
    self.sectionDataList = aSectionList;
}

//SLPAlarmFooter
- (void)createFooterList{
    //section的数目
    self.sectionFooterList = [NSMutableArray array];
    NSInteger sectionNumber = self.sectionDataList.count;
    for (SLPTableSectionData *section in self.sectionDataList) {
        NSInteger index = [self.sectionDataList indexOfObject:section];
        SLPViewInfo *info = nil;
        if (index == sectionNumber - 1) {//最后一个
            info = [self createLastFooterForSectionName:section.sectionEnum];
        }else{
            info = [self createUnLastFooterForSectionName:section.sectionEnum];
        }
        [self.sectionFooterList addObject:info];
    }
}

- (SLPViewInfo *)createUnLastFooterForSectionName:(NSString *)sectionName {
//    NSString *tip = LocalizedString(@"");
    SLPLabelFooter *footer = [SLPLabelFooter footerViewWithTextStr:@""];
    [footer setHidden:NO];
    SLPViewInfo *info = [SLPViewInfo new];
    [info setView:footer];
    [info setHeight:[SLPLabelFooter footerHeight:@""]];
    return info;
}

- (SLPViewInfo *)createLastFooterForSectionName:(NSString *)sectionName {
    NSString *tip = [NSString stringWithFormat:LocalizedString(@"smart_wake_turn_on"), LocalizedString(@"device_aroma_light")];
    
    if (!self.alarmDataNew.snoozeTime) {
        tip = @"";
    }
    
    UIView *view = nil;
    CGFloat height = 0;
    SLPAlarmFooter *footer = [SLPAlarmFooter footerViewWithTextStr:tip];
    footer.backgroundColor = [UIColor whiteColor];
    self.alarmFooter = footer;
    [footer setDelegate:self];
    view = footer;
    
    if (self.alarmPageType == AlarmPageType_Add){
        [footer.deleteBtn setHidden:YES];
    }else {
        [footer.deleteBtn setHidden:NO];
    }
    height = [footer height];
    
    if (self.alarmDataNew.snoozeTime) {
        height = height - 40;
        footer.label.hidden = NO;
    } else{
        footer.label.hidden = YES;
    }
    
    SLPViewInfo *info = [SLPViewInfo new];
    [info setView:view];
    [info setHeight:height];
    return info;
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionDataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SLPTableSectionData *sectionData = [self.sectionDataList objectAtIndex:section];
    return sectionData.rowEnumList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SLPTableSectionData *sectionData = [self.sectionDataList objectAtIndex:indexPath.section];
    NSString *rowName = [sectionData .rowEnumList objectAtIndex:indexPath.row];
    
    if ([rowName isEqualToString:kRowSmartWakeTip]) {
        return 100;
    }
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SLPTableSectionData *sectionData = [self.sectionDataList objectAtIndex:indexPath.section];
    NSString *rowName = [sectionData .rowEnumList objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [self getTableCellWithRowName:rowName];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    SLPViewInfo *viewInfo = [self.sectionFooterList objectAtIndex:section];
    return viewInfo.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    SLPViewInfo *viewInfo = [self.sectionFooterList objectAtIndex:section];
    return viewInfo.view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SLPTableSectionData *sectionData = [self.sectionDataList objectAtIndex:indexPath.section];
    NSString *rowName = [sectionData.rowEnumList objectAtIndex:indexPath.row];
    if ([rowName isEqualToString:kRowTime]) {
        [self showTimeSelector];
    }else if ([rowName isEqualToString:kRowRepeat]){
        [self goSelectWeekdayPage];
    }else if ([rowName isEqualToString:kRowMusic]){
        [self goSelectMusicPage];
    }else if ([rowName isEqualToString:kRowSnoozeTime]){
        [self showSnoozeTimeSelector];
    }else if ([rowName isEqualToString:kRowMusicVolumn]){
        [self showVolumeSelector];
    }else if ([rowName isEqualToString:kRowWakeTime]){
        [self showWakeTimeSelector];
    }
}

- (void)showVolumeSelector
{
    NSMutableArray *values = [NSMutableArray array];
    for (int i = 1; i <= 16; i++) {
        [values addObject:@(i)];
    }
    SLPMinuteSelectView *minuteSelectView = [SLPMinuteSelectView minuteSelectViewWithValues:values];
    __weak typeof(self) weakSelf = self;
    [minuteSelectView showInView:self.view mode:SLPMinutePickerMode_Second time:self.alarmDataNew.volume finishHandle:^(NSInteger timeValue) {
        weakSelf.alarmDataNew.volume = timeValue;
        [weakSelf.tableView reloadData];
    } cancelHandle:nil];
}

- (void)showTimeSelector
{
    SLPTime24 *time24 = [[SLPTime24 alloc] init];
    time24.hour = self.alarmDataNew.hour;
    time24.minute = self.alarmDataNew.minute;
    
    __weak typeof(self) weakSelf = self;
    TimePickerSelectView *timePick = [TimePickerSelectView timePickerSelectView];
    [timePick showInView:[UIApplication sharedApplication].keyWindow mode:![SLPUtils isTimeMode24] time:time24 finishHandle:^(SLPTime24 * _Nonnull time24) {
        weakSelf.alarmDataNew.hour = time24.hour;
        weakSelf.alarmDataNew.minute = time24.minute;
        [weakSelf.tableView reloadData];
    } cancelHandle:^{
        
    }];
}

- (void)goSelectWeekdayPage
{
    WeekdaySelectViewController *vc = [WeekdaySelectViewController new];
    vc.selectWeekDay = self.alarmDataNew.flag;
    
    __weak typeof(self) weakSelf = self;
    vc.weekdayBlock = ^(NSInteger weekday) {
        weakSelf.alarmDataNew.flag = weekday;
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goSelectMusicPage
{
    if (self.alarmFooter.isPreviewEnabled) {
        [self stopPreView];
    }
    
    MusicListViewController *vc = [MusicListViewController new];
    vc.musicID = self.alarmDataNew.musicID;
    vc.musicList = self.musicList;
    vc.mode = FromMode_Alarm;
    __weak typeof(self) weakSelf = self;
    vc.musicBlock = ^(NSInteger musicID) {
        weakSelf.alarmDataNew.musicID = musicID;
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showWakeTimeSelector
{
    NSMutableArray *values = [NSMutableArray array];
    for (int i = 1; i <= 30; i++) {
        [values addObject:@(i)];
    }
    SLPMinuteSelectView *minuteSelectView = [SLPMinuteSelectView minuteSelectViewWithValues:values];
    __weak typeof(self) weakSelf = self;
    [minuteSelectView showInView:self.view mode:SLPMinutePickerMode_Minute time:self.alarmDataNew.smartOffset finishHandle:^(NSInteger timeValue) {
        weakSelf.alarmDataNew.smartOffset = timeValue;
        [weakSelf.tableView reloadData];
    } cancelHandle:nil];
}

- (void)showSnoozeTimeSelector
{
    NSArray *values = @[@5,@10,@15];
    SLPMinuteSelectView *minuteSelectView = [SLPMinuteSelectView minuteSelectViewWithValues:values];
    __weak typeof(self) weakSelf = self;
    [minuteSelectView showInView:self.view mode:SLPMinutePickerMode_Minute time:self.alarmDataNew.snoozeLength finishHandle:^(NSInteger timeValue) {
        weakSelf.alarmDataNew.snoozeLength = timeValue;
        [weakSelf.tableView reloadData];
    } cancelHandle:nil];
}

- (UITableViewCell *)getTableCellWithRowName:(NSString *)rowName
{
    BaseTableViewCell *cell = nil;
    
    __weak typeof(self) weakSelf = self;
    
    if ([rowName isEqualToString:kRowTime]) {
        TitleSubTitleArrowCell *baseCell = (TitleSubTitleArrowCell *)[SLPUtils tableView:self.tableView cellNibName:@"TitleSubTitleArrowCell"];
        baseCell.titleLabel.text = LocalizedString(@"time");
        baseCell.subTitleLabel.text = [self getAlarmTimeStringWithDataModle:self.alarmDataNew];
        [Utils configCellTitleLabel:baseCell.titleLabel];
        [Utils configCellTitleLabel:baseCell.subTitleLabel];
        cell = baseCell;
    }else if ([rowName isEqualToString:kRowRepeat]){
        TitleSubTitleArrowCell *baseCell = (TitleSubTitleArrowCell *)[SLPUtils tableView:self.tableView cellNibName:@"TitleSubTitleArrowCell"];
        baseCell.titleLabel.text = LocalizedString(@"reply");
        baseCell.subTitleLabel.text = [SLPWeekDay getAlarmRepeatDayStringWithWeekDay:self.alarmDataNew.flag];
        [Utils configCellTitleLabel:baseCell.titleLabel];
        [Utils configCellTitleLabel:baseCell.subTitleLabel];
        cell = baseCell;
    }else if ([rowName isEqualToString:kRowMusic]){
        TitleSubTitleArrowCell *baseCell = (TitleSubTitleArrowCell *)[SLPUtils tableView:self.tableView cellNibName:@"TitleSubTitleArrowCell"];
        baseCell.titleLabel.text = LocalizedString(@"music");
        baseCell.subTitleLabel.text = [self getMusicNameWithMusicID:self.alarmDataNew.musicID];
        [Utils configCellTitleLabel:baseCell.titleLabel];
        [Utils configCellTitleLabel:baseCell.subTitleLabel];
        cell = baseCell;
    }else if([rowName isEqualToString:kRowMusicVolumn]){
        TitleSubTitleArrowCell *baseCell = (TitleSubTitleArrowCell *)[SLPUtils tableView:self.tableView cellNibName:@"TitleSubTitleArrowCell"];
        baseCell.titleLabel.text = LocalizedString(@"volume");
        baseCell.subTitleLabel.text = [NSString stringWithFormat:@"%d", self.alarmDataNew.volume];
        [Utils configCellTitleLabel:baseCell.titleLabel];
        [Utils configCellTitleLabel:baseCell.subTitleLabel];
        cell = baseCell;
    }else if ([rowName isEqualToString:kRowLightWake]){
        TitleSwitchCell *sCell = (TitleSwitchCell *)[SLPUtils tableView:self.tableView cellNibName:@"TitleSwitchCell"];
        sCell.titleLabel.text = LocalizedString(@"light_wake");
        sCell.switcher.on = self.alarmDataNew.brightness;
        [Utils configCellTitleLabel:sCell.titleLabel];
        sCell.switchBlock = ^(UISwitch *sender) {
            if (sender.on) {
                weakSelf.alarmDataNew.brightness = 100;
            }else{
                weakSelf.alarmDataNew.brightness = 0;
            }
        };
        cell = sCell;
    }else if ([rowName isEqualToString:kRowAromaWake]){
        TitleSwitchCell *sCell = (TitleSwitchCell *)[SLPUtils tableView:self.tableView cellNibName:@"TitleSwitchCell"];
        sCell.titleLabel.text = LocalizedString(@"alarm_sa");
        sCell.switcher.on = self.alarmDataNew.aromaRate;
        sCell.switchBlock = ^(UISwitch *sender) {
            if (sender.on) {
                weakSelf.alarmDataNew.aromaRate = 2;
            }else{
                weakSelf.alarmDataNew.aromaRate = 0;
            }
        };
        [Utils configCellTitleLabel:sCell.titleLabel];
        cell = sCell;
    }else if ([rowName isEqualToString:kRowSmartWake]){
        TitleSwitchCell *sCell = (TitleSwitchCell *)[SLPUtils tableView:self.tableView cellNibName:@"TitleSwitchCell"];
        sCell.titleLabel.text = LocalizedString(@"smart_wake");
        sCell.switcher.on = self.alarmDataNew.smartFlag;
        sCell.switchBlock = ^(UISwitch *sender) {
            weakSelf.alarmDataNew.smartFlag = sender.on ? 1 : 0;
            [weakSelf createFooterList];
            [weakSelf loadSectionData];
            [weakSelf.tableView reloadData];
        };
        [Utils configCellTitleLabel:sCell.titleLabel];
        cell = sCell;
    }else if ([rowName isEqualToString:kRowWakeTime]){
        TitleSubTitleArrowCell *baseCell = (TitleSubTitleArrowCell *)[SLPUtils tableView:self.tableView cellNibName:@"TitleSubTitleArrowCell"];
        baseCell.titleLabel.text = LocalizedString(@"wake_time");
        NSString *timeStr = [NSString stringWithFormat:@"%d%@", self.alarmDataNew.smartOffset, LocalizedString(@"min")];
        baseCell.subTitleLabel.text = timeStr;
        [Utils configCellTitleLabel:baseCell.titleLabel];
        [Utils configCellTitleLabel:baseCell.subTitleLabel];
        cell = baseCell;
    } else if ([rowName isEqualToString:kRowSmartWakeTip]){
        SLPLabelCell *labelCell = (SLPLabelCell *)[SLPUtils tableView:self.tableView cellNibName:@"SLPLabelCell"];
        [SLPUtils setLableNormalAttributes:labelCell.titleLabel text:LocalizedString(@"wake_time_turn_on") font:[Theme T4]];
        cell = labelCell;
    }

    else if ([rowName isEqualToString:kRowSnooze]){
        TitleSwitchCell *sCell = (TitleSwitchCell *)[SLPUtils tableView:self.tableView cellNibName:@"TitleSwitchCell"];
        sCell.titleLabel.text = LocalizedString(@"snooze_");
        sCell.switcher.on = self.alarmDataNew.snoozeTime;
        [Utils configCellTitleLabel:sCell.titleLabel];
        
        
        sCell.switchBlock = ^(UISwitch *sender) {
            weakSelf.alarmDataNew.snoozeTime = sender.on;
            [weakSelf createFooterList];
            [weakSelf loadSectionData];
            [weakSelf.tableView reloadData];
        };
        cell = sCell;
    }else if ([rowName isEqualToString:kRowSnoozeTime]){
        TitleSubTitleArrowCell *baseCell = (TitleSubTitleArrowCell *)[SLPUtils tableView:self.tableView cellNibName:@"TitleSubTitleArrowCell"];
        baseCell.titleLabel.text = LocalizedString(@"snooze_duration");
        NSString *timeStr = [NSString stringWithFormat:@"%d%@", self.alarmDataNew.snoozeLength, LocalizedString(@"min")];
        baseCell.subTitleLabel.text = timeStr;
        [Utils configCellTitleLabel:baseCell.titleLabel];
        [Utils configCellTitleLabel:baseCell.subTitleLabel];
        cell = baseCell;
    }
    
    return cell;
}

- (NSString *)getMusicNameWithMusicID:(NSInteger)musicID
{
    NSString *musicName = @"";
    for (MusicInfo *musicInfo in self.musicList) {
        if (musicInfo.musicID == musicID) {
            musicName = musicInfo.musicName;
            break;
        }
    }
    
    return musicName;
}

- (NSString *)getAlarmTimeStringWithDataModle:(SA1001AlarmInfo *)dataModel {
    return [SLPUtils timeStringFrom:dataModel.hour minute:dataModel.minute isTimeMode24:[SLPUtils isTimeMode24]];
}

- (IBAction)saveAction:(UIButton *)sender {
    if (![SLPLTcpCommon isReachableViaWiFi]) {
        [Utils showMessage:LocalizedString(@"wifi_not_connected") controller:self];
        return;
    }
    __weak typeof(self) weakSelf = self;
    
    [self showLoadingView];
    NSDictionary *par = @{
        @"alarmId":@(self.alarmDataNew.alarmID),
        @"alarmFlag" : @(self.alarmDataNew.isOpen),
        @"smartFlag":@(self.alarmDataNew.smartFlag),
        @"smartOffset":@(self.alarmDataNew.smartOffset),
        @"hour":@(self.alarmDataNew.hour),
        @"min":@(self.alarmDataNew.minute),
        @"week":@(self.alarmDataNew.flag),
        @"lazyTime":@(self.alarmDataNew.snoozeTime),
        @"lazyTimes":@(self.alarmDataNew.snoozeLength),
        @"volum":@(self.alarmDataNew.volume),
        @"lightStrength":@(self.alarmDataNew.brightness),
        @"aromatherapyRate":@(self.alarmDataNew.aromaRate),
        @"oscillator":@(self.alarmDataNew.shake),
        @"musicId":@(self.alarmDataNew.musicID),
        @"timeStamp":@(self.alarmDataNew.timestamp),
    };
    [SLPSharedHTTPManager configAlarmInfoWithParameters:par deviceInfo:SharedDataManager.deviceName deviceType:SLPDeviceType_Sal timeout:0 completion:^(BOOL result, id  _Nonnull responseObject, NSString * _Nonnull error) {
        NSLog(@"configAlarm----------------%@", responseObject);
        [weakSelf unshowLoadingView];
        if (!result) {
            [Utils showDeviceOperationFailed:SLPDataTransferStatus_Failed atViewController:weakSelf];
        }else{
            if ([weakSelf.delegate respondsToSelector:@selector(editAlarmInfoAndShouldReload)]) {
                [weakSelf.delegate editAlarmInfoAndShouldReload];
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

-(void)previewBtnTapped:(BOOL)isSelected completion:(void (^)(BOOL))completion
{
    if (isSelected) {
        [self startPreView];
    }else{
        [self stopPreView];
    }
}

- (void)startPreView
{
    if (![SLPLTcpCommon isReachableViaWiFi]) {
        [Utils showMessage:LocalizedString(@"wifi_not_connected") controller:self];
        return;
    }
    __weak typeof(self) weakSelf = self;
    [SLPSharedLTcpManager salStartAlarmRreviewVolume:self.alarmDataNew.volume brightness:self.alarmDataNew.brightness aromaRate:self.alarmDataNew.aromaRate musicID:self.alarmDataNew.musicID deviceInfo:SharedDataManager.deviceName timeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (status != SLPDataTransferStatus_Succeed) {
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
        }else{
            weakSelf.alarmFooter.isPreviewEnabled = YES;
        }
    }];
}

- (void)stopPreView
{
    if (![SLPLTcpCommon isReachableViaWiFi]) {
        [Utils showMessage:LocalizedString(@"wifi_not_connected") controller:self];
        return;
    }
    __weak typeof(self) weakSelf = self;
    [SLPSharedLTcpManager salStopAlarmRreviewWithDeviceInfo:SharedDataManager.deviceName timeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (status != SLPDataTransferStatus_Succeed) {
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
        }else{
            weakSelf.alarmFooter.isPreviewEnabled = NO;
        }
    }];
}

-(void)deleteBtnTapped
{
    if (![SLPLTcpCommon isReachableViaWiFi]) {
        [Utils showMessage:LocalizedString(@"wifi_not_connected") controller:self];
        return;
    }
    __weak typeof(self) weakSelf = self;
    [SLPSharedHTTPManager deleteAlarmWithAlarmID:self.alarmDataNew.alarmID deviceInfo:SharedDataManager.deviceName deviceType:SLPDeviceType_Sal timeout:0 completion:^(BOOL result, id  _Nonnull responseObject, NSString * _Nonnull error) {
        if (!result) {
            [Utils showDeviceOperationFailed:SLPDataTransferStatus_Failed atViewController:weakSelf];
        }else{
            if ([self.delegate respondsToSelector:@selector(editAlarmInfoAndShouldReload)]) {
                [self.delegate editAlarmInfoAndShouldReload];
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

-(void)back
{
    [self stopPreView];
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
