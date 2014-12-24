//
//  EMDuihuanInputInfoViewController.h
//  moenycat
//
//  Created by haicuan139 on 14-11-12.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import "EMBaseViewController.h"
#import "EDColor.h"
#import "EMAppDelegate.h"
@interface EMDuihuanInputInfoViewController : UIViewController <EMDelegate>
@property (retain, nonatomic) IBOutlet UITextField *duihuanName;
@property (retain, nonatomic) IBOutlet UITextField *duihuanPhone;
@property (retain, nonatomic) IBOutlet UITextField *duihanAddress;
@property (retain, nonatomic) IBOutlet UITextField *duihuanCount;
@property (retain, nonatomic) IBOutlet UIStepper *duihuanCountControllerButton;
@property (retain, nonatomic) NSUserDefaults *ud;
@property (retain, nonatomic) IBOutlet UIButton *duihuanCommit;
@property (retain, nonatomic) EMDelegateClass *delegateClass;
- (IBAction)postDuihuan:(id)sender;
- (void)valueChanged:(UIStepper *)Stepper;
@property (retain, nonatomic) IBOutlet UITextField *duihuanQQ;

@end
