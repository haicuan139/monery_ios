//
//  EMBindViewController.h
//  moenycat
//
//  Created by haicuan139 on 14-11-12.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import "EMBaseViewController.h"
#import "EDCOlor.h"
#import "FVCustomAlertView/FVCustomAlertView.h"
@interface EMBindViewController : UIViewController <EMDelegate>
@property (retain, nonatomic) IBOutlet UITextField *bindName;
@property (retain, nonatomic) IBOutlet UITextField *bindPhone;
@property (retain, nonatomic) IBOutlet UITextField *bindCardNumber;
@property (retain, nonatomic) IBOutlet UITextField *bindCheckCode;
@property (retain, nonatomic) IBOutlet UIButton *bindButton;
@property (retain, nonatomic) EMDelegateClass *delegateClass;
- (IBAction)commitBindInfo:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *sendCodeButton;
- (IBAction)sendCode:(id)sender;
@property (retain ,nonatomic) NSUserDefaults *ud;

@end
