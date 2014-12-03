
//
//  EMADHTML5ViewController.m
//  moenycat
//
//  Created by haicuan139 on 14-9-1.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import "EMADHTML5ViewController.h"

@interface EMADHTML5ViewController ()

@end

@implementation EMADHTML5ViewController

-(void)initBaseLeftItem{
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)onRightItemClick{


    NSString *title     = [_adInof objectForKey:@"adTitle"];
    NSString *content   = [_adInof objectForKey:@"adContent"];
    NSString *urlLogo   = [_adInof objectForKey:@"adIcon"];
    NSString *url       = [_adInof objectForKey:@"adUrl"];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *deviceId  = [ud stringForKey:CONFIG_KEY_DEVICEID];
    NSString *adId      = [_adInof objectForKey:@"adId"];
    NSString *paramsUrl    = [[NSString alloc]initWithFormat:@"index.html?p1=%@&p2=%@",deviceId,adId];
    NSMutableString *shareUrl = [[NSMutableString alloc]initWithString:url];
    [shareUrl replaceCharactersInRange:[shareUrl rangeOfString:@"set.html"] withString:paramsUrl];
    EMBaseViewController *eb = [[EMBaseViewController alloc]init];
    [eb openShare:shareUrl title:title content:content urlLogo:urlLogo];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    EMAppDelegate *delegate = (EMAppDelegate *)[[UIApplication sharedApplication] delegate];
    _adInof = delegate.adInfoDicToH5;
    [self setTitle:@"广告详细"];
    _webview.delegate = self;
//    _webview.scalesPageToFit = YES;
    NSString *url = [_adInof objectForKey:@"adUrl"];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [_webview loadRequest:request];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onRightItemClick)];
    [shareItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = shareItem;
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
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if ( navigationType == UIWebViewNavigationTypeLinkClicked ) {
        [_webview loadRequest:request];
        return NO;
    }
    return YES;
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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    [_webview release];
    [_adInof release];
    [super dealloc];
}
@end
