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
    _ud = [NSUserDefaults standardUserDefaults];
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
    [_ud release];
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

    NSString *localCode =     [_ud stringForKey:CONFIG_KEY_BIND_SMSCODE];
    NSString *inputCode = _bindCheckCode.text;
    if (inputCode.length > 0 && [inputCode isEqualToString:localCode]) {
        NSString *number = _bindCardNumber.text;
        NSString *name = _bindName.text;
        //发送申请
        [_delegateClass EMDelegatePostBindInfo];
        //提交绑定信息
        [_ud setObject:number forKey:CONFIG_KEY_BIND_SAFE_NUMBER];
                [_ud setObject:name forKey:CONFIG_KEY_BIND_SAFE_NAME];
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
        [_ud setObject:tel forKey:CONFIG_KEY_BIND_SAFE_PHONE];
        //发送
        [_delegateClass EMDelegateSendSmsCode];
    }
}
@end
