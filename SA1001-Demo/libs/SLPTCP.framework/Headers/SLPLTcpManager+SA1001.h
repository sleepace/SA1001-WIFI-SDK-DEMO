//
//  SLPLTcpManager+SA1001.h
//  SLPTCP
//
//  Created by Michael on 2020/7/8.
//  Copyright © 2020 Martin. All rights reserved.
//

#import <SLPTCP/SLPTCP.h>

#import "SA1001AidInfo.h"
#import "SA1001AlarmInfo.h"
#import "SA1001NightLightInfo.h"
#import "SA1001TimeAromaInfo.h"
#import "SA1001WorkMode.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLPLTcpManager (SA1001)

/**
 睡眠辅助操作
 @param deviceName 设备名称
 @param operation 操作类型 0x00: 正常操作 0x01: 重新开启 0x02: 停止助眠 0x03: 暂停助眠 0x04: 恢复助眠 0x05: 缓慢停止辅助
 @param lightFlag 灯开关 0: 关 1: 开 0xFF: 保持原状态
 @param musicFlag 音乐开关 0: 关 1: 开 0xFF: 保持原状态
 @param aromaFlag 香薰开关 0: 关 1: 开 0xFF: 保持原状态
 @param timeout 超时（单位秒）
 @param handle 回调
 */
- (void)salSleepAidWithOperation:(UInt8)operation lightFlag:(UInt8)lightFlag musicFlag:(UInt8)musicFlag aromaFlag:(UInt8)aromaFlag deviceInfo:(NSString *)deviceName timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 开始配置
 @param deviceName 设备名称
 @param mode 配置项 0x00: 测试模式(预留) 0x01: 日常模式 0x02: 睡眠辅助模式 0x03: 唤醒模式
 @param timeout 超时（单位秒）
 @param handle 回调
 */
- (void)salStartConfigWithMode:(UInt8)mode deviceInfo:(NSString *)deviceName timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 结束配置
 @param deviceName 设备名称
 @param mode 配置项 0x00: 测试模式(预留) 0x01: 日常模式 0x02: 睡眠辅助模式 0x03: 唤醒模式
 @param operation 操作码 0x00: 取消 0x01: 保存
 @param timeout 超时（单位秒）
 @param handle 回调
 */
- (void)salEndConfigWithMode:(UInt8)mode operation:(UInt8)operation deviceInfo:(NSString *)deviceName timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 音乐下载
 @param deviceName 设备名称
 @param deviceType 设备类型
 @param musicType 音乐类型 1：助眠音乐 2：闹钟音乐
 @param operation 操作类型 1 下载 2删除 3其他预留
 @param musicID 音乐编号
 @param timeout 超时（单位秒）
 @param handle 回调
 */
- (void)salDownloadMusicWithDeviceType:(SLPDeviceTypes)deviceType musicType:(UInt8)musicType operation:(UInt8)operation musicID:(UInt16)musicID deviceInfo:(NSString *)deviceName timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 中心按键功能设置
 @param deviceName
 设备名称

 @param lightEnable 灯开关 （颜色为助眠灯颜色）
 @param musicEnable 音乐开关 音乐为助眠音乐）
 @param aromaEnable 香薰开关 香薰速率为助眠香薰速率
 @param timeout 超时（单位秒）
 @param handle 回调
 */
- (void)salSetCenterKey:(BOOL)lightEnable musicEnable:(BOOL)musicEnable aromaEnable:(BOOL)aromaEnable deviceInfo:(NSString *)deviceName timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 删除所有定时香薰
 @param deviceName
 设备名称

 @param timeout 超时（单位秒）
 @param handle 回调
 */
- (void)sal:(NSString *)salName removeAllTimeAromaDeviceInfo:(NSString *)deviceName timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;


/**
 删除定时香薰
 @param deviceName
 设备名称

 @param aromaID 香薰ID
 @param timeout 超时（单位秒）
 @param handle 回调
 */
- (void)salDeleteTimeAroma:(UInt64)aromaID deviceInfo:(NSString *)deviceName timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;


/**
 修改定时香薰 有则改，无则加
 @param deviceName
 设备名称

 @param timeAromaList 定时香薰列表
 @param timeout 超时（单位秒）
 @param handle 回调
 */
- (void)salEditeTimeAromaList:(NSArray<SA1001TimeAromaInfo *> *)timeAromaList deviceInfo:(NSString *)deviceName timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 工作状态查询
 @param deviceName
 设备名称

 @param timeout 超时（单位秒）
 @param handle 回调 data类型为SA1001WorkMode
 */
