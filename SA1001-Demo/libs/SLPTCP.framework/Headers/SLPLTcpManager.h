//
//  SLPLTcpManager.h
//  Sleepace
//
//  Created by Martin on 10/26/16.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLPLTcp.h"


#define SLPSharedLTCP [SLPLTcpManager sharedInstance].lTcp
#define SLPSharedLTcpManager [SLPLTcpManager sharedInstance]

@class SLPLTcpServer;
@protocol SLPTCPManagerDelegate;
@interface SLPLTcpManager : NSObject

/**
 当前tcp连接状态值
 */
@property (nonatomic,readonly) SLPConnectStatus status;
@property (nonatomic,assign) BOOL enable;
@property (nonatomic,readonly) SLPLTcp *lTcp;
@property (nonatomic,weak) id<SLPTCPManagerDelegate>delegate;

+ (SLPLTcpManager *)sharedInstance;

- (void)toInit;

/**
TCP状态变化通知
@NSNotificationName kNotificationNameLTCPDisconnected  TCP断开通知
@NSNotificationName kNotificationNameLTCPConnected     TCP连接上通知
*/


/**
 socket连接登陆
 @param host ip地址
 @param port 端口号
 @param deviceID 设备ID
 @param token  sid
 @param completion 成功失败回调
 */
- (BOOL)loginHost:(NSString *)host port:(NSInteger)port deviceID:(NSString *)deviceID token:(NSString *)token completion:(void(^)(BOOL succeed))completion;

/**
 socket 主动断开连接操作
 @param completion 成功失败回调
 */
- (void)disconnectTCPCompletion:(void(^)(void))completion;

@end

/**
 socket回调delegate
 */
@protocol SLPTCPManagerDelegate <NSObject>

/**
 连接断开回调
 */
- (void)tcpDidDisconnect:(SLPLTcp *)tcp;

@end

