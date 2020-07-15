//
//  SLPTimingDataModel.m
//  Sleepace
//
//  Created by jie yang on 2017/6/26.
//  Copyright © 2017年 com.medica. All rights reserved.
//

#import "SLPTimingDataModel.h"

@implementation SLPTimingDataModel

-(instancetype)init{
    if (self = [super init]) {
        self.isOpen = NO;
        self.hour = 21;
        self.minute = 0;
        self.lastMin = 1;
    }
    
    return self;
}

- (void)fillDataWith:(SLPTimingDataModel *)timingModel
{
    self.isOpen = timingModel.isOpen;
    self.hour = timingModel.hour;
    self.minute = timingModel.minute;
    self.lastMin = timingModel.lastMin;
    self.seqId = timingModel.seqId;
}

- (BOOL)isEqualTo:(SLPTimingDataModel *)timingModel
{
    BOOL ret = NO;
    if (self.isOpen == timingModel.isOpen && self.hour == timingModel.hour && timingModel.minute == self.minute && self.lastMin == timingModel.lastMin && self.isOpen == timingModel.isOpen) {
        ret = YES;
    }
    
    return ret;
}
@end
