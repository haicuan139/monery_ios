
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
@synthesize jsBridge = _jsBridge;
@synthesize webview = _webView;
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
    if ([shareUrl containsString:@"set.html"]) {
        [shareUrl replaceCharactersInRange:[shareUrl rangeOfString:@"set.html"] withString:paramsUrl];
        EMBaseViewController *eb = [[EMBaseViewController alloc]init];
        [eb openShare:shareUrl title:title content:content urlLogo:urlLogo];
    }
}

-(void)initWebView{
    //重新设定view大小
    self.webview = [[UIWebView alloc]init];
    self.webview.backgroundColor=[UIColor clearColor];
    for (UIView *_aView in [self.webview subviews])
    {
        if ([_aView isKindOfClass:[UIScrollView class]])
        {
            [(UIScrollView *)_aView setShowsVerticalScrollIndicator:NO]; //右侧的滚动条
            [(UIScrollView *)_aView setShowsHorizontalScrollIndicator:NO]; //右侧的滚动条
            for (UIView *_inScrollview in _aView.subviews)
            {
                if ([_inScrollview isKindOfClass:[UIImageView class]])
                {
                    _inScrollview.hidden = YES;  //上下滚动出边界时的黑色的图片
                }
            }
        }
    }
    self.webview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 63);
    [self.view addSubview:self.webview];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"广告详细"];
    [self initWebView];
    //初始化JS接口
    self.jsBridge = [TGJSBridge jsBridgeWithDelegate:self];
    self.webview.delegate = self.jsBridge;
    EMAppDelegate *delegate = (EMAppDelegate *)[[UIApplication sharedApplication] delegate];
    _adInof = delegate.adInfoDicToH5;
    NSString *url = [_adInof objectForKey:@"adUrl"];
    NSMutableString *ios_url = [[NSMutableString alloc]initWithString:url];
    if ([ios_url containsString:@"set.html"]) {
        NSString *ios = @"set_ios.html";
        [ios_url replaceCharactersInRange:[ios_url rangeOfString:@"set.html"] withString:ios];
    }
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:ios_url]];
    [self.webview loadRequest:request];
    //获取设备ID
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *deviceid = [ud stringForKey:CONFIG_KEY_DEVICEID];
    NSString *adId = [_adInof objectForKey:@"adId"];
    [self postValueToJs:@"deviceid" value:deviceid method:@"JsGetDeviceId"];//传入设备ID
    [self postValueToJs:@"adid" value:adId method:@"JsGetAdId"];//传入广告ID
    //添加分享按钮
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onRightItemClick)];
    [shareItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = shareItem;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    //网页加载失败

    [FVCustomAlertView hideAlertFromView:self.view fading:NO];
    [FVCustomAlertView showDefaultErrorAlertOnView:self.view withTitle:@"加载超时!"];
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //网页加载完成
    NSLog(@"加载完成");
    [FVCustomAlertView hideAlertFromView:self.view fading:YES];

}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if ( navigationType == UIWebViewNavigationTypeLinkClicked ) {
        [self.webview loadRequest:request];
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

    [_adInof release];
    [self.webview release];
    [_jsBridge release];
    [super dealloc];
}

- (void)jsBridge:(TGJSBridge *)bridge didReceivedNotificationName:(NSString *)name userInfo:(NSDictionary *)userInfo fromWebView:(UIWebView *)webview
{
    NSString *val = [userInfo objectForKey:@"key"];
    if ([val containsString:@"uploadImage"]) {
        //上传图片
    }
    
}
-(void)postValueToJs:(NSString *)key value:(NSString *)value method:(NSString *)method{
        [self.jsBridge postNotificationName:method userInfo:[NSDictionary dictionaryWithObjectsAndKeys:value,key, nil] toWebView:self.webview];
}
@end
