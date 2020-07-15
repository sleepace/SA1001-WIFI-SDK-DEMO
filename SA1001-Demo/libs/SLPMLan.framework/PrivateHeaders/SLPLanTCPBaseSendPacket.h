//
//  SLPLanTCPBaseSendPacket.h
//  Sleepace
//
//  Created by Martin on 10/26/16.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLPDataTransferCommon.h"
#import "SLPMLanCommonHeads.h"

@class SLPLanTCPBaseSendPacket;
@protocol SLPLanTCPBaseSendPacketDelegate <NSObject>
- (void)sendPacketTimeout:(SLPLanTCPBaseSendPacket *)sendPacket;
@end

@interface SLPLanTCPBaseSendPacket : NSObject
@property (nonatomic,weak) id<SLPLanTCPBaseSendPacketDelegate> delegate;
@property (nonatomic,assign) SLPLanTCPProtocalVersions protocalType;//协议类型 对应版本
@property (nonatomic,assign) SLPDeviceTypes deviceType;//设备类型
@property (nonatomic,assign) SLPFramTypes framType;//帧类型
@property (nonatomic,assign) NSInteger messageType;//消息类型
@property (nonatomic,readonly) NSInteger sequence;//消息序号
@property (nonatomic,strong) NSData *content;//消息内容 //纯内容，一些参数
//控制用的
//自定义的消息类型~ 和蓝牙的消息一一对应
@property (nonatomic,assign) SLPLanTCPMessageUniqTypes uniqMessageType;
@property (nonatomic,assign) CGFloat timeout;//超时时间
@property (nonatomic,copy) SLPTransforCompletion completion;

- (NSData *)packet;

- (void)fire;
- (void)invalidate;
@end
