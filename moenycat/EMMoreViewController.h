//
//  EMMoreViewController.h
//  moenycat
//
//  Created by haicuan139 on 14-8-25.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMBaseViewController.h"
#import "EMMoreItemCell.h"
#import "EMMoreSoundOffCell.h"
#import "EMTABWodeInfoHeader.h"
#import "EMTableListCell.h"
#import "EAIntroView.h"
#import "EMMainViewController.h"
#import "EMAppDelegate.h"
@interface EMMoreViewController : EMBaseViewController <UITableViewDelegate,UITableViewDataSource>{
    NSArray *moreItemArray;
    NSArray *moreItemArray_sound;
}
@property (retain, nonatomic) IBOutlet UITableView *moreTableView;
@end
