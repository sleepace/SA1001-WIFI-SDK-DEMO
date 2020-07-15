//
//  SLPCenterButtonSetting.h
//  Sleepace
//
//  Created by jie yang on 2017/6/28.
//  Copyright © 2017年 com.medica. All rights reserved.
//


static NSString *const kMusic = @"music";
static NSString *const kLight = @"light";
static NSString *const kAroma = @"aroma";

@interface SLPCenterButtonSetting : NSObject

@property (nonatomic, assign) BOOL musicSelected;

@property (nonatomic, assign) BOOL lightSelected;

@property (nonatomic, assign) BOOL aromaSelected;

@property (nonatomic, copy) NSNumber *seqId;

- (void)fillDataWithDict:(NSDictionary *)dict;

- (void)fillDataWith:(SLPCenterButtonSetting *)centerSetting;

- (BOOL)isEqualATo:(SLPCenterButtonSetting *)centerSetting;

@end
