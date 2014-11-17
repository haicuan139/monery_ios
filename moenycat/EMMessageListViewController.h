//
//  EMMessageListViewController.h
//  moenycat
//
//  Created by haicuan139 on 14-9-5.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODRefreshControl.h"
#import "EMDelegate.h"
#import "EMMessageCell.h"
#import "FVCustomAlertView/FVCustomAlertView.h"
@interface EMMessageListViewController : UITableViewController <EMDelegate>
-(void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl;
@property (nonatomic , retain) NSMutableArray *messageArray;
@property (nonatomic , retain) EMDelegateClass *delegateClass;
@property (nonatomic , retain) ODRefreshControl *refreshController;
@end
