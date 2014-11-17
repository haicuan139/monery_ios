//
//  EMDuiHuanHistoryCell.m
//  moenycat
//
//  Created by haicuan139 on 14-11-12.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import "EMDuiHuanHistoryCell.h"

@implementation EMDuiHuanHistoryCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_duihuanTime release];
    [_duihuanTitle release];
    [_duihuanName release];
    [_duihuanAddress release];
    [_duihuanStates release];
    [super dealloc];
}
@end
