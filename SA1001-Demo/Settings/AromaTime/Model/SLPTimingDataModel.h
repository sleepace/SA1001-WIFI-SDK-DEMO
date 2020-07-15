//
//  SLPTimingDataModel.h
//  Sleepace
//
//  Created by jie yang on 2017/6/26.
//  Copyright © 2017年 com.medica. All rights reserved.
//


typedef NS_ENUM(NSInteger, TimingActionMode) {
    TimingActionMode_Add = 0,
    TimingActionMode_Update,
    TimingActionMode_Delete,
};

@interface SLPTimingDataModel : NSObject

// 是否打开
@property (nonatomic, assign) BOOL isOpen;

//时
@property (nonatomic,assign)NSInteger hour;

//分
@property (nonatomic,assign)NSInteger minute;

//持续时间
@property (nonatomic, assign) NSInteger lastMin;

@property (nonatomic, strong) NSNumber *seqId;

- (void)fillDataWith:(SLPTimingDataModel *)timingModel;

- (BOOL)isEqualTo:(SLPTimingDataModel *)timingModel;

@end
