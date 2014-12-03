//
//  EMTixianInputInfoViewController.m
//  moenycat
//
//  Created by haicuan139 on 14-11-11.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import "EMTixianInputInfoViewController.h"

@interface EMTixianInputInfoViewController ()

@end

@implementation EMTixianInputInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"提现"];
    [self initTextFiled];
    [_tixianCommitButton setBackgroundColor:[UIColor colorWithHexString:@"#ad1524"]];
    [_tixianCommitButton.layer setMasksToBounds:YES];
    [_tixianCommitButton.layer setCornerRadius:4.0];
    //读取提现信息
    NSString *name = [self.ud stringForKey:CONFIG_KEY_BANK_NAME];
    NSString *bkn = [self.ud stringForKey:CONFIG_KEY_BANK_NUMBER];
    NSString *bka = [self.ud stringForKey:CONFIG_KEY_BANK_ADDR];
    NSString *phone = [self.ud stringForKey:CONFIG_KEY_BANK_PHONE];
    [_tixianName setText:name];
    [_tixianBankNumber setText:bkn];
    [_tixianBackAddress setText:bka];
    [_tixianPhoneNumber setText:phone];
    _delegateClass = [[EMDelegateClass alloc]init];
    _delegateClass.rootView = self.view;
    _delegateClass.delegate = self;

}
-(void)initBaseLeftItem{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
-(void)initTextFiled{
    [_tixianName becomeFirstResponder];
    
}

-(IBAction)tixianCommit:(id)sender {
    //保存提现信息
    NSString *name = _tixianName.text;
    NSString *bkn = _tixianBankNumber.text;
    NSString *bka = _tixianBackAddress.text;
    NSString *phone = _tixianPhoneNumber.text;
    if (name.length != 0 && bkn.length != 0 && bka.length != 0 && phone.length != 0) {
        [_ud setObject:name forKey:CONFIG_KEY_BANK_NAME];
        [_ud setObject:bkn forKey:CONFIG_KEY_BANK_NUMBER];
        [_ud setObject:bka forKey:CONFIG_KEY_BANK_ADDR];
        [_ud setObject:phone forKey:CONFIG_KEY_BANK_PHONE];
        [_delegateClass EMDelegateTixianCommit];
    } else {
        [FVCustomAlertView showDefaultWarningAlertOnView:self.view withTitle:@"信息不完整"];
    }
    [_tixianName resignFirstResponder];
        [_tixianBankNumber resignFirstResponder];
        [_tixianBackAddress resignFirstResponder];
        [_tixianPhoneNumber resignFirstResponder];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_tixianName release];
    [_tixianBankNumber release];
    [_tixianBackAddress release];
    [_tixianPhoneNumber release];
    [_tixianCommitButton release];
    [_ud release];
    [super dealloc];
}
@end
