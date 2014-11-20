//
//  EMBaseViewController.h
//  moenycat
//
//  Created by haicuan139 on 14-8-25.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMMyInfoTitleView.h"
#import "CycleScrollView.h"
#import "EMMyInfoTitleView.h"
#import "EMColorHex.h"
#import "EMADInfoCell.h"
#import "UMSocial.h"
#import "WXApi.h"
#import "Util.h"
#import "LocalConfigKey.h"
#import "UrlPostInterface.h"
#import <AudioToolbox/AudioToolbox.h>
#import "EAIntroView.h"
#import "EMWelcomeViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "EMDelegate.h"
#import "UIAlertView+Block.h"
#import "FVCustomAlertView/FVCustomAlertView.h"
#import "EDColor.h"
@interface EMBaseViewController : UIViewController <WXApiDelegate , UMSocialUIDelegate,UIAlertViewDelegate,EAIntroDelegate,ASIHTTPRequestDelegate>
@property (nonatomic , retain) NSUserDefaults* userDef;
@property (nonatomic , retain) EMMyInfoTitleView* headerView;
@property (nonatomic , retain) UIAlertView* baseAlertView;
-(UIBarButtonItem *)getLeftItem;
-(UIBarButtonItem *)getRightItem;
-(void)setBoolValueForKey:(NSString *)key val:(BOOL)value;
-(void)setStringValueForKey:(NSString *)key val:(NSString *)value;
-(void)setIntegerValueForKey:(NSString *)key val:(NSInteger)value;
-(void)setFloatValueForKey:(NSString *)key val:(float)value;
-(BOOL)getBoolValueForKey:(NSString *)key;
-(NSString *)getStringValueForKey:(NSString *)key;
-(NSInteger)getIntegerValueForKey:(NSString *)key;
-(float)getFloatForKey:(NSString *)key;
-(EMMyInfoTitleView *)getMyInfoHeaderView:(CGRect)frame;
-(void)pushViewControllerWithStorboardName:(NSString *)storyboardName sid:
(NSString *)id hiddenTabBar:(BOOL)hidden;
-(void)pushViewControllerWithController:(UIViewController *)controller;
-(void)openShare:(NSString *)url title:(NSString *)title content:(NSString *)content urlLogo:(NSString*)urlLogo;
-(void)playSmallSoundForPath:(NSString *)path;
-(void)initBaseLeftItem;
-(void)initBaseRightItem;
-(void)onItemClick:(NSUInteger)itemIndex;
-(void)onItemClickNSIndexPath:(NSIndexPath *)indexPath;
-(void)leftItemClick;
-(void)rightItemClick;
-(void)showBaseDialog:(NSString *)message;//只有确定取消的Dialog
-(void)headerViewClick;
-(BOOL)writeImage:(UIImage*)image toFileAtPath:(NSString*)aPath;//保存图片到本地

@end
