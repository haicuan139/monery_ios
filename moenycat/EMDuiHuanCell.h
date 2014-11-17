//
//  EMDuiHuanCell.h
//  moenycat
//
//  Created by haicuan139 on 14-9-11.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDColor.h"
@interface EMDuiHuanCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *title;
@property (retain, nonatomic) IBOutlet UILabel *balance;
@property (retain, nonatomic) IBOutlet UILabel *dcount;
@property (retain, nonatomic) IBOutlet UIImageView *adImage;
@property (retain, nonatomic) IBOutlet UIView *cellBgView;

@end
