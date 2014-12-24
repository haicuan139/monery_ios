//
//  EMADInfoCell.m
//  moenycat
//
//  Created by haicuan139 on 14-8-27.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import "EMADInfoCell.h"

@implementation EMADInfoCell

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
    [_adTitleLable release];
    [_adContentLable release];
    [_adIconImageView release];
    [_adBalanceLable release];
    [_adOverImage release];
    [super dealloc];
}
@end
