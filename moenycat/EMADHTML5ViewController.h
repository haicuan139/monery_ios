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
@interface EMADHTML5ViewController : UIViewController <UIWebViewDelegate>{
    int timerCount;
}
@property (retain, nonatomic) IBOutlet UIWebView *webview;
@property (retain, nonatomic) NSDictionary *adInof;
-(void)onRightItemClick;

@end
