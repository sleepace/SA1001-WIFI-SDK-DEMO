//
//  SLPCollectStatus.h
//  SLPTCP
//
//  Created by San on 16/6/2020.
//  Copyright © 2020 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLPCollectStatus : NSObject
// 错误码
@property (nonatomic,assign) UInt16 errorCode;

@property (nonatomic , copy) NSString *deviceID;
@property (nonatomic , assign) UInt16 deviceType;
@property (nonatomic , assign) UInt8 collectionStatus;
@property (nonatomic , assign) UInt32 startTime;
@property (nonatomic,readonly) BOOL isCollecting;



@end

NS_ASSUME_NONNULL_END
