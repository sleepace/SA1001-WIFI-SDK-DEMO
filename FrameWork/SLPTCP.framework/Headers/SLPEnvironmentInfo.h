//
//  SLPEnvironmentInfo.h
//  SLPTCP
//
//  Created by San on 16/6/2020.
//  Copyright © 2020 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLPEnvironmentInfo : NSObject

//温度：-127 -> 127
@property (nonatomic, assign) int8_t temperature;
//湿度：0 -> 100
@property (nonatomic, assign) UInt8 humidity;

// 错误码
@property (nonatomic,assign) UInt16 errorCode;

@end

NS_ASSUME_NONNULL_END
