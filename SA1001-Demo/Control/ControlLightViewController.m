//
//  ControlLightViewController.m
//  SA1001-2-demo
//
//  Created by jie yang on 2018/11/15.
//  Copyright © 2018年 jie yang. All rights reserved.
//

#import "ControlLightViewController.h"


#import <SLPTCP/SLPLTcpCommon.h>
#import <SLPTCP/SA1001WorkMode.h>

@interface ControlLightViewController ()
@property (weak, nonatomic) IBOutlet UITextField *colorRTextField;
@property (weak, nonatomic) IBOutlet UITextField *colorGTextfFiled;
@property (weak, nonatomic) IBOutlet UITextField *colorBTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *colorWTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *brightnessTextFiled;

@property (weak, nonatomic) IBOutlet UIButton *sendColorBtn;

@property (weak, nonatomic) IBOutlet UIButton *sendBrightnessBtn;

@property (weak, nonatomic) IBOutlet UIButton *openLightBtn;

@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet UILabel *brightnessLabel;

@end

@implementation ControlLightViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:)name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)textFiledEditChanged:(NSNotification*)obj {
    UITextField *textField = (UITextField *)obj.object;
    
    if (textField == self.colorRTextField || textField == self.colorGTextfFiled || textField == self.colorBTextFiled || textField == self.colorWTextFiled || textField == self.brightnessTextFiled) {
        NSString *toBeString = textField.text;
        NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
        if ([lang isEqualToString:@"zh-Hans"]) { //简体中文输入，包括简体拼音，健体五笔，简体手写
            UITextRange *selectedRange = [textField markedTextRange];
            //获取高亮部分
            UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
            //没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position) {
                if(toBeString.length > 3) {
                    textField.text = [toBeString substringToIndex:3];
                }
                
            }
            //有高亮选择的字符串，则暂不对文字进行统计和限制
            else{
                
            }
        }
        //中文输入法以外的直接对其统计限制即可，不考虑其他语种情况：emoji表情、en-US
        else{
            if (toBeString.length > 3) {
                textField.text= [toBeString substringToIndex:3];
            }
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.colorRTextField.text = @"";
    self.colorGTextfFiled.text = @"";
    self.colorBTextFiled.text = @"";
    self.colorWTextFiled.text = @"";
    self.brightnessTextFiled.text = @"";
    
    [self getWorkMode];
}

- (void)setUI
{
    self.colorLabel.text = LocalizedString(@"color");
    self.brightnessLabel.text = LocalizedString(@"luminance");
    self.colorLabel.textColor = Theme.C4;
    self.brightnessLabel.textColor = Theme.C4;
    
    [self.sendColorBtn setTitle:LocalizedString(@"send") forState:UIControlStateNormal];
    [self.sendBrightnessBtn setTitle:LocalizedString(@"send") forState:UIControlStateNormal];
    [self.openLightBtn setTitle:LocalizedString(@"turn_off") forState:UIControlStateNormal];
    
    self.sendColorBtn.backgroundColor = [Theme C2];
    self.sendBrightnessBtn.backgroundColor = [Theme C2];
    self.openLightBtn.backgroundColor = [Theme C2];
    
    self.sendColorBtn.layer.masksToBounds = YES;
    self.sendColorBtn.layer.cornerRadius = 5;
    self.sendBrightnessBtn.layer.masksToBounds = YES;
    self.sendBrightnessBtn.layer.cornerRadius = 5;
    self.openLightBtn.layer.masksToBounds = YES;
    self.openLightBtn.layer.cornerRadius = 5;
}

- (void)getWorkMode
{
    __weak typeof(self) weakSelf = self;
    [SLPSharedLTcpManager salGetWorkStatusDeviceInfo:SharedDataManager.deviceName timeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (status == SLPDataTransferStatus_Succeed) {
            SA1001WorkMode *mode = (SA1001WorkMode *)data;
            [weakSelf updateLigntBtn:mode.isLightOn];
        }
    }];
}

