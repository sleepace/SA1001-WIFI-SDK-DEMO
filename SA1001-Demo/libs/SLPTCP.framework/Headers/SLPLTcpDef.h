//
//  SLPLTcpDef.h
//  EW202W
//
//  Created by Michael on 2020/5/11.
//  Copyright © 2020 Martin. All rights reserved.
//

#ifndef SLPLTcpDef_h
#define SLPLTcpDef_h



// MARK: - Device

/**
 TCP长连接断开了
 */
#define kNotificationNameLTCPDisconnected @"kNotificationNameLTCPDisconnected"
/**
 长连接连接上
 */
#define kNotificationNameLTCPConnected @"kNotificationNameLTCPConnected"
/**
 TCP 设备升级进度
 */
#define kNotificationNameTCPDeviceUpdateRateChanged @"kNotificationNameTCPDeviceUpdateRateChanged"
/**
 EW202W的工作状态发生了变化
 */
#define kNotificationNameEW202WWorkModeChanged @"kNotificationNameEW202WWorkModeChanged"

/**
 设备在线状态发生改变
 */
#define kNotificationNameRequestDeviceOnlineStatusChanged @"kNotificationNameRequestDeviceOnlineStatusChanged"

/*
 设备采集状态变化
*/
#define kNotificationNameDeviceCollectStatusChanged @"kNotificationNameDeviceCollectStatusChanged"

/**
 post实时数据
 */
#define kNotificationNameWiFiDeviceRealtimeData @"kNotificationNameWiFiDeviceRealtimeData"
/**
 睡眠状态状态发生了改变
 */
#define kNotificationNameDeviceSleepStatusChanged @"kNotificationNameDeviceSleepStatusChanged"

/**
 历史数据分析生成概要报送
 */
//#define kNotificationNameDevicePostHistoryAnalysisData @"kNotificationNameDevicePostHistoryAnalysisData"

/*
 历史数据上传完成通知
 */
#define kNotificationNameHistoryDataUploadFinished @"kNotificationNameHistoryDataUploadFinished"

/**
 SA1001的音乐下载状态发生了变化
 */
#define kNotificationNameSA1001MusicDownloadChanged @"kNotificationNameSA1001MusicDownloadChanged"

#define kNotificationNameSA1001WorkModeChanged @"kNotificationNameSA1001WorkModeChanged"//SA1001的工作状态发生了变化

#endif /* SLPLTcpDef_h */
