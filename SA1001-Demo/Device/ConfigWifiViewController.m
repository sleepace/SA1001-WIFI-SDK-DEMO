//
//  ConfigWifiViewController.m
//  SA1001-Demo
//
//  Created by jie yang on 2019/8/8.
//  Copyright © 2019 jie yang. All rights reserved.
//

#import "ConfigWifiViewController.h"
#import <BLEWifiConfig/BLEWifiConfig.h>
#import <SLPMLan/SLPMLan.h>
#import <SA1001/SA1001.h>
#import <SLPMLan/SLPLanTCPCommon.h>

@interface ConfigWifiViewController ()
{
    SLPBleWifiConfig *_wifiConfig;
}

@property (weak, nonatomic) IBOutlet UILabel *topTitle;
@property (weak, nonatomic) IBOutlet UITextField *wifiNameTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *wifiPwdTextFiled;
@property (weak, nonatomic) IBOutlet UILabel *bottomExp;
@property (weak, nonatomic) IBOutlet UIButton *configBtn;
@end

@implementation ConfigWifiViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUI];
    
    _wifiConfig = [[SLPBleWifiConfig alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:)name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)textFiledEditChanged:(NSNotification*)obj {
    UITextField *textField = (UITextField *)obj.object;
    NSString *nameTxt = self.wifiNameTextFiled.text;
    NSString *pwdTxt = self.wifiPwdTextFiled.text;
    if (textField == self.wifiPwdTextFiled) {
        if (pwdTxt.length >= 8 && nameTxt.length > 0) {
            [self setCanConfig:YES];
        } else {
            [self setCanConfig:NO];
        }
    } else if (textField == self.wifiNameTextFiled) {
        if (pwdTxt.length >= 8 && nameTxt.length > 0) {
            [self setCanConfig:YES];
        } else {
            [self setCanConfig:NO];
        }
    }
}

- (void)setUI
{
    self.topTitle.text = LocalizedString(@"input_wifi");
    self.titleLabel.text = LocalizedString(@"Configuring_wifi");
    [self.configBtn setTitle:LocalizedString(@"Configuring_wifi") forState:UIControlStateNormal];
    self.configBtn.backgroundColor = [Theme C2];
    self.configBtn.layer.masksToBounds = YES;
    self.configBtn.layer.cornerRadius = 5;
    
    self.wifiNameTextFiled.text = [Utils getConnectWiFiName];
    self.wifiPwdTextFiled.placeholder = LocalizedString(@"input_wifi_password");
    self.wifiNameTextFiled.placeholder = LocalizedString(@"input_ssid");
    
    self.bottomExp.text = LocalizedString(@"nox_phone_same_lan");
    
    [self setCanConfig:NO];
}

- (void)setCanConfig:(BOOL)canConfig
{
    if (canConfig) {
        self.configBtn.enabled = YES;
        self.configBtn.alpha = 1;
    } else{
        self.configBtn.enabled = NO;
        self.configBtn.alpha = 0.6;
    }
}

- (IBAction)configAction:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    if (![SLPBLESharedManager blueToothIsOpen]) {
        [Utils showMessage:LocalizedString(@"phone_bluetooth_not_open") controller:self];
        return;
    }
    
    if (![SLPLanTCPCommon isReachableViaWiFi]) {
        [Utils showMessage:LocalizedString(@"wifi_not_connected") controller:self];
        return;
    }
    SLPLoadingBlockView *loadingView = [self showLoadingView];
    [loadingView setText:LocalizedString(@"Connecting")];
    NSString *wifiName = self.wifiNameTextFiled.text;
    NSString *wifiPwd = self.wifiPwdTextFiled.text;
    [_wifiConfig configPeripheral:self.peripheralInfo.peripheral deviceType:SLPDeviceType_Sal wifiName:wifiName password:wifiPwd completion:^(BOOL succeed, id data) {
        if (succeed) {
            SLPDeviceInfo *deviceInfo = data;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SLPSharedMLanManager sal:weakSelf.peripheralInfo.name loginCallback:^(SLPDataTransferStatus status, id data) {
                    [weakSelf unshowLoadingView];
                    if (status == SLPDataTransferStatus_Succeed) {
                        SharedDataManager.deviceID = deviceInfo.deviceID;
                        SharedDataManager.version = [deviceInfo.version doubleValue];
                        SharedDataManager.deviceName = weakSelf.peripheralInfo.name;
                        SharedDataManager.peripheral = weakSelf.peripheralInfo.peripheral;
                        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                    } else {
                        [Utils showDeviceOperationFailed:status atViewController:weakSelf];
                    }
                }];
            });
        } else{
            [weakSelf unshowLoadingView];
            [Utils showDeviceOperationFailed:-3 atViewController:weakSelf];
        }
    }];
    
    
}


@end
