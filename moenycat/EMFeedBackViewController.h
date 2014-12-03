//
//  EMFeedBackViewController.h
//  moenycat
//
//  Created by haicuan139 on 14-11-13.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMBaseViewController.h"
#import "EDColor.h"
#import "FVCustomAlertView/FVCustomAlertView.h"
@interface EMFeedBackViewController : UIViewController <EMDelegate>
@property (retain, nonatomic) IBOutlet UITextField *feedBackContentField;
@property (retain, nonatomic) IBOutlet UIButton *feedBackCommit;
@property (retain , nonatomic) EMDelegateClass *delegateClass;
- (IBAction)postFeedBackText:(id)sender;

@end
