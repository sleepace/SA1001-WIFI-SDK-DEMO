//
//  ConfigWifiViewController.h
//  SA1001-Demo
//
//  Created by jie yang on 2019/8/8.
//  Copyright © 2019 jie yang. All rights reserved.
//

#import "BaseViewController.h"
#import <BluetoothManager/BluetoothManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConfigWifiViewController : BaseViewController

@property (nonatomic, strong) SLPPeripheralInfo *peripheralInfo;

@end

NS_ASSUME_NONNULL_END
