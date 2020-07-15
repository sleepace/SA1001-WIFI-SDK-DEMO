//
//  SALNightLightInfo.h
//  SA1001
//
//  Created by jie yang on 2019/8/2.
//  Copyright © 2019 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SLPCommon/SLPCommon.h>

NS_ASSUME_NONNULL_BEGIN

@interface SALNightLightInfo : NSObject

@property (nonatomic, assign) BOOL enable;
@property (nonatomic, assign) UInt8 brightness;//小夜灯亮度(0-100) 0:不亮
@property (nonatomic, strong) SLPLight *light;//小夜灯灯光
@property (nonatomic, assign) UInt8 startHour;//小夜灯开启时间的Hour
@property (nonatomic, assign) UInt8 startMinute;//小夜灯开启时间的Minute
@property (nonatomic, assign) UInt16 duration;//持续时长 单位：分钟， 表示小夜灯持续的时长  0不开启

@end

NS_ASSUME_NONNULL_END
