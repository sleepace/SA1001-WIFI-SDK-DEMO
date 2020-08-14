//
//  SLPLabelCell.m
//  SA1001-Demo
//
//  Created by Michael on 2020/8/13.
//  Copyright © 2020 jie yang. All rights reserved.
//

#import "SLPLabelCell.h"

@implementation SLPLabelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.textColor = [Theme C4];
    self.titleLabel.font = [Theme T4];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
