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
    NSInteger rate;
}
@property (nonatomic, weak) IBOutlet UIView *contentView;
//deviceInfo
@property (nonatomic, weak) IBOutlet UITextField *ipTextField;
@property (nonatomic, weak) IBOutlet UITextField *tokenTextField;
@property (nonatomic, weak) IBOutlet UITextField *channelTextField;
@property (nonatomic, weak) IBOutlet UITextField *platTextField;

@property (nonatomic, weak) IBOutlet UIButton *connectBtn;
@property (nonatomic, weak) IBOutlet UIView *deviceInfoShell;
//firmwareInfo
@property (nonatomic, weak) IBOutlet UITextField *deviceIDTextField;
@property (nonatomic, weak) IBOutlet UITextField *firmwareVersionTextField;
@property (nonatomic, weak) IBOutlet UIButton *upgradeBtn;
@property (nonatomic, weak) IBOutlet UIView *firmwareInfoShell;
@property (nonatomic, weak) IBOutlet UIButton *bindBtn;
@property (nonatomic, weak) IBOutlet UIButton *unBindBtn;


@property (nonatomic, assign) BOOL connected;
@end

@implementation DeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = LocalizedString(@"login_in");
    
    [self setUI];
    [self addNotificationObservre];
}

- (void)setUI {
    [Utils configNormalButton:self.connectBtn];
    [Utils configNormalButton:self.upgradeBtn];
    [Utils configNormalButton:self.bindBtn];
    [Utils configNormalButton:self.unBindBtn];
        
    self.ipTextField.placeholder = LocalizedString(@"server_ip");
    self.tokenTextField.placeholder = LocalizedString(@"enter_token");
    self.channelTextField.placeholder = LocalizedString(@"enter_id");

    self.deviceIDTextField.placeholder = LocalizedString(@"device_id_cipher");
    self.firmwareVersionTextField.placeholder = LocalizedString(@"firmware_info");
    self.firmwareVersionTextField.userInteractionEnabled = NO;
    self.ipTextField.text = @"http://120.24.68.136:8091";
//    self.ipTextField.text= @"https://api.sleepbytes.com";
//    if (SharedDataManager.ip.length > 0) {
//        self.ipTextField.text = SharedDataManager.ip;
//    }
//    SA11166000005  @"SA11166000005"
//    SA11179000257  @"ncew4y78xcg21"
    self.deviceIDTextField.text = @"ncew4y78xcg21";
//    if (SharedDataManager.deviceID.length > 0) {
//        self.deviceIDTextField.text = SharedDataManager.deviceID;
//    }
    
//    if (SharedDataManager.token.length > 0) {
//        self.tokenTextField.text = SharedDataManager.token;
//    } else {
//        self.tokenTextField.text = @"JEyze7I6jpr4";
        self.tokenTextField.text = @"kxu5jh5xmfap";
//    }
    
    self.channelTextField.text = @"54500";
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
    
    [Utils setButton:self.upgradeBtn title:LocalizedString(@"fireware_update")];
    [Utils setButton:self.connectBtn title:LocalizedString(@"connect_server")];
    [Utils setButton:self.bindBtn title:LocalizedString(@"bind")];
    [Utils setButton:self.unBindBtn title:LocalizedString(@"unbind")];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)addNotificationObservre {
    NSNotificationCenter *notificationCeter = [NSNotificationCenter defaultCenter];
    [notificationCeter addObserver:self selector:@selector(tcpDeviceConnected:) name:kNotificationNameLTCPConnected object:nil];
    [notificationCeter addObserver:self selector:@selector(tcpDeviceDisconnected:) name:kNotificationNameLTCPDisconnected object:nil];
    [notificationCeter addObserver:self selector:@selector(onlineChanged:) name:kNotificationNameRequestDeviceOnlineStatusChanged object:nil];
}

- (void)tcpDeviceConnected:(NSNotification *)notification {
    self.connected = YES;
    SharedDataManager.connected = YES;
}

- (void)tcpDeviceDisconnected:(NSNotification *)notification {
    self.connected = NO;
    SharedDataManager.connected = NO;
}

- (void)onlineChanged:(NSNotification *)notification {
 
    NSDictionary *userInfo = notification.userInfo;
    SLPTCPOnlineStatus *online = [userInfo objectForKey:kNotificationPostData];
    
}

