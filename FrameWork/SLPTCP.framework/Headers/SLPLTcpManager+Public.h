//
//  SLPLTcpManager+Public.h
//  SLPTCP
//
//  Created by San on 16/6/2020.
//  Copyright © 2020 Martin. All rights reserved.
//

#import <SLPTCP/SLPTCP.h>
#import "SLPTCPOnlineStatus.h"
#import "SLPTCPBaseEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLPLTcpManager (Public)

/*固件升级通知
@param deviceID           :设备ID
@param deviceType         :设备类型
@param firmwareType       :固件类型
        0:无效    1:开发
        2:测试    3:发布
@param version   :最新固件版本号
*/
- (void)publicUpdateOperationWithDeviceID:(NSString *)deviceID deviceType:(SLPDeviceTypes)deviceType firmwareType:(UInt8)firmwareType firmwareVersion:(NSString *)version timeout:(CGFloat)timeout
                                 callback:(SLPTransforCallback)handle;



/*在线状态查询
 deviceID           :设备ID   UTF-8 带结束符( 例: "P1-1503000000")
 deviceType         :设备类型
 */
- (void)publicGetOnlineStatusWithDeviceID:(NSString *)deviceID deviceType:(SLPDeviceTypes)deviceType timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;


@end

NS_ASSUME_NONNULL_END
