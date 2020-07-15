//
//  SLPMLanServiceObject.h
//  Sleepace
//
//  Created by Martin on 10/25/16.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLPMLanServiceObject : NSObject
@property (nonatomic,copy) NSString *deviceName;
@property (nonatomic,copy) NSString *deviceID;
@property (nonatomic,copy) NSString *ip;
@property (nonatomic,copy) NSString *macAddr;
@property (nonatomic,copy) NSString *version;


+ (instancetype)serviceObjectWithData:(NSData *)data;

@end
