//
//  EMMainViewController.h
//  moenycat
//
//  Created by haicuan139 on 14-11-5.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAIntroView/EAIntroView.h"
#import "EDColor.h"
@interface EMMainViewController : UITabBarController <EAIntroDelegate>
-(void)showWellcome;
-(float)getAppVersion;
@end
