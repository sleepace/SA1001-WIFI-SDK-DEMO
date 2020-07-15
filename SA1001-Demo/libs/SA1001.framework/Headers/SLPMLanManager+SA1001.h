//
//  SLPMLanManager+SA1001.h
//  SA1001
//
//  Created by jie yang on 2019/8/2.
//  Copyright © 2019 Martin. All rights reserved.
//

#import <SLPMLan/SLPMLan.h>

#import <SLPCommon/SLPCommon.h>
#import "SALTimeAromaInfo.h"
#import "SALAlarmInfo.h"
#import "SALNightLightInfo.h"
#import "SALAidInfo.h"
#import "SALDeviceInfo.h"
#import "SALPINCode.h"
#import "SALCenterKey.h"
#import "SALDeviceInfo.h"
#import "SALWorkStatus.h"
#import "SALUpgradeInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLPMLanManager (SA1001)

/**
 连接设备
 @param salName 设备名称
 @param handle 回调 data类型为SABDeviceInfo
 */
- (void)sal:(NSString *)salName loginCallback:(SLPTransforCallback)handle;

/**
 时间校准
 @param salName 设备名称
 @param timeInfo 时间信息
 @param timeout 超时（单位秒）
 @param handle 回调 data类型为SABDeviceInfo
 */
- (void)sal:(NSString *)salName syncTimeInfo:(SLPTimeInfo*)timeInfo timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 获取设备信息
 @param salName
 设备名称

 @param timeout 超时（单位秒）
 @param handle 回调
 */
- (void)sal:(NSString *)salName getDeviceInfoTimeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 设备初始化
 @param salName
 设备名称

 @param timeout 超时（单位秒）
 @param handle 回调
 */
- (void)sal:(NSString *)salName deviceInitTimeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;


/**
 中心按键功能设置
 @param salName
 设备名称

 @param lightEnable 灯开关 （颜色为助眠灯颜色）
 @param musicEnable 音乐开关 音乐为助眠音乐）
 @param aromaEnable 香薰开关 香薰速率为助眠香薰速率
 @param timeout 超时（单位秒）
 @param handle 回调
 */
- (void)sal:(NSString *)salName setCenterKey:(BOOL)lightEnable musicEnable:(BOOL)musicEnable aromaEnable:(BOOL)aromaEnable
    timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 获取中心键
 @param salName
 设备名称

 @param timeout 超时时间（单位秒)
 @param handle 回调 返回SABCenterKey
 */
- (void)sal:(NSString *)salName getCenterKeyTimeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 删除所有定时香薰
 @param salName
 设备名称

 @param timeout 超时（单位秒）
 @param handle 回调
 */
- (void)sal:(NSString *)salName removeAllTimeAromaTimeout:(CGFloat)timeout  callback:(SLPTransforCallback)handle;


/**
 删除定时香薰
 @param salName
 设备名称

 @param aromaID 香薰ID
 @param timeout 超时（单位秒）
 @param handle 回调
 */
- (void)sal:(NSString *)salName deleteTimeAroma:(UInt64)aromaID timeout:(CGFloat)timeout  callback:(SLPTransforCallback)handle;


/**
 修改定时香薰 有则改，无则加
 @param salName
 设备名称

 @param timeAromaList 定时香薰列表
 @param timeout 超时（单位秒）
 @param handle 回调
 */
- (void)sal:(NSString *)salName editeTimeAromaList:(NSArray<SALTimeAromaInfo *> *)timeAromaList timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 获取定时香薰
 @param salName
 设备名称

 @param timeout 超时时间（单位秒)
 @param handle 回调 返回 NSArray<SLPSABGetTimeAromaList *>
 */
- (void)sal:(NSString *)salName getTimeAromaTimeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 工作状态查询
 @param salName
 设备名称

 @param timeout 超时（单位秒）
 @param handle 回调 data类型为SABWorkStatus
 */
- (void)sal:(NSString *)salName getWorkStatusTimeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 设备开始升级
 @param salName
 设备名称
 
 @param currentHardwareVersion 设备当前版本号
 @param upgradeHardwareVersion 升级版本号
 @param upgradeType 升级类型
 @param url 升级地址
 @param handle 回调
 */
- (void)sal:(NSString *)salName currentHardwareVersion:(double)currentHardwareVersion upgradeHardwareVersion:(double)upgradeHardwareVersion upgradeType:(UInt8)upgradeType url:(NSString *)url timeout:(CGFloat)timeout completion:(SLPTransforCallback)handle;

/**
 升级进度查询
 @param salName
 设备名称
 
 @param handle 回调 data类型为SALUpgradeInfo
 */
- (void)sal:(NSString *)salName getProgressOfUpgradeTimeout:(CGFloat)timeout completion:(SLPTransforCallback)handle;

