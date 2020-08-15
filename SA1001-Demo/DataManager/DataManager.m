//
//  DataManager.m
//  Binatone-demo
//
//  Created by Martin on 28/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import "DataManager.h"
#define kUserID @"kUserID"
@implementation DataManager

+ (DataManager *)sharedDataManager {
    static dispatch_once_t onceToken;
    static DataManager *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DataManager alloc] init];
    });
    return sharedInstance;
}

-(instancetype)init
{
    if (self = [super init]) {
        _selectItemsNum = 7;
        _assistMusicID = 31038;
        
        _aidInfo = [[SA1001AidInfo alloc] init];
        _aidInfo.aidStopDuration = 45;
        _aidInfo.r = 255;
        _aidInfo.b = 120;
        _aidInfo.w = 0;
        _aidInfo.brightness = 0;
        _aidInfo.aromaRate = 2;
        _volumn = 10;
        
        _deviceName = @"";
        _token = @"";
        _channelID = @"";
        _plat = @"";
        _ip = @"";
        
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"deviceName"]) {
            _deviceName = [[NSUserDefaults standardUserDefaults] valueForKey:@"deviceName"];
        }
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"token"]) {
            _token = [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
        }
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"plat"]) {
            _plat = [[NSUserDefaults standardUserDefaults] valueForKey:@"plat"];
        }
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"channelID"]) {
            _channelID = [[NSUserDefaults standardUserDefaults] valueForKey:@"channelID"];
        }
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"ip"]) {
            _ip = [[NSUserDefaults standardUserDefaults] valueForKey:@"ip"];
        }
    }
    
    return self;
}

- (void)reset
{
    _selectItemsNum = 7;
    _assistMusicID = 31038;
    
    _aidInfo.aidStopDuration = 45;
    _aidInfo.r = 255;
    _aidInfo.b = 120;
    _aidInfo.w = 0;
    _aidInfo.brightness = 0;
    _aidInfo.aromaRate = 2;
    _volumn = 10;
}

- (void)toInit {
    self.peripheral = nil;
    self.deviceName = nil;
    self.deviceID = nil;
    self.inRealtime = NO;
    
}

- (NSString *)userID {
    NSString *userIDString = [[NSUserDefaults standardUserDefaults] stringForKey:kUserID];
    return userIDString;
}

- (void)setUserID:(NSString *)userID {
    [[NSUserDefaults standardUserDefaults] setValue:userID forKey:kUserID];
}
@end
