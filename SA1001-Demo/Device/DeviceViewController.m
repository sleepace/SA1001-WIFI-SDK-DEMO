//
//  DeviceViewController.m
//  Binatone-demo
//
//  Created by Martin on 23/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import "DeviceViewController.h"

#import <SLPTCP/SLPLTcpDef.h>
#import <SLPTCP/SLPLTcpUpgradeInfo.h>
#import "DatePickerPopUpView.h"

@interface DeviceViewController ()<UITextFieldDelegate>
{
    SLPTimer *progressTimer;///是否收到升级进度超时定时器
}
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UIView *userIDShell;
@property (nonatomic, weak) IBOutlet UILabel *userIDTitleLabel;
@property (nonatomic, weak) IBOutlet UITextField *userIDLabel;
//deviceInfo
@property (nonatomic, weak) IBOutlet UITextField *ipTextField;
@property (nonatomic, weak) IBOutlet UITextField *tokenTextField;
@property (nonatomic, weak) IBOutlet UITextField *channelTextField;
@property (nonatomic, weak) IBOutlet UITextField *platTextField;

@property (nonatomic, weak) IBOutlet UIButton *connectBtn;
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
@property (nonatomic, weak) IBOutlet UITextField *deviceIDTextField;
@property (nonatomic, weak) IBOutlet UITextField *firmwareVersionTextField;
@property (nonatomic, weak) IBOutlet UIButton *upgradeBtn;
@property (nonatomic, weak) IBOutlet UIView *firmwareInfoShell;
@property (nonatomic, weak) IBOutlet UILabel *firmwareInfoSectionLabel;
@property (nonatomic, weak) IBOutlet UIButton *getFirmwareVersionBtn;
@property (nonatomic, weak) IBOutlet UILabel *firmwareVersionLabel;
@property (nonatomic, weak) IBOutlet UIButton *bindBtn;
@property (nonatomic, weak) IBOutlet UIButton *unBindBtn;


@property (nonatomic, assign) BOOL connected;
@end

@implementation DeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = LocalizedString(@"device");
    
    [self setUI];
    [self addNotificationObservre];
}

- (void)setUI {
    [Utils configNormalButton:self.connectBtn];
    [Utils configNormalButton:self.getDeviceNameBtn];
    [Utils configNormalButton:self.getDeviceIDBtn];
    [Utils configNormalButton:self.getBatteryBtn];
    [Utils configNormalButton:self.getFirmwareVersionBtn];
    [Utils configNormalButton:self.getMacBtn];
    [Utils configNormalButton:self.upgradeBtn];
    [Utils configNormalButton:self.bindBtn];
    [Utils configNormalButton:self.unBindBtn];

    [Utils configNormalDetailLabel:self.deviceNameLabel];
    [Utils configNormalDetailLabel:self.deviceIDLabel];
    [Utils configNormalDetailLabel:self.batteryLabel];
    [Utils configNormalDetailLabel:self.firmwareVersionLabel];
    [Utils configNormalDetailLabel:self.macLabel];
    
    [Utils configSectionTitle:self.userIDTitleLabel];
    [Utils configSectionTitle:self.deviceInfoSectionLabel];
    [Utils configSectionTitle:self.firmwareInfoSectionLabel];
    
    self.ipTextField.placeholder = LocalizedString(@"server_ip");
    self.tokenTextField.placeholder = LocalizedString(@"enter_token");
    self.channelTextField.placeholder = LocalizedString(@"enter_id");

    self.deviceIDTextField.placeholder = LocalizedString(@"device_id_cipher");
    self.firmwareVersionTextField.placeholder = LocalizedString(@"target_version");
    self.ipTextField.text = @"http://120.24.169.204:8091";
    if (SharedDataManager.ip.length > 0) {
        self.ipTextField.text = SharedDataManager.ip;
    }
    self.deviceIDTextField.text = @"o0zguh6yxmi5o";
    if (SharedDataManager.deviceName.length > 0) {
        self.deviceIDTextField.text = SharedDataManager.deviceName;
    }
    
    if (SharedDataManager.token.length > 0) {
        self.tokenTextField.text = SharedDataManager.token;
    } else {
        self.tokenTextField.text = @"wangyong";
//        self.tokenTextField.text = @"r8xfa7hdjcm6";
    }
    
    self.channelTextField.text = @"13700";
    if (SharedDataManager.channelID.length > 0) {
        self.channelTextField.text = SharedDataManager.channelID;
    }
    
    self.ipTextField.delegate = self;
    self.tokenTextField.delegate = self;
    self.deviceIDTextField.delegate = self;
    self.firmwareVersionTextField.delegate = self;
    self.channelTextField.delegate = self;

    self.ipTextField.returnKeyType = UIReturnKeyDone;
    self.tokenTextField.returnKeyType = UIReturnKeyDone;
    self.deviceIDTextField.returnKeyType = UIReturnKeyDone;
    self.firmwareVersionTextField.returnKeyType = UIReturnKeyDone;
    self.channelTextField.returnKeyType = UIReturnKeyDone;
    
    [Utils setButton:self.getDeviceNameBtn title:LocalizedString(@"device_id_clear")];
    [Utils setButton:self.getDeviceIDBtn title:LocalizedString(@"device_id_cipher")];
    [Utils setButton:self.getBatteryBtn title:LocalizedString(@"obtain_electricity")];
    [Utils setButton:self.getFirmwareVersionBtn title:LocalizedString(@"obtain_firmware")];
    [Utils setButton:self.getMacBtn title:LocalizedString(@"obtain_mac_address")];
    [Utils setButton:self.upgradeBtn title:LocalizedString(@"fireware_update")];
    [Utils setButton:self.connectBtn title:LocalizedString(@"connect_server")];
    [Utils setButton:self.bindBtn title:LocalizedString(@"bind")];
    [Utils setButton:self.unBindBtn title:LocalizedString(@"unbind")];


    [self.userIDTitleLabel setText:LocalizedString(@"userid_sync_sleep")];
    [self.deviceInfoSectionLabel setText:LocalizedString(@"device_infos")];
    [self.firmwareInfoSectionLabel setText:LocalizedString(@"firmware_info")];
        
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)addNotificationObservre {
    NSNotificationCenter *notificationCeter = [NSNotificationCenter defaultCenter];
    [notificationCeter addObserver:self selector:@selector(tcpDeviceConnected:) name:kNotificationNameLTCPConnected object:nil];
    [notificationCeter addObserver:self selector:@selector(tcpDeviceDisconnected:) name:kNotificationNameLTCPDisconnected object:nil];
}

