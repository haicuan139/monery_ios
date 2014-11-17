//
//  EMHomeAutoScrollCell.h
//  moenycat
//
//  Created by haicuan139 on 14-10-9.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMDelegate.h"
#import "LocalConfigKey.h"
#import "SDWebImage/UIImageView+WebCache.h"
@interface EMHomeAutoScrollCell : UITableViewCell <EMDelegate>
@property (retain, nonatomic) IBOutlet UIView *autoScrollView;

@property (retain, nonatomic) IBOutlet UIImageView *headerImage;
@property (retain, nonatomic) IBOutlet UILabel *nickNameLable;
@property (retain, nonatomic) IBOutlet UILabel *telPhoneLable;
@property (retain, nonatomic) IBOutlet UILabel *balanceLable;
-(void)initInfo;
@end
