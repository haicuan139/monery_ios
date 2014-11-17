//
//  EMMyAdListTableViewController.h
//  moenycat
//
//  Created by haicuan139 on 14-9-7.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMADInfoCell.h"
#import "EMBaseViewController.h"
@interface EMMyAdListTableViewController : EMBaseViewController <UITableViewDataSource,UITableViewDelegate , EMDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) EMDelegateClass *delegateClass;
@property (retain, nonatomic) NSMutableArray *adlistArray;
@end
