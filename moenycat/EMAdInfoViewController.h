//
//  EMAdInfoViewController.h
//  moenycat
//
//  Created by haicuan139 on 14-12-23.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TGJSBridge.h"
#import "FVCustomAlertView.h"
#import "EMAppDelegate.h"
#import "SBJson.h"
@interface EMAdInfoViewController : UIViewController <TGJSBridgeDelegate>
@property (nonatomic,retain) UIWebView *webview;
@property (retain, nonatomic) TGJSBridge *jsBridge;
-(NSString*)DataTOjsonString:(id)object;
@end
