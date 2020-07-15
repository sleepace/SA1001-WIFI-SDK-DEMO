//
//  SLPLanTCP.h
//  Sleepace
//
//  Created by Martin on 10/26/16.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLPLanTCPCommon.h"
#import "SLPLanTCPSendPacket.h"
#import "SLPLanTCPParserV_0.h"
#import "SLPLanTCPParserV_1.h"
#import "SLPTCPDelegate.h"

@interface SLPLanTCP : NSObject
{
    SLPLanTCPParserV_0 *mParserV0;
    SLPLanTCPParserV_1 *mParserV1;
    NSMutableArray<SLPLanTCPBaseSendPacket *> *mLanSendPacketList;
}
@property (nonatomic,assign) SLPDeviceTypes deviceType;//设备类型
@property (nonatomic,copy) NSString *deviceName;//设备名称
@property (nonatomic,weak) id<SLPTCPDelegate>delegate;

- (void)toInit;
- (void)sendPacket:(SLPLanTCPBaseSendPacket *)packet;
- (void)disconnectCompletion:(void(^)())completion;
- (void)connectHost:(NSString *)host port:(NSInteger)port completion:(void(^)(BOOL succeed))completion;
- (BOOL)isConnected;

@end
