//
//  EMADTaskCell.h
//  moenycat
//
//  Created by haicuan139 on 14-9-3.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMADTaskCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *taskIcon;
@property (retain, nonatomic) IBOutlet UILabel *tableTitle;
@property (retain, nonatomic) IBOutlet UILabel *taskBalanceLable;

@end