- (void)salGetWorkStatusDeviceInfo:(NSString *)deviceName timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 设置小夜灯
 @param deviceName 设备名称

 @param info 小夜灯信息
 @param timeout 超时（单位秒）
 @param handle 回调
 */
- (void)salNightLightConfig:(SA1001NightLightInfo *)info deviceInfo:(NSString *)deviceName timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 控制香薰
 @param deviceName 设备名称
 设备名称

 @param rate 香薰速率 0-3 0：关闭
 @param timeout 超时时间（单位秒）
 @param handle 回调
 */
- (void)salSetAroma:(UInt8)rate deviceInfo:(NSString *)deviceName timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 打开白光
 @param deviceName
 设备名称

 @param light 灯光结构
 @param brightness 灯光亮度(0-100) 0:不亮
 @param timeout 超时时间（单位秒）
 @param handle 回调
 */
- (void)salTurnOnWhiteLight:(SLPLight *)light brightness:(UInt8)brightness deviceInfo:(NSString *)deviceName timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 打开彩光
 @param deviceName
 设备名称

 @param light 灯光结构
 @param brightness 灯光亮度(0-100) 0:不亮
 @param timeout 超时时间（单位秒）
 @param handle 回调
 */
- (void)salTurnOnColorLight:(SLPLight *)light brightness:(UInt8)brightness deviceInfo:(NSString *)deviceName timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 打开流光
 
 @param deviceName
 设备名称

 @param brightness 灯光亮度(0-100) 0:不亮
 @param timeout 超时时间（单位秒)
 @param handle 回调
 */
- (void)salTurnOnStreamerBrightness:(UInt8)brightness deviceInfo:(NSString *)deviceName timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 灯光亮度调节
 @param deviceName
 设备名称

 @param brightness 灯光亮度(0-100) 0:不亮
 @param timeout 超时时间（单位秒)
 @param handle 回调
 */
- (void)salLightBrightness:(UInt8)brightness deviceInfo:(NSString *)deviceName timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 关灯
 @param deviceName
 设备名称

 @param timeout 超时时间（单位秒)
 @param handle 回调
 */
- (void)salTurnOffLightDeviceInfo:(NSString *)deviceName timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 打开音乐
 @param deviceName
 设备名称

 @param musicID 音乐ID
 @param volume 音量 音量(0-16) 0:静音
 @param playMode //播放模式 0：顺序播放 1: 随机播放 2: 单曲播放
 @param timeout 超时时间（单位秒)
 @param handle 回调
 */
- (void)salTurnOnMusic:(UInt16)musicID volume:(UInt8)volume playMode:(UInt8)playMode deviceInfo:(NSString *)deviceName timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 停止音乐
 @param deviceName
 设备名称

 @param timeout 超时时间（单位秒)
 @param handle 回调
 */
- (void)salTurnOffMusicDeviceInfo:(NSString *)deviceName timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 暂停音乐
 @param deviceName
 设备名称

 @param timeout 超时时间（单位秒)
 @param handle 回调
 */
- (void)salPauseMusicDeviceInfo:(NSString *)deviceName timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 设置音量
 @param deviceName
 设备名称

 @param volume 音量(0-16) 0:静音
 @param timeout 超时时间（单位秒)
 @param handle 回调
 */
- (void)salSetMusicVolume:(UInt8)volume deviceInfo:(NSString *)deviceName timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 打开助眠灯
 @param deviceName
 设备名称

 @param light 灯结构
 @param brightness 灯光亮度(0-100) 0:不亮
 @param timeout 超时时间（单位秒)
 @param handle 回调
 */
- (void)salTurnOnSleepAidLight:(SLPLight *)light brightness:(UInt8)brightness deviceInfo:(NSString *)deviceName timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 助眠灯亮度调节
 @param deviceName
 设备名称

 @param brightness 灯光亮度(0-100) 0:不亮
 @param timeout 超时时间（单位秒)
 @param handle 回调
 */
- (void)salSetSleepAidLightBrightness:(UInt8)brightness deviceInfo:(NSString *)deviceName timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 打开助眠音乐
 @param deviceName
 设备名称

 @param musicID 音乐ID
 @param volume 音量(0-16) 0:静音
 @param playMode 播放模式 0：顺序播放 1: 随机播放 2: 单曲播放
 @param timeout 超时时间（单位秒)
 @param handle 回调
 */
