//
//  SLPSleepStatus.h
//  SLPTCP
//
//  Created by San on 17/6/2020.
//  Copyright © 2020 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLPSleepStatus : NSObject
// 错误码
@property (nonatomic,assign) UInt16 errorCode;

@property (nonatomic , copy) NSString *deviceID;
@property (nonatomic , assign) UInt16 deviceType;
//@property (nonatomic , assign) UInt8 number;
@property (nonatomic , assign) UInt8 sleepFlag;//入睡标记
@property (nonatomic , assign) UInt8 weakFlag;// 唤醒标记
@property (nonatomic , assign) UInt8 leftbedFlag;//离床标记
/**
 睡眠深度
 0x00: 无效（表示暂不支持该功能）
 0x01: 清醒
 0x02: 浅睡
 0x03: 中睡
 0x04: 深睡
 */
//@property (nonatomic , assign) UInt8 sleepStatus;
/*
 0x00: 躺着
 0x01: 坐起
 */
@property (nonatomic , assign) UInt8 sitStatus; //起坐状态

@end

NS_ASSUME_NONNULL_END