-(IBAction)connectDevice:(id)sender {
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
            
            NSString *str = SharedDataManager.deviceID;
            NSLog(@"deviceID ---- %@",str);
            [[NSUserDefaults standardUserDefaults] setValue:self.channelTextField.text forKey:@"channelID"];
            SharedDataManager.channelID = self.channelTextField.text;
            
            [weakSelf getBindDeviceInfo];
            [weakSelf getUpgradeInfo];
            
            [SLPSharedLTcpManager loginHost:tcpDic[@"ip"] port:[tcpDic[@"port"] integerValue] token:SLPSharedHTTPManager.sid completion:^(BOOL succeed) {
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

- (void)getBindDeviceInfo {
    __weak typeof(self) weakSelf = self;
    [SLPSharedHTTPManager getBindedDeviceInformationWithTimeout:0 completion:^(NSInteger status, id  _Nonnull responseObject, NSString * _Nonnull error) {
        if (status == 0) {
            NSArray *data = responseObject[@"data"];
            if ([data isKindOfClass:[NSArray class]]) {
                NSDictionary *dic = [data firstObject];
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    if ([dic[@"deviceName"] hasPrefix:@"sa11"]) {
                        self.firmwareVersionTextField.text = [NSString stringWithFormat:@"%.2f",[dic[@"deviceVersion"] floatValue]];
                        NSDecimalNumber *deciNum1 = [NSDecimalNumber decimalNumberWithString:self.firmwareVersionTextField.text];

                        SharedDataManager.currentVersion = [deciNum1 doubleValue];
                        self.deviceIDTextField.text = dic[@"deviceId"];
                        
                        SharedDataManager.deviceID = dic[@"deviceId"];
                        [[NSUserDefaults standardUserDefaults] setValue:dic[@"deviceId"] forKey:@"deviceName"];
                    }
                }
            }
        }
    }];
}

- (void)getUpgradeInfo
{
    __weak typeof(self) weakSelf = self;
    NSDictionary *par = @{
        @"lan":@"zh-cn",
        @"channelID" : self.channelTextField.text,
    };
    [SLPSharedHTTPManager getDeviceVersionWithParameters:par timeout:0 completion:^(BOOL result, id  _Nonnull responseObject, NSString * _Nonnull error) {
        if (result) {
            NSArray *array = responseObject[@"data"];
            if ([array isKindOfClass:[NSArray class]]) {
                NSInteger count = [array count];
                for (int i = 0; i < count; i++) {
                    NSDictionary *dic = [array objectAtIndex:i];
                    if ([dic[@"deviceType"] intValue] == SLPDeviceType_Sal) {
                        NSString * upgradeVersion = [NSString stringWithFormat:@"%.2f",[dic[@"deviceVersion"] floatValue]];

                        SharedDataManager.upgradeVersion = [weakSelf StringChangeToDoubleForJingdu:upgradeVersion];

                        SharedDataManager.upgradeUrl = dic[@"url"];

                        break;
                    }
                }
            }
        }
    }];
}

- (IBAction)upgradeClicked:(id)sender {
    __weak typeof(self) weakSelf = self;
    
    if (!SharedDataManager.upgradeVersion || !SharedDataManager.currentVersion) {
        [Utils showMessage:LocalizedString(@"latest_version") controller:self];
        return;
    }
    
    double currentVersion = round(SharedDataManager.currentVersion * 100);
    double upgradeVersion = round(SharedDataManager.upgradeVersion * 100);
    
    if (currentVersion >= upgradeVersion) {
        [Utils showMessage:LocalizedString(@"latest_version") controller:self];
        return;
    }
    
    if (self.deviceIDTextField.text.length == 0 && SharedDataManager.deviceID.length == 0) {
        [Utils showMessage:LocalizedString(@"id_cipher") controller:self];
        return;
    }
    
    if (self.deviceIDTextField.text.length != 0) {
        SharedDataManager.deviceID = self.deviceIDTextField.text;
    }
    
    SLPLoadingBlockView *loadingView = [self showLoadingView];
    [loadingView setText:LocalizedString(@"upgrading")];
    
    [SLPSharedLTcpManager salCurrentHardwareVersion:currentVersion upgradeHardwareVersion:upgradeVersion upgradeType:3 url:SharedDataManager.upgradeUrl deviceInfo:SharedDataManager.deviceID timeout:0 callback:^(SLPDataTransferStatus status, id data) {
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

- (double)StringChangeToDoubleForJingdu:(NSString *)textString

{

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];

    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];

    return  [[formatter numberFromString:textString]doubleValue];
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
            [loadingView setText:[NSString stringWithFormat:@"%2d%%", (int)(info.rate * 0.8)]];
        }
            break;
        case 1://下载完成，安装升级包
        {
            [loadingView setText:@"80%"];
            [progressTimer invalidate];//销毁进度条定时器
            [[NSNotificationCenter defaultCenter]removeObserver:self name:kNotificationNameTCPDeviceUpdateRateChanged object:nil];///移除进度通知
            
            rate = 80;
            [self performSelector:@selector(installUpgrade) withObject:nil afterDelay:2];
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

- (void)installUpgrade
{
    rate++;
    SLPLoadingBlockView *loadingView = [self showLoadingView];


    if (rate < 100) {
        [loadingView setText:[NSString stringWithFormat:@"%2ld%%", (long)rate]];
        [self performSelector:@selector(installUpgrade) withObject:nil afterDelay:2];
    } else {
        [self unshowLoadingView];
        [Utils showMessage:LocalizedString(@"up_success") controller:self];
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
            SharedDataManager.deviceID = self.deviceIDTextField.text;
            [[NSUserDefaults standardUserDefaults] setValue:self.deviceIDTextField.text forKey:@"deviceName"];
            [weakSelf getBindDeviceInfo];
        } else {
            [Utils showMessage:LocalizedString(@"bind_fail") controller:weakSelf];
        }
    }];
}

- (IBAction)unBind:(id)sender
{
    [SLPSharedLTcpManager publicGetOnlineStatusWithDeviceID:self.deviceIDTextField.text deviceType:SLPDeviceType_Sal timeout:0 callback:^(SLPDataTransferStatus status, id data) {
        SLPTCPOnlineStatus * online= data;
        NSLog(@"online----%d",online.onlineStatus);

    }];
    return;
    
    if (self.deviceIDTextField.text.length == 0) {
        [Utils showMessage:LocalizedString(@"id_cipher") controller:self];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [SLPSharedHTTPManager unBindDeviceWithDeviceId:self.deviceIDTextField.text timeOut:0 completion:^(BOOL result, NSString * _Nonnull error) {
        if (result) {
            SharedDataManager.deviceID = @"";
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"deviceName"];
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
