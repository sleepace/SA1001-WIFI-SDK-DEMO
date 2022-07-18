//
//  SLPLTcpManager+TWP.h
//  SLPTCP
//
//  Created by San on 16/6/2020.
//  Copyright © 2020 Martin. All rights reserved.
//

#import <SLPTCP/SLPTCP.h>
#import "SLPCollectStatus.h"
#import "SLPEnvironmentInfo.h"
#import "SLPSleepStatus.h"
#import "SLPTCPBaseEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLPLTcpManager (TWP)

- (void)startRealTimeDataWithDeviceID:(NSString *)deviceID deviceType:(SLPDeviceTypes)deviceType timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

- (void)stopRealTimeDataWithDeviceID:(NSString *)deviceID deviceType:(SLPDeviceTypes)deviceType timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

//接口废弃
//- (void)startCollectionWithDeviceID:(NSString *)deviceID deviceType:(SLPDeviceTypes)deviceType userID:(NSString *)userID timeStamp:(UInt32)timeStamp timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

- (void)stopCollectionWithDeviceID:(NSString *)deviceID deviceType:(SLPDeviceTypes)deviceType userID:(NSString *)userID timeStamp:(UInt32)timeStamp timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

// MARK: - Query

- (void)getCollectionStatusWithDeviceID:(NSString *)deviceID deviceType:(SLPDeviceTypes)deviceType timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

- (void)getSleepStatusWithDeviceID:(NSString *)deviceID deviceType:(SLPDeviceTypes)deviceType timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

- (void)getEnvironmentInfoWithDeviceID:(NSString *)deviceID timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;


@end


NS_ASSUME_NONNULL_END
