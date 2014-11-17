//
//  EMAboutViewController.m
//  moenycat
//
//  Created by haicuan139 on 14-9-7.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import "EMAboutViewController.h"
@interface EMAboutViewController ()

@end

@implementation EMAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)initBaseLeftItem{
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *type = [self getStringValueForKey:CONFIG_KEY_WEB_TYPE];
    NSString *url = @"";
            [self setTitle:type];
    if ([type isEqualToString:@"商务合作"]) {
        url = @"http://115.28.136.194:8086/zcm/ex/zcm/bussnise.html";
    } else if ([type isEqualToString:@"版本信息"]){
        url = @"http://115.28.136.194:8086/zcm/ex/zcm/update.html";
    } else if ([type isEqualToString:@"关于我们"]){
        url = @"http://115.28.136.194:8086/zcm/ex/zcm/about.html";
    }
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [__webView loadRequest:request ];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    //网页加载失败
    NSLog(@"网页加载失败");
    [FVCustomAlertView hideAlertFromView:self.view fading:NO];
    [FVCustomAlertView showDefaultErrorAlertOnView:self.view withTitle:@"加载超时!"];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //网页加载完成
    NSLog(@"网页加载完成");
    
    [FVCustomAlertView hideAlertFromView:self.view fading:YES];
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    //网页开始加载
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中.."];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [__webView release];
    [super dealloc];
}
@end
