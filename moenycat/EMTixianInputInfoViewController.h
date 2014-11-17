//
//  EMTixianInputInfoViewController.h
//  moenycat
//
//  Created by haicuan139 on 14-11-11.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import "EMBaseViewController.h"
#import "EDColor.h"
@interface EMTixianInputInfoViewController : EMBaseViewController <EMDelegate>
@property (retain, nonatomic) IBOutlet UITextField *tixianName;
@property (retain, nonatomic) IBOutlet UITextField *tixianBankNumber;
@property (retain, nonatomic) IBOutlet UITextField *tixianBackAddress;
@property (retain, nonatomic) IBOutlet UITextField *tixianPhoneNumber;
@property (retain, nonatomic) IBOutlet UIButton *tixianCommitButton;
@property (retain , nonatomic) EMDelegateClass *delegateClass;
-(void)initTextFiled;
- (IBAction)tixianCommit:(id)sender;

@end
