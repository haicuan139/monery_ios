//
//  EMAboutViewController.h
//  moenycat
//
//  Created by haicuan139 on 14-9-7.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FVCustomAlertView/FVCustomAlertView.h"
#import "WebViewJavascriptBridge/WebViewJavascriptBridge.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "EMAppDelegate.h"
#import "EMBaseViewController.h"
@interface EMAboutViewController :UIViewController  <UIWebViewDelegate>
@property (strong, nonatomic) WebViewJavascriptBridge *javascriptBridge;
@property (retain, nonatomic) IBOutlet UIWebView *_webView;

@end
