//
//  SLPTCPOnlineStatus.h
//  SLPTCP
//
//  Created by San on 16/6/2020.
//  Copyright © 2020 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLPTCPOnlineStatus : NSObject
// 错误码
@property (nonatomic,assign) UInt16 errorCode;

@property (nonatomic , copy) NSString *deviceID;
@property (nonatomic , assign) UInt16 deviceType;
//0:不在线 1:在线 0xFF:未知状态
@property (nonatomic , assign) UInt8 onlineStatus;
@property (nonatomic,readonly) BOOL isOnline;

@end

NS_ASSUME_NONNULL_END
