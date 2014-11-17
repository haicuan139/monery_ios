//
//  EMMessageCell.m
//  moenycat
//
//  Created by haicuan139 on 14-11-13.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import "EMMessageCell.h"

@implementation EMMessageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_msgTitle release];
    [_msgContent release];
    [_msgTime release];
    [super dealloc];
}
@end
