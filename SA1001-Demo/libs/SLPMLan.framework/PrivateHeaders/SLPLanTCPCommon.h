//
//  SLPLanTCPCommon.h
//  Sleepace
//
//  Created by Martin on 10/26/16.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SLPLanTCPProtocalVersions){
    SLPLanTCPProtocalVersion_0 = 0,
    SLPLanTCPProtocalVersion_1,
};

typedef NS_ENUM(NSInteger, SLPLanTCPStatus) {
    SLPLanTCPStatus_Init = 0,//初始状态
    SLPLanTCPStatus_Connecting,//正在连接
    SLPLanTCPStatus_Connected,//已经连接
    SLPLanTCPStatus_Disconnected,//断开连接
};

typedef NS_ENUM(NSInteger, SLPLanTCPMessageUniqTypes) {
    SLPLanTCPMessageUniqTypes_Heartbeat,
    
    SLPLanTCPMessageUniqType_SALTimeCalibration,
    SLPLanTCPMessageUniqType_SALFactoryReset,
    SLPLanTCPMessageUniqType_SALGetMusicList,
    SLPLanTCPMessageUniqType_SALGetSystemInfo,
    SLPLanTCPMessageUniqType_SALGetVersionInfo,
    SLPLanTCPMessageUniqType_SALGetDeviceStatus,
    SLPLanTCPMessageUniqType_SALGetOperatingMode,
    SLPLanTCPMessageUniqType_SALGetProgressOfUPgrade,
    SLPLanTCPMessageUniqType_SALGetDeviceLog,
    SLPLanTCPMessageUniqType_SALUPgradeSummaryUpload,
    SLPLanTCPMessageUniqType_SALUPgradeContrentUpload,
    SLPLanTCPMessageUniqType_SALLightOperation,
    SLPLanTCPMessageUniqType_SALMusicOperation,
    SLPLanTCPMessageUniqType_SALSceneOperation,
    SLPLanTCPMessageUniqType_SALSleepAidOperation,
    SLPLanTCPMessageUniqType_SALAlarmOperation,
    SLPLanTCPMessageUniqType_SALPreviewOperation,
    SLPLanTCPMessageUniqType_SALPlayOperation,
    SLPLanTCPMessageUniqType_SALConfigureUserInfo,
    SLPLanTCPMessageUniqType_SALConfigureCommonScene,
    SLPLanTCPMessageUniqType_SALConfigureMultyScene,
    SLPLanTCPMessageUniqType_SALGetAlarmList,
    SLPLanTCPMessageUniqType_SALConfigureAlarm,
    SLPLanTCPMessageUniqType_SALGestureOperation,
    SLPLanTCPMessageUniqType_SALNightLightSetting,
    SLPLanTCPMessageUniqType_SALConfigureAlbum,
    SLPLanTCPMessageUniqType_SALAromaOperation,
    SLPLanTCPMessageUniqType_SALConfigurePIN,
    SLPLanTCPMessageUniqType_SALGetPINCode,
    SLPLanTCPMessageUniqType_SALConfigTimeAroma,
    SLPLanTCPMessageUniqType_SALConfigCenterKey,
    SLPLanTCPMessageUniqType_SALGetCenterKey,
    SLPLanTCPMessageUniqType_SALGetTimeAroma,
    SLPLanTCPMessageUniqTypes_SalOnePressOperation,
    
    // post消息
    SLPLanTCPMessageUniqType_SALPostOperatingMode,
    SLPLanTCPMessageUniqType_SalPostMusicPlayProgress,
    
    SLPLanTCPMessageUniqTypes_None,
};

typedef NS_ENUM(NSInteger,SLPLanTCPNox2PostMessageType) {
    SLPLanTCPNox2PostMessageType_WorkStatus = 0x41,//工作模式
    SLPLanTCPNox2PostMessageType_MusicPlayProgress = 0x45,//音乐播放进度
};

typedef NS_ENUM(NSInteger, RestoreDefaultSettings) {
    RestoreDefaultSettings_All = 0x00,
    RestoreDefaultSettings_ExceptWifiInfo,
};

typedef NS_ENUM(UInt8, AromaRate) {
    AromaRate_Off = 0,
    AromaRate_First,  // 低速
    AromaRate_Second, // 中速
    AromaRate_Third,  // 快速
    AromaRate_Invalid = 0xFF,//保持不变
};


typedef NS_ENUM(NSInteger,SLPAlbumExTypes) {
    SLPAlbumExTypes_None = 0,
    SLPAlbumExTypes_Geyser,//声光音乐
};

#define kMLanDefaultTimeoutInterval (10.0)

#define kBLEPreCode (0x12ef) //蓝牙老协议前导码
@interface SLPLanTCPCommon : NSObject
+ (NSString *)descriptionOfMessagetType:(SLPLanTCPMessageUniqTypes)type;
+ (NSString *)entityClassStringFrom:(SLPLanTCPMessageUniqTypes)type;

+ (BOOL)isReachableViaWiFi;

@end