- (void)updateLigntBtn:(BOOL)lightOn
{
    if (!lightOn) {
        self.openLightBtn.alpha = 0.3;
        self.openLightBtn.userInteractionEnabled = NO;
    } else {
        self.openLightBtn.alpha = 1;
        self.openLightBtn.userInteractionEnabled = YES;
    }
}

- (IBAction)sendColorAction:(UIButton *)sender {
    
    BOOL valueR = self.colorRTextField.text.length;
    BOOL valueG = self.colorGTextfFiled.text.length;
    BOOL valueB = self.colorBTextFiled.text.length;
    BOOL valueW = self.colorWTextFiled.text.length;
    if (valueR && valueB && valueG && valueW) {
        
        int r = [self.colorRTextField.text intValue];
        int g = [self.colorGTextfFiled.text intValue];
        int b = [self.colorBTextFiled.text intValue];
        int w = [self.colorWTextFiled.text intValue];
        
        BOOL rValid = (r >= 0) && (r <= 255);
        BOOL gValid = (g >= 0) && (g <= 255);
        BOOL bValid = (b >= 0) && (b <= 255);
        BOOL wValid = (w >= 0) && (w <= 255);
        
        if (!(rValid && gValid && bValid && wValid)) {
            [Utils showMessage:LocalizedString(@"input_0_255") controller:self];
            return;
        }
        
        
        int brightness = [self.brightnessTextFiled.text intValue];
        
        if (!self.brightnessTextFiled.text.length) {
            brightness = 50;
        }
        
        BOOL brightValid = (brightness >= 0) && (brightness <= 100);
        if (!brightValid) {
            brightness = 50;
        }
        
        SLPLight *ligtht = [[SLPLight alloc] init];
        ligtht.r = r;
        ligtht.g = g;
        ligtht.b = b;
        ligtht.w = w;
        
        if (![SLPLTcpCommon isReachableViaWiFi]) {
            [Utils showMessage:LocalizedString(@"wifi_not_connected") controller:self];
            return;
        }
        __weak typeof(self) weakSelf = self;
        [SLPSharedLTcpManager salTurnOnColorLight:ligtht brightness:brightness deviceInfo:SharedDataManager.deviceName timeout:0 callback:^(SLPDataTransferStatus status, id data) {
            if (status != SLPDataTransferStatus_Succeed) {
                [Utils showDeviceOperationFailed:status atViewController:weakSelf];
            } else {
                [weakSelf updateLigntBtn:YES];
            }
        }];
    }else{
        [Utils showMessage:LocalizedString(@"input_0_255") controller:self];
    }
}

- (IBAction)sendBrightnessAction:(UIButton *)sender {
    if (!self.brightnessTextFiled.text.length) {
        [Utils showMessage:LocalizedString(@"input_0_100") controller:self];
        return;
    }
    
    int brightness = [self.brightnessTextFiled.text intValue];
    BOOL brightValid = (brightness >= 0) && (brightness <= 100);
    if (!brightValid) {
        [Utils showMessage:LocalizedString(@"input_0_100") controller:self];
        return;
    }
    
    if (![SLPLTcpCommon isReachableViaWiFi]) {
        [Utils showMessage:LocalizedString(@"wifi_not_connected") controller:self];
        return;
    }
    __weak typeof(self) weakSelf = self;
    [SLPSharedLTcpManager salLightBrightness:brightness deviceInfo:SharedDataManager.deviceName timeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (status != SLPDataTransferStatus_Succeed) {
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
        }
    }];
}

- (IBAction)openLightAction:(UIButton *)sender {
    if (![SLPLTcpCommon isReachableViaWiFi]) {
        [Utils showMessage:LocalizedString(@"wifi_not_connected") controller:self];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [SLPSharedLTcpManager salTurnOffLightDeviceInfo:SharedDataManager.deviceName timeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (status != SLPDataTransferStatus_Succeed) {
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
        } else {
            [weakSelf updateLigntBtn:NO];
        }
    }];
}
@end
