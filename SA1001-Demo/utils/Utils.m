//
//  Utils.m
//  Binatone-demo
//
//  Created by Martin on 23/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import "Utils.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation Utils

+ (NSString *)localizedString:(NSString *)key {
    NSString *string = NSLocalizedString(key, nil);
    return string;
}

+ (UIEdgeInsets)areaInsets {
    UIEdgeInsets areaInsets = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        areaInsets = mainWindow.safeAreaInsets;
    }
    return areaInsets;
}

+ (void)addSubView:(UIView *)subView suitableTo:(UIView *)superView{
    if (!subView || !superView){
        return;
    }
    
    [subView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [superView addSubview:subView];
    NSDictionary *subViews = NSDictionaryOfVariableBindings(subView,superView);
    [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subView]|" options:0 metrics:nil views:subViews]];
    [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[subView]|" options:0 metrics:nil views:subViews]];
}

+ (NSString*)getConnectWiFiName
{
    NSDictionary *ifs = [self getSSIDInfo];
    NSString *ssid=nil;
    if (ifs != nil)
    {
        ssid = ifs[@"SSID"];
    }
    else
    {
        ssid=@"";
    }
    
    return ssid;
}

+(id)getSSIDInfo
{
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    id info = nil;
    for (NSString *ifnam in ifs)
    {
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [((NSDictionary *)info) count])
        {
            break;
        }
    }
    return info;
}
@end
