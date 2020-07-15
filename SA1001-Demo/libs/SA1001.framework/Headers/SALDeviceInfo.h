//
//  SALDeviceInfo.h
//  SA1001
//
//  Created by jie yang on 2019/8/2.
//  Copyright © 2019 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SALDeviceInfo : NSObject

@property (nonatomic, copy) NSString *deviceID;//设备ID
@property (nonatomic, assign) NSString *firmwareVersion;//固件版本

@end

NS_ASSUME_NONNULL_END
