//
//  EMHomeViewController_v2.h
//  moenycat
//
//  Created by haicuan139 on 14-10-9.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMBaseViewController.h"
#import "EMHomeAutoScrollCell.h"
#import "CycleScrollView.h"
#import "ODRefreshControl.h"
#import "KeychainItemWrapper.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "FVCustomAlertView/FVCustomAlertView.h"
#import "EMAppDelegate.h"
#import "EDColor.h"
@interface EMHomeViewController_v2 : EMBaseViewController <UITableViewDelegate , UITableViewDataSource , EMDelegate>
@property (nonatomic , retain)  IBOutlet UITableView* tableView;
@property (nonatomic , retain)  NSMutableArray *viewsArray;
@property (nonatomic , retain)  NSMutableArray *adListArray;
@property (nonatomic , retain)  NSMutableArray *adLoopListArray;
@property (nonatomic , retain)  CycleScrollView *autoScrollView;
@property (nonatomic, strong)   UIPageControl *pageControl;
@property (nonatomic , retain)  ODRefreshControl *odRefreshView;
@property (nonatomic , retain)  EMDelegateClass *emclass;

-(void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl;
-(void)initAutoScrollView;
-(void)initPageControl;
-(void)initPullRefreshView;



@end
