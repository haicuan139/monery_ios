//
//  EMADHTML5ViewController.h
//  moenycat
//
//  Created by haicuan139 on 14-9-1.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMBaseViewController.h"
#import "FVCustomAlertView/FVCustomAlertView.h"
#import "EMAppDelegate.h"
#import "TGJSBridge.h"
#import "LocalConfigKey.h"
@interface EMADHTML5ViewController : UIViewController <TGJSBridgeDelegate>{
    int timerCount;
}
@property (retain, nonatomic) UIWebView *webview;
@property (retain, nonatomic) NSDictionary *adInof;
@property (retain, nonatomic) TGJSBridge *jsBridge;
-(void)onRightItemClick;
-(void)postValueToJs:(NSString *)key value:(NSString *)value method:(NSString *)method;
-(void)initWebView;
@end
