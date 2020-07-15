//
//  SLPLanTCPBaseEntity.h
//  Sleepace
//
//  Created by Martin on 10/26/16.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLPMLanCommonHeads.h"
#import "SDCCPEnums.h"

@interface SLPLanTCPBaseEntity : NSObject
@property (nonatomic,assign) NSInteger messageType;
@property (nonatomic,assign) UInt8 status;
@property (nonatomic,assign) SLPLanTCPMessageUniqTypes uniqType;
@property (nonatomic,readonly) BOOL isSucceed;

+ (SLPLanTCPBaseEntity *)entityWithLanTCPData:(NSData *)data;
- (id)initWithData:(NSData *)data;

- (NSString *)statusDescription;

//无参数的消息使用
+ (NSData *)content;

//检测是否还有其他的用处
//设备 -> APP post的消息在此处理
- (void)checkReuseableFor:(id)sender;
@end
