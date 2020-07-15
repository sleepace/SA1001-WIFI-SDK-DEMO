//
//  SLPCenterButtonSetting.m
//  Sleepace
//
//  Created by jie yang on 2017/6/28.
//  Copyright © 2017年 com.medica. All rights reserved.
//

#import "SLPCenterButtonSetting.h"

@implementation SLPCenterButtonSetting

-(instancetype)init
{
    if (self = [super init]) {
        self.musicSelected = YES;
        self.lightSelected = YES;
        self.aromaSelected = YES;
    }
    
    return self;
}

- (void)fillDataWith:(SLPCenterButtonSetting *)centerSetting
{
    self.musicSelected = centerSetting.musicSelected;
    self.lightSelected = centerSetting.lightSelected;
    self.aromaSelected = centerSetting.aromaSelected;
    self.seqId = centerSetting.seqId;
}

- (BOOL)isEqualATo:(SLPCenterButtonSetting *)centerSetting
{
    BOOL ret = NO;
    if (self.musicSelected == centerSetting.musicSelected && self.lightSelected == centerSetting.lightSelected && self.aromaSelected == centerSetting.aromaSelected) {
        ret = YES;
    }
    
    return  ret;
}

- (void)fillDataWithDict:(NSDictionary *)dict
{
    if (!dict || [dict isKindOfClass:[NSNull class]]) {
        return;
    }
    
    
    NSDictionary *settingDict = [dict objectForKey:@"centerButton"];
    self.seqId = [settingDict objectForKey:@"seqid"];
    
    NSString *settingValue = [settingDict objectForKey:@"settingValue"];
    NSArray *selectedValues = [settingValue componentsSeparatedByString:@","];
    
    self.musicSelected = NO;
    self.lightSelected = NO;
    self.aromaSelected = NO;
    for (NSString *str in selectedValues) {
        if ([str isEqualToString:kMusic]) {
            self.musicSelected = YES;
        }
        
        if ([str isEqualToString:kLight]) {
            self.lightSelected = YES;
        }
        
        if ([str isEqualToString:kAroma]) {
            self.aromaSelected = YES;
        }
    }
    
}

@end
