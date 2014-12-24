//
//  EMAdInfoViewController.m
//  moenycat
//
//  Created by haicuan139 on 14-12-23.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import "EMAdInfoViewController.h"

@interface EMAdInfoViewController ()

@end

@implementation EMAdInfoViewController
@synthesize jsBridge = _jsBridge;
@synthesize webview = _webview;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"商品详细"];


    self.webview = [[UIWebView alloc]init];
    self.webview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 63);
    [self.view addSubview:self.webview];
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
    self.jsBridge = [TGJSBridge jsBridgeWithDelegate:self];
    self.webview.delegate = self.jsBridge;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://115.28.136.194:8086/zcm/ex/zcm/duihuan_ios.html"]];
        [self.webview loadRequest:request];
    EMAppDelegate *delegate = (EMAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *prodDic = delegate.duihuanDic;
    NSString *data = [self DataTOjsonString:prodDic];//商品数据JSON
    [self.jsBridge postNotificationName:@"JsGetDuihuan" userInfo:[NSDictionary dictionaryWithObjectsAndKeys:data,@"data", nil] toWebView:self.webview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

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
        [_webview loadRequest:request];
        return NO;
    }
    return YES;
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    //网页开始加载
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中.."];
}
- (void)jsBridge:(TGJSBridge *)bridge didReceivedNotificationName:(NSString *)name userInfo:(NSDictionary *)userInfo fromWebView:(UIWebView *)webview
{
    NSLog(@"1111");
    NSString *val = [userInfo objectForKey:@"key"];
    if ([val containsString:@"duihuan"]) {
        //打开兑换
        NSLog(@"兑换");
//        pushViewControllerWithStorboardName:@"duihuan_input" sid:@"duihuan_input" hiddenTabBar:YES];
        UIStoryboard* st = [UIStoryboard storyboardWithName:@"duihuan_input" bundle:nil];
        UIViewController *controller = [st instantiateViewControllerWithIdentifier:@"duihuan_input"];
        controller.hidesBottomBarWhenPushed = NO;
        [controller retain];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}
-(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                     error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
@end
