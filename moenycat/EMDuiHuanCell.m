//
//  EMDuiHuanCell.m
//  moenycat
//
//  Created by haicuan139 on 14-9-11.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import "EMDuiHuanCell.h"

@implementation EMDuiHuanCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
            [_cellBgView setBackgroundColor:[UIColor whiteColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {

    [_title release];
    [_balance release];
    [_dcount release];
    [_adImage release];
    [_cellBgView release];
    [super dealloc];
}
@end