/**
 添加或修改闹铃
 @param salName
 设备名称

 @param alarmInfo 闹钟信息
 @param timeout 超时（单位秒）
 @param handle 回调
 */
- (void)sal:(NSString *)salName alarmConfig:(SALAlarmInfo *)alarmInfo
    timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 获取闹钟列表
 @param salName
 设备名称

 @param timeout 超时（单位秒）
 @param handle 回调 返回 NSArray<SABAlarmInfo *>
 */
- (void)sal:(NSString *)salName getAlarmListTimeout:(CGFloat)timeout completion:(SLPTransforCallback)handle;

/**
 打开闹铃
 @param salName
 设备名称

 @param alarmID 闹钟ID
 @param timeout 超时（单位秒）
 @param handle 回调
 */
- (void)sal:(NSString *)salName turnOnAlarm:(UInt64)alarmID timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 关闭闹铃
 @param salName
 设备名称

 @param alarmID 闹铃ID
 @param timeout 超时（单位秒）
 @param handle 回调
 */
- (void)sal:(NSString *)salName turnOffAlarm:(UInt64)alarmID timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 删除闹铃
 @param salName
 设备名称

 @param alarmID 闹铃ID
 @param timeout 超时（单位秒）
 @param handle 回调
 */
- (void)sal:(NSString *)salName delAlarm:(UInt64)alarmID timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 闹铃预览
 @param salName
 设备名称

 @param volume 音量大小 闹钟最大音量(0-16) 0:静音
 @param brightness 灯光亮度 灯光最大亮度(0-100) 0:不亮
 @param aromaRate 香薰速率 0：关 1-3：三挡速率
 @param musicID 音乐编号
 @param timeout 超时（单位秒）
 @param handle 回调
 */
- (void)sal:(NSString *)salName startAlarmRreviewVolume:(UInt8)volume brightness:(UInt8)brightness aromaRate:(UInt8)aromaRate
    musicID:(UInt16)musicID timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 退出闹铃预览
 @param salName
 设备名称

 @param timeout 超时（单位秒）
 @param handle 回调
 */
- (void)sal:(NSString *)salName stopAlarmRreviewTimeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 启用闹铃 只启用, 不开闹钟
 @param salName
 设备名称

 @param alarmID 闹铃ID
 @param timeout 超时（单位秒）
 @param handle 回调
 */
- (void)sal:(NSString *)salName enableAlarm:(UInt64)alarmID timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 禁用闹铃 当前该闹钟在运行，则停止
 @param salName
 设备名称

 @param alarmID 闹铃ID
 @param timeout 超时（单位秒）
 @param handle 回调
 */
- (void)sal:(NSString *)salName disableAlarm:(UInt64)alarmID timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 设置小夜灯
 @param salName
 设备名称

 @param info 小夜灯信息
 @param timeout 超时（单位秒）
 @param handle 回调
 */
- (void)sal:(NSString *)salName nightLightConfig:(SALNightLightInfo *)info timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;


/**
 控制香薰
 @param salName
 设备名称

 @param rate 香薰速率 0-3 0：关闭
 @param timeout 超时时间（单位秒）
 @param handle 回调
 */
- (void)sal:(NSString *)salName setAroma:(UInt8)rate timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 打开白光
 @param salName
 设备名称

 @param light 灯光结构
 @param brightness 灯光亮度(0-100) 0:不亮
 @param timeout 超时时间（单位秒）
 @param handle 回调
 */
- (void)sal:(NSString *)salName turnOnWhiteLight:(SLPLight *)light brightness:(UInt8)brightness
    timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 打开彩光
 @param salName
 设备名称

 @param light 灯光结构
 @param brightness 灯光亮度(0-100) 0:不亮
 @param timeout 超时时间（单位秒）
 @param handle 回调
 */
- (void)sal:(NSString *)salName turnOnColorLight:(SLPLight *)light brightness:(UInt8)brightness
    timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 打开流光
 
 @param salName
 设备名称

 @param brightness 灯光亮度(0-100) 0:不亮
 @param timeout 超时时间（单位秒)
 @param handle 回调
 */
- (void)sal:(NSString *)salName turnOnStreamerBrightness:(UInt8)brightness
    timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 灯光亮度调节
 @param salName
 设备名称

 @param brightness 灯光亮度(0-100) 0:不亮
 @param timeout 超时时间（单位秒)
 @param handle 回调
 */
- (void)sal:(NSString *)salName lightBrightness:(UInt8)brightness
    timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 关灯
 @param salName
 设备名称

 @param timeout 超时时间（单位秒)
 @param handle 回调
 */
- (void)sal:(NSString *)salName turnOffLightTimeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 打开音乐
 @param salName
 设备名称

 @param musicID 音乐ID
 @param volume 音量 音量(0-16) 0:静音
 @param playMode //播放模式 0：顺序播放 1: 随机播放 2: 单曲播放
 @param timeout 超时时间（单位秒)
 @param handle 回调
 */
