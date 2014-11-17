//
//  EMMingXiViewController.h
//  moenycat
//
//  Created by haicuan139 on 14-9-11.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMBaseViewController.h"
#import "EMMingXiCell.h"
#import "ODRefreshControl.h"
@interface EMMingXiViewController : UITableViewController <EMDelegate>
-(void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl;
@property (nonatomic ,retain) NSMutableArray *mingxiArray;
@property (nonatomic , retain) EMDelegateClass *delegateClass;
@end
