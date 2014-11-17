//
//  EMAppDelegate.m
//  moenycat
//
//  Created by haicuan139 on 14-8-25.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import "EMAppDelegate.h"

@implementation EMAppDelegate
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [UMSocialData setAppKey:@"53df75a0fd98c5be20015ccf"];
    [UMSocialQQHandler setSupportWebView:YES];
//    [UMSocialWechatHandler setWXAppId:@"wxcec4566d135405e6" url:@"http://www.baidu.com.com"];
    [UMSocialWechatHandler setWXAppId:@"wxcec4566d135405e6" appSecret:@"61a033e26702fbe2dcd70faa24e" url:@"http://115.28.136.194:8086/zcm/ex/zcm/down.html"];

    [UMSocialQQHandler setQQWithAppId:@"1101962112" appKey:@"RY1S5XEVSVnjx3B7" url:@"http://115.28.136.194:8086/zcm/ex/zcm/down.html"];
    // Override point for customization after application launch.
    //注册推送

    if([[[UIDevice currentDevice]systemVersion]floatValue] >=8.0){
        [application registerUserNotificationSettings:[UIUserNotificationSettings
                                                
        settingsForTypes:(UIUserNotificationTypeSound|UIUserNotificationTypeAlert|UIUserNotificationTypeBadge)

        categories:nil]];
        
        [application registerForRemoteNotifications];
    } else {
        [application registerForRemoteNotificationTypes:
         UIRemoteNotificationTypeBadge |
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeSound];
    }
    
    return YES;
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"接收到PUSH");
    NSLog(@"%@",userInfo);
    NSDictionary *dic = [userInfo objectForKey:@"aps"];
    NSString *msg = [dic objectForKey:@"alert"];
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    notification.applicationIconBadgeNumber = 1;
    notification.soundName= UILocalNotificationDefaultSoundName;
    notification.alertBody=msg;
    notification.alertAction = @"查看";
    notification.userInfo = userInfo;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    [notification release];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 1;

}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    AudioServicesPlaySystemSound(1007);
    NSDictionary *dic = [notification userInfo];
    NSString *jsonString = @"";
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                       options:NSJSONWritingPrettyPrinted
                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    SBJsonParser    *parser = [[SBJsonParser alloc] init];
    NSDictionary    *rootDic = [parser objectWithString:jsonString error:&error];
    NSString *msg = [[rootDic objectForKey:@"aps"] objectForKey:@"alert"];
    //如果在前台显示自定义的通知VIEW
    [MPNotificationView notifyWithText:@"消息中心:"
                                detail:msg
                                 image:[UIImage imageNamed:@"logo.png"]
                           andDuration:5.0];
}
#pragma mark - 注册PUSH成功
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"deviceToken: %@", deviceToken);
}
#pragma mark - 注册PUSH失败
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"注册推送服务时，发生以下错误： %@",error);
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
