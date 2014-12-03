//
//  EMTiXianTableViewController.h
//  moenycat
//
//  Created by haicuan139 on 14-9-7.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMBaseViewController.h"
#import "EMTixianCell.h"
#import "EMAppDelegate.h"
#import "FVCustomAlertView/FVCustomAlertView.h"
@interface EMTiXianTableViewController : EMBaseViewController <EMDelegate>

@property (retain, nonatomic) EMDelegateClass *delegateClass;
@property (retain, nonatomic) NSMutableArray *tixianArray;
@end
