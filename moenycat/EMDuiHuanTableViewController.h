//
//  EMDuiHuanTableViewController.h
//  moenycat
//
//  Created by haicuan139 on 14-9-7.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMBaseViewController.h"
#import "EMDuiHuanCell.h"
#import "ODRefreshControl.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "EMAppDelegate.h"
#import "FVCustomAlertView/FVCustomAlertView.h"
#import "EMDuihuanHistoryTableViewController.h"
@interface EMDuiHuanTableViewController : EMBaseViewController <UITableViewDelegate , UITableViewDataSource , EMDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain , nonatomic) ODRefreshControl *refreshControl;
@property (retain , nonatomic) EMDelegateClass *delegateClass;
@property (retain , nonatomic) NSMutableArray *duihuanArray;
-(void)rightItemClick;
-(void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl;
@end
