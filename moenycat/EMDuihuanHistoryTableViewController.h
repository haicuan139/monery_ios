//
//  EMDuihuanHistoryTableViewController.h
//  moenycat
//
//  Created by haicuan139 on 14-11-12.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMDuiHuanHistoryCell.h"
#import "EMDelegate.h"
#import  "FVCustomAlertView/FVCustomAlertView.h"
#import "EDColor.h"
@interface EMDuihuanHistoryTableViewController : UITableViewController <EMDelegate>
@property (retain , nonatomic) EMDelegateClass *delegateClass;
@property (retain , nonatomic) NSMutableArray *historyListArray;

@end