- (void)tcpDeviceConnected:(NSNotification *)notification {
    self.connected = YES;
    SharedDataManager.connected = YES;
}

- (void)tcpDeviceDisconnected:(NSNotification *)notification {
    self.connected = NO;
    SharedDataManager.connected = NO;
}

-(IBAction)connectDevice:(id)sender {
    if (self.deviceIDTextField.text.length == 0) {
        [Utils showMessage:LocalizedString(@"complete") controller:self];
        return;
    }
    if (self.ipTextField.text.length == 0) {
        [Utils showMessage:LocalizedString(@"complete") controller:self];
        return;
    }
    if (self.tokenTextField.text.length == 0) {
        [Utils showMessage:LocalizedString(@"complete") controller:self];
        return;
    }
    if (self.channelTextField.text.length == 0) {
        [Utils showMessage:LocalizedString(@"complete") controller:self];
        return;
    }
    
    [SLPSharedLTcpManager.lTcp disconnectCompletion:nil];
    
    SharedDataManager.deviceName = self.deviceIDTextField.text;
    [[NSUserDefaults standardUserDefaults] setValue:self.deviceIDTextField.text forKey:@"deviceName"];

    __weak typeof(self) weakSelf = self;
    NSDictionary *par = @{
        @"url":self.ipTextField.text,
        @"channelID" : self.channelTextField.text,
    };
    [SLPSharedHTTPManager initHttpServiceInfo:par];
    SharedDataManager.ip = self.ipTextField.text;
    [[NSUserDefaults standardUserDefaults] setValue:self.ipTextField.text forKey:@"ip"];
    [SLPSharedHTTPManager authorize:self.tokenTextField.text timeout:0 completion:^(BOOL result, id  _Nonnull responseObject, NSString * _Nonnull error) {
        if (result) {
            SharedDataManager.token = weakSelf.tokenTextField.text;
            [[NSUserDefaults standardUserDefaults] setValue:weakSelf.tokenTextField.text forKey:@"token"];

            NSDictionary *tcpDic = responseObject[@"data"][@"tcpServer"];
            
            NSString *str = SharedDataManager.deviceName;
            NSLog(@"deviceID ---- %@",str);
            [[NSUserDefaults standardUserDefaults] setValue:self.channelTextField.text forKey:@"channelID"];
            SharedDataManager.channelID = self.channelTextField.text;

            [SLPSharedLTcpManager loginHost:tcpDic[@"ip"] port:[tcpDic[@"port"] integerValue] deviceID:SharedDataManager.deviceName token:SLPSharedHTTPManager.sid completion:^(BOOL succeed) {
                if (succeed) {
                    SharedDataManager.connected = YES;
                    [Utils showMessage:LocalizedString(@"connection_succeeded") controller:self];
                } else {
                    [Utils showMessage:LocalizedString(@"confirm_correctly") controller:self];
                }
                [weakSelf unshowLoadingView];
            }];
        } else {
            [Utils showMessage:LocalizedString(@"confirm_correctly") controller:weakSelf];
        }
    }];
}

