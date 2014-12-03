//
//  EMRecommendViewController_v2.h
//  moenycat
//
//  Created by haicuan139 on 14-10-9.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import "EMBaseViewController.h"
#import "EMHomeAutoScrollCell.h"
#import "CycleScrollView.h"
#import "EMRecommendAutoScrollCell.h"
#import "EMADTaskCell.h"
#import "ODRefreshControl.h"
#import "EMAppDelegate.h"
@interface EMRecommendViewController_v2 : EMBaseViewController <UIScrollViewDelegate , EMDelegate>
@property (nonatomic , retain) NSMutableArray *viewsArray;
@property (nonatomic , retain) NSMutableArray *taskListArray;
@property (nonatomic , retain) NSMutableArray *taskLoopListArray;
@property (nonatomic , retain) CycleScrollView *autoScrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) ODRefreshControl *refreshView;
@property (nonatomic, strong) EMDelegateClass *delegateClass;
-(void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl;
-(void)initAutoScrollView;
-(void)initPageControl;
-(void)initPullRefreshView;

@end
