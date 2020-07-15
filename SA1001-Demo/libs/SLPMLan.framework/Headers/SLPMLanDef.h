//
//  SLPMLanDef.h
//  SA1001
//
//  Created by jie yang on 2019/7/25.
//  Copyright © 2019 Martin. All rights reserved.
//

#ifndef SLPMLanDef_h
#define SLPMLanDef_h

typedef NS_ENUM(UInt8, MLTcp_RespondsCode) {
    SLP_MLTcp_Error_None = 0x00, //成功
    SLP_MLTcp_Error_MessageTypeError = 0x01,//错误的消息类型
    SLP_MLTcp_Error_ParameterError = 0x02,//参数错误
    SLP_MLTcp_Error_NotLogin = 0x03,//未登录
    SLP_MLTcp_Error_DataNotFound = 0x04,//数据不存在
    SLP_MLTcp_Error_DeviceTypeUnMatch = 0x05,//设备类型不匹配
    SLP_MLTcp_Error_UpgradePacketVerifyFailed = 0x06,//升级包校验错误
    SLP_MLTcp_Error_ProductionInfoError = 0x07,//没有正确的出厂信息
    SLP_MLTcp_Error_OperationError = 0x08,//操作错误
    SLP_MLTcp_Error_DeviceNotBond = 0x09,//设备未绑定
    SLP_MLTcp_Error_DeviceNotConnect = 0x0a,//设备未连接
    SLP_MLTcp_Error_DeviceNotFound = 0x0b,//设备未找到
    
    SLP_MLTcp_Error_UnKnown = 0xff,//未知错误
};

typedef NS_ENUM(NSInteger,SLPDeviceLoginReturnCodes) {
    SLPDeviceLoginReturnCode_NetworkDisconnect = -2,//网络连接断开
    SLPDeviceLoginReturnCode_BluetoothDisable = -1,//蓝牙没有打开
    SLPDeviceLoginReturnCode_Succeed = 0,//登录成功
    SLPDeviceLoginReturnCode_NotFind ,//没有找到设备
    SLPDeviceLoginReturnCode_ConnectFailed,//连接失败
    SLPDeviceLoginReturnCode_GetDeviceInfoFailed,//获取设备信息失败
    SLPDeviceLoginReturnCode_LoginFailed,//登录失败
    SLPDeviceLoginReturnCode_NotNeedToLoginAgain,//不需要重复登录
};

#define kNotificationNameWLANDeviceDisconnected @"kNotificationNameWLANDeviceDisconnected"
#define kNotificationNameWLANDeviceConnected @"kNotificationNameWLANDeviceConnected"

#endif /* SLPMLanDef_h */
