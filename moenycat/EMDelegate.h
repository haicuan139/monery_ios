//
//  EMDelegate.h
//  moenycat
//
//  Created by haicuan139 on 14-11-5.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalConfigKey.h"
#import "UrlPostInterface.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "FVCustomAlertView/FVCustomAlertView.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "EMAppDelegate.h"
@protocol EMDelegate <NSObject>
@optional//可以选择的方法名
-(void)onVersionChange:(NSString *) serverVersionCode content:(NSString *)content title:(NSString *)title dowUrl:(NSString *)downloadUrl;//当服务器版本改变时
-(void)onMyInfoInitDone:(NSDictionary *)myInfo;//个人信息初始化完成
-(void)onBalanceChangeForServer:(NSString *)balance; //获取余额时
-(void)onInitAdListForServer:(NSArray *)adList;//获取广告列表时
-(void)onInitAdLoopListForServer:(NSArray *)adList;//获取焦点图广告列表时
-(void)onAdLisrLoadError;
-(void)onInitTaskListForServer:(NSArray *)taskList;//获取任务列表
-(void)onInitTaskLoopListForServer:(NSArray *)loopList; //任务列表焦点图
-(void)onMyInfoUpdateDoneToServer;//提交用户信息完成
-(void)onInitMinXiListLoadDone:(NSArray *)mingxiList; //账户明细
-(void)onInitMyAdListHistoryForServer:(NSArray *)adList; //我点击过的广告
-(void)onInitTixianListForServer:(NSArray *)tixianList; //提现列表
-(void)onTixianCommitDone;//提现申请完成
-(void)onInitDuiHuanListForServer:(NSArray *)duihuanList; //兑换列表
-(void)onPostDuihuanInfoDone;//提交兑换信息完成
-(void)onSmsCodeSendDone:(NSString *)code; //发送短信验证码
-(void)onPostBindInfoDone;//绑定完成
-(void)onInitDuiHuanHistoryForServer:(NSArray *)historyArray;//兑换记录
-(void)onInitMessageList:(NSArray *)messageList; //消息列表加载完成
-(void)onPOstFeedBackDone; //提交反馈完成
-(void)onRegDeviceDone; //注册设备完成
@end
@interface EMDelegateClass : NSObject
@property (nonatomic , retain) id<EMDelegate> delegate;
@property (nonatomic , retain) NSUserDefaults *ud;
@property (nonatomic , retain) UIView *rootView;
-(NSString *)replaceUnicode:(NSString *)unicodeStr;
-(void)EMDelegateUpdateVersion;
-(void)EMDelegateInitMyInfo;
-(void)EMDelegateRegDevices;
-(NSURL *)requestUrlForKey:(NSString *)key;
-(ASIFormDataRequest *)resquestInstanceForUrl:(NSURL *)url;
-(NSDictionary *)initMyInfoForLocal;
-(void)EMDelegateInitBalanceForServer;
-(void)EMDelegateInitAdlist;
-(void)EMDelegateInitAdLooplist;
-(void)EMDelegateInitTaskList;
-(void)EMDelegateInitTaskLoop;
-(void)EMDelegatePostMyInfo;
-(void)EMDelegateInitMingXiList;
-(void)EMDelegateInitAdlistHistory;
-(void)EMDelegateInitTixianList;
-(void)EMDelegateTixianCommit;
-(void)updateBalance;
-(void)EMDelegateInitDuiHuanList;
-(void)EMDelegatePostDuiHuanInfo;
-(void)EMDelegateSendSmsCode;
-(void)EMDelegatePostBindInfo;
-(void)updateMyInfo;
-(void)EMDelegateInitDuihuanHistory;
-(void)EMDelegateInitMessageList;
-(void)EMDelegatePostFeedBack:(NSString *)text;
@end
