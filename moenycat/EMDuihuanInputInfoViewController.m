//
//  EMDuihuanInputInfoViewController.m
//  moenycat
//
//  Created by haicuan139 on 14-11-12.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import "EMDuihuanInputInfoViewController.h"

@interface EMDuihuanInputInfoViewController ()

@end

@implementation EMDuihuanInputInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"兑换申请"];
    //加载上次的地址
    NSString *addr = [self getStringValueForKey:CONFIG_KEY_DUIHUAN_ADDR];
    NSString *name = [self getStringValueForKey:CONFIG_KEY_DUIHUAN_NAME];
    NSString *phone = [self getStringValueForKey:CONFIG_KEY_DUIHUAN_PHONE];
    [_duihuanName setText:name];
    [_duihuanPhone setText:phone];
    [_duihanAddress setText:addr];
    [_duihuanCommit setBackgroundColor:[UIColor colorWithHexString:@"#ad1524"]];
    [_duihuanCommit.layer setMasksToBounds:YES];
    [_duihuanCommit.layer setCornerRadius:4.0];
    [_duihuanName becomeFirstResponder];
    _duihuanCountControllerButton.minimumValue = 1;
    EMAppDelegate *app = [[UIApplication sharedApplication] delegate];
    NSDictionary *dic = app.duihuanDic;
        int maxValue = [[dic objectForKey:@"p_max_dh_num"] integerValue];

    _duihuanCountControllerButton.tag = [[dic objectForKey:@"pprice"] integerValue] ;
    _duihuanCountControllerButton.maximumValue = maxValue;
    _duihuanCountControllerButton.value = 1;
    [_duihuanCountControllerButton addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    _delegateClass = [[EMDelegateClass alloc]init];
    _delegateClass.rootView = self.view;
    _delegateClass.delegate = self;
}
- (void)valueChanged:(UIStepper *)Stepper{
    int balance = [self getIntegerValueForKey:CONFIG_KEY_LOCAL_BALANCE];
    int price = Stepper.tag;
    NSLog(@"点击了!%f",Stepper.value);
    if ((Stepper.value * price) < balance) {
        NSString *value = [[NSString alloc]initWithFormat:@"%d",(int)Stepper.value];
        [_duihuanCount setText:value];
    } else {
        if (Stepper.value > 1) {
            
            _duihuanCountControllerButton.maximumValue = Stepper.value - 1;
        }
    }
}
-(void)initBaseLeftItem{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {

    [_duihuanName release];
    [_duihuanPhone release];
    [_duihanAddress release];
    [_duihuanCount release];
    [_duihuanCountControllerButton release];
    [_duihuanCommit release];
    [super dealloc];
}
- (IBAction)postDuihuan:(id)sender {
    [_duihanAddress resignFirstResponder];
    [_duihuanName resignFirstResponder];
    [_duihuanPhone resignFirstResponder];
    NSString *addr = _duihanAddress.text;
    NSString *phone = _duihuanPhone.text;
    NSString *name = _duihuanName.text;
    [self setStringValueForKey:CONFIG_KEY_DUIHUAN_ADDR val:addr];
    [self setStringValueForKey:CONFIG_KEY_DUIHUAN_PHONE val:phone];
    [self setStringValueForKey:CONFIG_KEY_DUIHUAN_NAME val:name];
    [self setStringValueForKey:CONFIG_KEY_DUIHUAN_COUNT val:_duihuanCount.text];
    //申请兑换
    [_delegateClass EMDelegatePostDuiHuanInfo];
}
@end
