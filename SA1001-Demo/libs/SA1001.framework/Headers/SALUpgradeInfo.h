//
//  SALUpgradeInfo.h
//  SA1001
//
//  Created by jie yang on 2019/8/9.
//  Copyright © 2019 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SALUpgradeInfo : NSObject

@property (nonatomic, assign) NSInteger status; // 升级状态

@property (nonatomic, assign) double currentVersion; // 当前版本

@property (nonatomic,assign) NSInteger currentLength;//当前长度

@end

NS_ASSUME_NONNULL_END
