//
//  EMTixianCell.m
//  moenycat
//
//  Created by haicuan139 on 14-9-11.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import "EMTixianCell.h"

@implementation EMTixianCell

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
    [_titleLable release];
    [_descriptionLable release];
    [super dealloc];
}
@end
