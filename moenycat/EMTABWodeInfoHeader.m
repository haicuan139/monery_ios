//
//  EMTABWodeInfoHeader.m
//  moenycat
//
//  Created by haicuan139 on 14-9-5.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import "EMTABWodeInfoHeader.h"

@implementation EMTABWodeInfoHeader

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_tabHeaderIcon release];
    [_tabHeaderNickLable release];
    [_tabHeaderTelLable release];
    [_tabHeaderBaseInfoLable release];
    [super dealloc];
}
@end
