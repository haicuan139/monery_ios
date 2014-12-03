//
//  EMEditIViewController.h
//  moenycat
//
//  Created by haicuan139 on 14-9-7.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMBaseViewController.h"
#import "EMEditCell.h"
#import "EMAppDelegate.h"
#import "FVCustomAlertView/FVCustomAlertView.h"
@interface EMEditIViewController : EMBaseViewController <UITextFieldDelegate>
-(void)saveText;
-(void)cancel;
-(void)textFieldDidChange:(UITextField *)textField;
@end
