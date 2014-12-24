//
//  EMADInfoCell.h
//  moenycat
//
//  Created by haicuan139 on 14-8-27.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImage/UIImageView+WebCache.h"
@interface EMADInfoCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *adTitleLable;
@property (retain, nonatomic) IBOutlet UILabel *adContentLable;
@property (retain, nonatomic) IBOutlet UIImageView *adIconImageView;
@property (retain, nonatomic) IBOutlet UIButton *adBalanceLable;
@property (retain, nonatomic) IBOutlet UIImageView *adOverImage;

@end
