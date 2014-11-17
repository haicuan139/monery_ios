//
//  EMBindViewController.m
//  moenycat
//
//  Created by haicuan139 on 14-11-12.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import "EMBindViewController.h"

@interface EMBindViewController ()

@end

@implementation EMBindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"绑定信息"];
    [_bindName becomeFirstResponder];
    [_bindButton setBackgroundColor:[UIColor colorWithHexString:@"#ad1524"]];
    [_bindButton.layer setMasksToBounds:YES];
    [_bindButton.layer setCornerRadius:4.0];
    [_sendCodeButton setBackgroundColor:[UIColor colorWithHexString:@"#ad1524"]];
    [_sendCodeButton.layer setMasksToBounds:YES];
    [_sendCodeButton.layer setCornerRadius:4.0];
    _delegateClass = [[EMDelegateClass alloc]init];
    _delegateClass.rootView = self.view;
    _delegateClass.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
}



- (void)dealloc {
    [_bindName release];
    [_bindPhone release];
    [_bindCardNumber release];
    [_bindCheckCode release];
    [_bindButton release];
    [_sendCodeButton release];
    [_delegateClass release];
    [super dealloc];
}
-(void)initBaseLeftItem{
    
}
- (IBAction)commitBindInfo:(id)sender {

    //去掉焦点
    [_bindName resignFirstResponder];
        [_bindCardNumber resignFirstResponder];
        [_bindPhone resignFirstResponder];
        [_bindCheckCode resignFirstResponder];
    NSString *localCode = [self getStringValueForKey:CONFIG_KEY_BIND_SMSCODE];
    NSString *inputCode = _bindCheckCode.text;
    if (inputCode.length > 0 && [inputCode isEqualToString:localCode]) {
        NSString *number = _bindCardNumber.text;
        NSString *name = _bindName.text;
        //发送申请
        [_delegateClass EMDelegatePostBindInfo];
        //提交绑定信息
        [self setStringValueForKey:CONFIG_KEY_BIND_SAFE_NUMBER val:number];
        [self setStringValueForKey:CONFIG_KEY_BIND_SAFE_NAME val:name];
        [_delegateClass EMDelegatePostMyInfo];
    } else {
        [FVCustomAlertView showDefaultWarningAlertOnView:self.view withTitle:@"验码不对"];
    }
}
-(void)onSmsCodeSendDone:(NSString *)rcode{
    NSLog(@"接收到验证码：%@",rcode);

}
-(void)onPostBindInfoDone{
    //绑定完成
    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.navigationController popViewControllerAnimated:YES];
    });

}
- (IBAction)sendCode:(id)sender {
    [_bindName resignFirstResponder];
    [_bindCardNumber resignFirstResponder];
    [_bindPhone resignFirstResponder];
    [_bindCheckCode resignFirstResponder];
    //发送验证码
    NSString *tel = _bindPhone.text;
    if (tel.length != 11) {
        [FVCustomAlertView showDefaultWarningAlertOnView:self.view withTitle:@"号码不对"];
    } else {
        //保存号码
        [self setStringValueForKey:CONFIG_KEY_BIND_SAFE_PHONE val:tel];
        //发送
        [_delegateClass EMDelegateSendSmsCode];
    }
}
@end
