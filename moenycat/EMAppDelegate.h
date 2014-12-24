//
//  EMAppDelegate.h
//  moenycat
//
//  Created by haicuan139 on 14-8-25.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import <AudioToolbox/AudioToolbox.h> 
#import "MPNotificationView.h"
#import "SBJson/SBJson.h"
#import "WXApi.h"
#import "FVCustomAlertView.h"
@interface EMAppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate , UMSocialUIDelegate>

@property (strong, nonatomic) UIWindow      *window;
@property (strong, nonatomic) NSDictionary  *adInfoDicToH5;
@property (strong, nonatomic) NSString *currentEditTextString;//编辑时的默认字符串
@property (strong, nonatomic) NSString *editViewType;
@property (strong, nonatomic) NSString *editViewDefaultValue;
@property (strong, nonatomic) NSString *tixianId;
@property (strong,  nonatomic) NSDictionary *duihuanDic; //需要兑换的商品
-(void)openShare:(NSString *)url title:(NSString *)title content:(NSString *)content urlLogo:(NSString*)urlLogo;

@end
