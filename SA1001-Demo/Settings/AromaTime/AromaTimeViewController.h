//
//  AromaTimeViewController.h
//  SA1001-2-demo
//
//  Created by jie yang on 2018/11/14.
//  Copyright © 2018年 jie yang. All rights reserved.
//

#import "BaseViewController.h"

#import "SLPTimingDataModel.h"

typedef NS_ENUM(NSInteger, AromaTimePageType) {
    AromaTimePageType_edit,
    AromaTimePageType_Add,
};

@protocol AromaTimeViewControllerDelegate <NSObject>

@optional
- (void)editAromaTimeAndShouldReload;

@end

NS_ASSUME_NONNULL_BEGIN

@interface AromaTimeViewController : BaseViewController

@property (nonatomic, assign) AromaTimePageType pageType;

@property (nonatomic, strong) SLPTimingDataModel *originTimeData;

@property (nonatomic, assign) NSInteger addID;

@property (nonatomic, weak) id<AromaTimeViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
