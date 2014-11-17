//
//  EMTTabWoDeViewController.h
//  moenycat
//
//  Created by haicuan139 on 14-8-25.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMBaseViewController.h"
#import "EMTABWodeInfoHeader.h"
#import "EMTableListCell.h"
#import "SDWebImage/UIImageView+WebCache.h"
@interface EMTTabWoDeViewController : EMBaseViewController <UITableViewDataSource,UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *myinfoTableView;

@end
