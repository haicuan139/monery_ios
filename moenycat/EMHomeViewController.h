//
//  EMHomeViewController.h
//  moenycat
//
//  Created by haicuan139 on 14-8-25.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMBaseViewController.h"

@interface EMHomeViewController : EMBaseViewController <UIScrollViewDelegate ,UITableViewDataSource , UITableViewDelegate>
{
    int autoScrollViewH;
    int tabCellHeight;

}

@property (nonatomic) int tableViewOffest;
@property (nonatomic , retain) CycleScrollView *mainScorllView;
@property (nonatomic, strong) UIRefreshControl* refreshControl;
@property (nonatomic , retain) UIScrollView *baseScrollView;
@property (nonatomic , retain) UITableView* tableView;
-(void)onPullRefreshCallBack:(UIRefreshControl *) refresh;
-(void)onPullDoneCallBack:(id)obj;
-(void)initPullToRefresh;
-(void)initAutoScrollView;
-(void)onPageControlClickCallback;
-(void)initTabView;
-(void)initTitleItem;
-(void)initHeaderView;
-(void)setHeaderViewGone:(BOOL)hidden;
@end
