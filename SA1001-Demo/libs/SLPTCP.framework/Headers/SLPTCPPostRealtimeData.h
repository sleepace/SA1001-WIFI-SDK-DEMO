//
//  SLPTCPPostRealtimeData.h
//  SLPTCP
//
//  Created by San on 16/6/2020.
//  Copyright © 2020 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SLPRealtimeDataBase;
@interface SLPTCPPostRealtimeData : NSObject

//设备ID    字串    14    UTF-8 带结束符( 例: "Z1-1503000000" )
@property (nonatomic,copy) NSString *deviceID;
//设备类型    USHORT    2    设备类型号
@property (nonatomic,assign) NSInteger deviceType;

//数目    UINT8    1    指明有多少个数据点
@property (nonatomic,assign) NSInteger dataNumber;

//实时数据列表
@property (nonatomic,strong) NSArray<SLPRealtimeDataBase *> *dataList;

@end

@interface SLPRealtimeDataBase : NSObject
@property (nonatomic,assign) UInt8 br;//呼吸率
@property (nonatomic,assign) UInt8 hr;//心率
@property (nonatomic,assign) NSInteger brStatus;//状态
//@property (nonatomic,assign) NSInteger brStatusValue;//状态值(废弃)
@property (nonatomic,readonly) BOOL isOffBed;//是否为离床
@property (nonatomic,readonly) BOOL isInit;
//时间戳    UINT32    4    单位：秒 时间戳，无符号整形
@property (nonatomic,assign) NSInteger timestamp;
//睡着标记    0: 未睡着  1: 睡着
@property (nonatomic,assign) NSInteger sleepFlag;
//清醒标记    0: 未清醒  1: 清醒
@property (nonatomic,assign) NSInteger awakeFlag;
@property (nonatomic, assign) NSInteger temperature;
//湿度：0 -> 100
@property (nonatomic, assign) NSInteger humidity;

@end
NS_ASSUME_NONNULL_END