- (void)salTurnOnsleepAidMusic:(UInt16)musicID volume:(UInt8)volume playMode:(UInt8)playMode deviceInfo:(NSString *)deviceName timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 停止助眠音乐
 @param deviceName
 设备名称

 @param timeout 超时时间（单位秒)
 @param handle 回调
 */
- (void)salTurnOffSleepAidMusicDeviceInfo:(NSString *)deviceName timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 助眠音量调节
 @param deviceName
 设备名称

 @param volume 音量(0-16) 0:静音
 @param timeout 超时时间（单位秒)
 @param handle 回调
 */
- (void)salSetSleepAidMusicVolume:(UInt8)volume deviceInfo:(NSString *)deviceName timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 设置助眠香薰
 @param deviceName
 设备名称

 @param rate 香薰速率 0-3 0：关闭
 @param timeout 超时时间（单位秒）
 @param handle 回调
 */
- (void)salSetAssistAroma:(UInt8)rate deviceInfo:(NSString *)deviceName timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 保存助眠配置信息
 
 @param deviceName
 设备名称

 @param monitor 监测设备名称 没有监测设备传空字符串或nil
 @param type 监测设备类型 没有监测设备传0
 @param info 助眠信息
 @param timeout 超时时间（单位秒)
 @param handle 回调
 */
- (void)salSleepAidConfig:(SA1001AidInfo *)info monitorDevice:(NSString *)monitor monitorDeviceType:(SLPDeviceTypes)type deviceInfo:(NSString *)deviceName timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 添加或修改闹铃
 @param deviceName
 设备名称

 @param alarmInfo 闹钟信息
 @param timeout 超时（单位秒）
 @param handle 回调
 */
- (void)salAlarmConfig:(SA1001AlarmInfo *)alarmInfo deviceInfo:(NSString *)deviceName timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 打开闹铃
 @param deviceName
 设备名称

 @param alarmID 闹钟ID
 @param timeout 超时（单位秒）
 @param handle 回调
 */
- (void)salTurnOnAlarm:(UInt64)alarmID deviceInfo:(NSString *)deviceName timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 关闭闹铃
 @param deviceName
 设备名称

 @param alarmID 闹铃ID
 @param timeout 超时（单位秒）
 @param handle 回调
 */
- (void)salTurnOffAlarm:(UInt64)alarmID deviceInfo:(NSString *)deviceName timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 删除闹铃
 @param deviceName
 设备名称

 @param alarmID 闹铃ID
 @param timeout 超时（单位秒）
 @param handle 回调
 */
- (void)salDelAlarm:(UInt64)alarmID deviceInfo:(NSString *)deviceName timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 闹铃预览
 @param deviceName
 设备名称

 @param volume 音量大小 闹钟最大音量(0-16) 0:静音
 @param brightness 灯光亮度 灯光最大亮度(0-100) 0:不亮
 @param aromaRate 香薰速率 0：关 1-3：三挡速率
 @param musicID 音乐编号
 @param timeout 超时（单位秒）
 @param handle 回调
 */
- (void)salStartAlarmRreviewVolume:(UInt8)volume brightness:(UInt8)brightness aromaRate:(UInt8)aromaRate musicID:(UInt16)musicID deviceInfo:(NSString *)deviceName timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 退出闹铃预览
 @param deviceName
 设备名称

 @param timeout 超时（单位秒）
 @param handle 回调
 */
- (void)salStopAlarmRreviewWithDeviceInfo:(NSString *)deviceName timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 启用闹铃 只启用, 不开闹钟
 @param deviceName
 设备名称

 @param alarmID 闹铃ID
 @param timeout 超时（单位秒）
 @param handle 回调
 */
- (void)salEnableAlarm:(UInt64)alarmID deviceInfo:(NSString *)deviceName timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 禁用闹铃 当前该闹钟在运行，则停止
 @param deviceName
 设备名称

 @param alarmID 闹铃ID
 @param timeout 超时（单位秒）
 @param handle 回调
 */
- (void)salDisableAlarm:(UInt64)alarmID deviceInfo:(NSString *)deviceName timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 设备开始升级
 @param deviceName
 设备名称
 
 @param currentHardwareVersion 设备当前版本号
 @param upgradeHardwareVersion 升级版本号
 @param upgradeType 升级类型
 @param url 升级地址
 @param handle 回调
 */
- (void)salCurrentHardwareVersion:(double)currentHardwareVersion upgradeHardwareVersion:(double)upgradeHardwareVersion upgradeType:(UInt8)upgradeType url:(NSString *)url deviceInfo:(NSString *)deviceName timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

@end

NS_ASSUME_NONNULL_END