- (IBAction)upgradeClicked:(id)sender {
    __weak typeof(self) weakSelf = self;
    
    if (self.firmwareVersionTextField.text.length == 0) {
        [Utils showMessage:LocalizedString(@"target_version") controller:self];
        return;
    }
    
    if (self.deviceIDTextField.text.length == 0 && SharedDataManager.deviceID.length == 0) {
        [Utils showMessage:LocalizedString(@"id_cipher") controller:self];
        return;
    }
    
    if (self.deviceIDTextField.text.length != 0) {
        SharedDataManager.deviceName = self.deviceIDTextField.text;
    }
    
    SLPLoadingBlockView *loadingView = [self showLoadingView];
    [loadingView setText:LocalizedString(@"upgrading")];
    
    [SLPSharedLTcpManager publicUpdateOperationWithDeviceID:SharedDataManager.deviceName deviceType:SLPDeviceType_Sal firmwareType:1 firmwareVersion:self.firmwareVersionTextField.text timeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (status == SLPDataTransferStatus_Succeed)///通知升级成功（获取进度)
        {
            ///接收nox升级进度
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateTCPUpgradeProgress:) name:kNotificationNameTCPDeviceUpdateRateChanged object:nil];
            //是否接受nox升级进度超时定时器
            progressTimer=[SLPTimer scheduledTimerWithTimeInterval:20.0 target:self  userInfo:nil repeats:NO handle:^(SLPTimer * _Nonnull timer) {
                [weakSelf unshowLoadingView];
                [Utils showMessage:LocalizedString(@"up_failed") controller:weakSelf];
            }];
        }
        else///通知升级失败
        {
            [weakSelf unshowLoadingView];
            [Utils showMessage:LocalizedString(@"up_failed") controller:weakSelf];
        }
    }];
}

////更新nox升级进度
- (void)updateTCPUpgradeProgress:(NSNotification*)progressNoti
{
    SLPLoadingBlockView *loadingView = [self showLoadingView];

    NSDictionary *userInfo = progressNoti.userInfo;
    SLPLTcpUpgradeInfo *info=[userInfo objectForKey:kNotificationPostData];
    
    [progressTimer invalidate];//销毁进度条定时器
    ///再次创建定时器,如果进度条停顿则超时，升级失败
    __weak typeof(self) weakSelf = self;
    progressTimer=[SLPTimer scheduledTimerWithTimeInterval:20.0 target:self  userInfo:nil repeats:NO handle:^(SLPTimer * _Nonnull timer) {
        [weakSelf unshowLoadingView];
        [Utils showMessage:LocalizedString(@"up_failed") controller:weakSelf];
    }];
    
    switch (info.updateStatus) {
        case 0:///正在升级
        {
            [loadingView setText:[NSString stringWithFormat:@"%2d%%", (int)(info.rate)]];
        }
            break;
        case 1://升级成功
        {
            [weakSelf unshowLoadingView];
            [Utils showMessage:LocalizedString(@"up_success") controller:weakSelf];
            [progressTimer invalidate];//销毁进度条定时器
            [[NSNotificationCenter defaultCenter]removeObserver:self name:kNotificationNameTCPDeviceUpdateRateChanged object:nil];///移除进度通知
        }
            break;
        case 2://升级失败
        {
            [weakSelf unshowLoadingView];
            [Utils showMessage:LocalizedString(@"up_failed") controller:weakSelf];
            [progressTimer invalidate];//销毁进度条定时器
            [[NSNotificationCenter defaultCenter]removeObserver:self name:kNotificationNameTCPDeviceUpdateRateChanged object:nil];///移除进度通知
        }
            break;
        default:
            break;
    }
}

- (IBAction)bind:(id)sender
{
    if (self.deviceIDTextField.text.length == 0) {
        [Utils showMessage:LocalizedString(@"id_cipher") controller:self];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [SLPSharedHTTPManager bindDeviceWithDeviceId:self.deviceIDTextField.text timeOut:0 completion:^(BOOL result, NSDictionary * _Nonnull dict, NSString * _Nonnull error) {
        if (result) {
            [Utils showMessage:LocalizedString(@"bind_account_success") controller:weakSelf];
        } else {
            [Utils showMessage:LocalizedString(@"bind_fail") controller:weakSelf];
        }
    }];
}

- (IBAction)unBind:(id)sender
{
    if (self.deviceIDTextField.text.length == 0) {
        [Utils showMessage:LocalizedString(@"id_cipher") controller:self];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [SLPSharedHTTPManager unBindDeviceWithDeviceId:self.deviceIDTextField.text timeOut:0 completion:^(BOOL result, NSString * _Nonnull error) {
        if (result) {
            [Utils showMessage:LocalizedString(@"unbind_success") controller:weakSelf];
        } else {
            [Utils showMessage:LocalizedString(@"unbind_failed") controller:weakSelf];
        }
    }];
}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    NSString *blank = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
    
    if(![string isEqualToString:blank]) {
        return NO;
    }
    
    if ([string length] > 0) {
        unichar single = [string characterAtIndex:0];//当前输入的字符

        if (textField == self.firmwareVersionTextField) {
            if ((single < '0' || single > '9') && single != '.') {//数据格式正确
                return NO;
            }
        }
        
        if (textField == self.deviceIDTextField) {
            if(single <48)
                return NO;// 48 unichar for 0
            if(single >57&& single <65)
                return NO;//
            if(single >90&& single <97)
                return NO;
            if(single >122)
                return NO;
        }
    }
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;;
}

@end
