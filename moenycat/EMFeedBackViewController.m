//
//  EMFeedBackViewController.m
//  moenycat
//
//  Created by haicuan139 on 14-11-13.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import "EMFeedBackViewController.h"

@interface EMFeedBackViewController ()

@end

@implementation EMFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_feedBackCommit setBackgroundColor:[UIColor colorWithHexString:@"#ad1524"]];
    [_feedBackCommit.layer setMasksToBounds:YES];
    [_feedBackCommit.layer setCornerRadius:4.0];
    [_feedBackContentField becomeFirstResponder];
    _delegateClass = [[EMDelegateClass alloc]init];
    _delegateClass.delegate = self;
    _delegateClass.rootView = self.view;
}

-(void)initBaseLeftItem{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [_feedBackContentField release];
    [_feedBackCommit release];
    [_delegateClass release];
    [super dealloc];
}
- (IBAction)postFeedBackText:(id)sender {
    [_feedBackContentField resignFirstResponder];
    NSString *text = _feedBackContentField.text;
    if (text.length == 0) {
        [FVCustomAlertView showDefaultWarningAlertOnView:self.view withTitle:@"没有信息!"];
    } else {
        [_delegateClass EMDelegatePostFeedBack:text];
    }
}
-(void)onPOstFeedBackDone{
    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.navigationController popViewControllerAnimated:YES];
    });
    
}
@end
