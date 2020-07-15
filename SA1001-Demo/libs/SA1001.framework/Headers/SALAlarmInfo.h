//
//  SALAlarmInfo.h
//  SA1001
//
//  Created by jie yang on 2019/8/2.
//  Copyright © 2019 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SALAlarmInfo : NSObject

@property (nonatomic, assign) UInt64 alarmID;//闹钟编号 唯一编号 一般由服务器提供
@property (nonatomic, assign) BOOL isOpen;//闹钟开关
@property (nonatomic, assign) UInt8 hour;//时
@property (nonatomic, assign) UInt8 minute;//分
/*重复
 周1-7 开关(0-6位) 0:关， 1:开
 全0表示单次闹钟,设置时间戳作为过期标准
 */
@property (nonatomic, assign) UInt8 flag;
@property (nonatomic, assign) UInt8 snoozeTime;//贪睡次数
@property (nonatomic, assign) UInt8 snoozeLength;//贪睡时长
@property (nonatomic, assign) UInt8 volume;//音量大小 0-16
@property (nonatomic, assign) UInt8 brightness;//亮度 0-100
@property (nonatomic, assign) BOOL shake;//震动是否打开
@property (nonatomic, assign) UInt16 musicID;//音乐ID
@property (nonatomic, assign) UInt8 aromaRate;//香薰速率 0：关 1-3：三挡速率
@property (nonatomic, assign) UInt32 timestamp;//时间戳 设置/修改闹钟时的标准时间戳（用于单次闹钟）

@end

NS_ASSUME_NONNULL_END
