//
//  SLPMLanManager.h
//  Sleepace
//
//  Created by Martin on 10/25/16.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NetWorkTool.h"

@class SLPMLanRequest;
@class SLPMLanConnectRequest;
@class SLPLanTCPBaseSendPacket;
@class SLPLanTCP;
#define SLPSharedMLanManager [SLPMLanManager sharedMLanManager]

@interface SLPMLanManager : NSObject

+ (instancetype)sharedMLanManager;
//存储设备IP
@property (nonatomic, strong) NSMutableDictionary *deviceInfoDict;

- (BOOL)sendPacket:(SLPLanTCPBaseSendPacket *)packet deviceName:(NSString *)deviceName;

- (SLPLanTCP *)lanTCPWithDeviceName:(NSString *)deviceName;

//清除LTcp的连接
- (void)disconnectLanTcp:(NSString *)deviceName;

- (void)addScanRequestObj:(SLPMLanRequest *)request;

- (void)addConnectRequestObj:(SLPMLanConnectRequest *)request;

- (SLPMLanRequest *)exitstScanRequestOfGroup:(NSString *)group port:(NSString *)port deviceName:(NSString *)name;

- (SLPMLanConnectRequest *)existConnectRequestOfIp:(NSString *)ip port:(NSInteger)port deviceName:(NSString *)name;



@end