- (void)sal:(NSString *)salName turnOnMusic:(UInt16)musicID volume:(UInt8)volume playMode:(UInt8)playMode
    timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 停止音乐
 @param salName
 设备名称

 @param timeout 超时时间（单位秒)
 @param handle 回调
 */
- (void)sal:(NSString *)salName turnOffMusicTimeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 暂停音乐
 @param salName
 设备名称

 @param timeout 超时时间（单位秒)
 @param handle 回调
 */
- (void)sal:(NSString *)salName pauseMusicTimeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 设置音量
 @param salName
 设备名称

 @param volume 音量(0-16) 0:静音
 @param timeout 超时时间（单位秒)
 @param handle 回调
 */
- (void)sal:(NSString *)salName setMusicVolume:(UInt8)volume
    timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 设置播放模式
 @param salName
 设备名称

 @param playMode 播放模式 0：顺序播放 1: 随机播放 2: 单曲播放
 @param musicID 音乐ID
 @param volume 音量
 @param timeout 超时时间（单位秒)
 @param handle 回调
 */
- (void)sal:(NSString *)salName setPlayMode:(UInt8)playMode  musicID:(UInt16)musicID volume:(UInt8)volume
    timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 打开助眠灯
 @param salName
 设备名称

 @param light 灯结构
 @param brightness 灯光亮度(0-100) 0:不亮
 @param timeout 超时时间（单位秒)
 @param handle 回调
 */
- (void)sal:(NSString *)salName turnOnSleepAidLight:(SLPLight *)light brightness:(UInt8)brightness
    timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 助眠灯亮度调节
 @param salName
 设备名称

 @param brightness 灯光亮度(0-100) 0:不亮
 @param timeout 超时时间（单位秒)
 @param handle 回调
 */
- (void)sal:(NSString *)salName setSleepAidLightBrightness:(UInt8)brightness
    timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 打开助眠音乐
 @param salName
 设备名称

 @param musicID 音乐ID
 @param volume 音量(0-16) 0:静音
 @param playMode 播放模式 0：顺序播放 1: 随机播放 2: 单曲播放
 @param timeout 超时时间（单位秒)
 @param handle 回调
 */
- (void)sal:(NSString *)salName turnOnsleepAidMusic:(UInt16)musicID volume:(UInt8)volume playMode:(UInt8)playMode
    timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 停止助眠音乐
 @param salName
 设备名称

 @param timeout 超时时间（单位秒)
 @param handle 回调
 */
- (void)sal:(NSString *)salName turnOffSleepAidMusic:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 助眠音量调节
 @param salName
 设备名称

 @param volume 音量(0-16) 0:静音
 @param timeout 超时时间（单位秒)
 @param handle 回调
 */
- (void)sal:(NSString *)salName setSleepAidMusicVolume:(UInt8)volume timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;


/**
 设置助眠香薰
 @param salName
 设备名称

 @param rate 香薰速率 0-3 0：关闭
 @param timeout 超时时间（单位秒）
 @param handle 回调
 */
- (void)sal:(NSString *)salName setAssistAroma:(UInt8)rate timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 保存助眠配置信息
 
 @param salName
 设备名称

 @param info 助眠信息
 @param timeout 超时时间（单位秒)
 @param handle 回调
 */
- (void)sal:(NSString *)salName sleepAidConfig:(SALAidInfo *)info timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;


/**
 设置PIN码功能
 @param salName
 设备名称

 @param enable 是否开启PIN码功能
 @param timeout 超时时间（单位秒)
 @param handle 回调
 */
- (void)sal:(NSString *)salName configurePINWithEnable:(BOOL)enable timeout:(CGFloat)timeout completion:(SLPTransforCallback)handle;

/**
 获取PIN码功能
 @param salName
 设备名称

 @param timeout 超时时间（单位秒)
 @param handle 回调 返回SABPINCode
 */
- (void)sal:(NSString *)salName getPINCodeTimeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 一键打开或关闭香薰和灯光
 @param salName
 设备名称
 @param operation 0x00:关闭  0x01:打开
 @param mode 操作模式（照明或助眠灯）0x00:普通 0x01:照明 0x02:助眠 0x03:预助眠
 @param rate 香薰的速率 0：关 1-3：三挡速率
 @param brightness 灯光亮度
 @param lightMode 灯光模式（白灯，彩色灯或流光）0x00:白光 0x00:彩光 0x00:变化的流光
 @param light 灯光结构
 @param timeout 超时时间（单位秒)
 @param handle 回调
 */
- (void)sal:(NSString *)salName onePressWithOperation:(UInt8)operation mode:(UInt8)mode rate:(UInt8)rate brightness:(UInt8)brightness lightMode:(UInt8)lightMode light:(SLPLight *)light timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

@end

NS_ASSUME_NONNULL_END
