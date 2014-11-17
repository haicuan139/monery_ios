//
//  EMBaseViewController.m
//  moenycat
//
//  Created by haicuan139 on 14-8-25.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import "EMBaseViewController.h"

@interface EMBaseViewController ()

@end

@implementation EMBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(EMMyInfoTitleView *)getMyInfoHeaderView:(CGRect)frame{
    _headerView = [EMMyInfoTitleView getInstance];
    [_headerView.headerIcon.layer setMasksToBounds:YES];
    [_headerView.headerIcon.layer setCornerRadius:5.0];
    [_headerView.headerIcon addTarget:self action:@selector(headerViewClick) forControlEvents:UIControlEventTouchUpInside];
    _headerView.frame = frame;
    _headerView.backgroundColor = [EMColorHex getColorWithHexString:@"#f4f4f4"];
    return _headerView;
}
-(void)headerViewClick{
    [self pushViewControllerWithStorboardName:@"myinfo" sid:@"EMMyInfoTableViewController" hiddenTabBar:YES];
}
-(void)pushViewControllerWithStorboardName:(NSString *)storyboardName sid:(NSString *)id hiddenTabBar:(BOOL)hidden
{
    NSLog(@"调用了PushView");
    UIStoryboard* st = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController *controller = [st instantiateViewControllerWithIdentifier:id];
    controller.hidesBottomBarWhenPushed = hidden;
    [controller retain];
    [self pushViewControllerWithController:controller];
    
}
-(void)pushViewControllerWithController:(UIViewController *)controller
{
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)openShare:(NSString *)url title:(NSString *)title content:(NSString *)content urlLogo:(NSString*)urlLogo;{
    
    //朋友圈
    UMSocialData *data = [UMSocialData defaultData];
    data.extConfig.wechatTimelineData.url = url;
    data.extConfig.wechatTimelineData.shareText = title;
    [data.extConfig.wechatTimelineData.urlResource setResourceType:UMSocialUrlResourceTypeImage url:urlLogo];
    //新浪微博
    data.extConfig.sinaData.urlResource.url = url;
    data.extConfig.sinaData.shareText = title;
    [data.extConfig.sinaData.urlResource setResourceType:UMSocialUrlResourceTypeImage url:urlLogo];
    //腾讯微博
    data.extConfig.tencentData.urlResource.url = url;
    data.extConfig.tencentData.shareText = title;
    [data.extConfig.tencentData.urlResource setResourceType:UMSocialUrlResourceTypeImage url:urlLogo];
    //QQ空间
    data.extConfig.qzoneData.url = url;
    data.extConfig.qzoneData.shareText = title;
    [data.extConfig.qqData.urlResource setResourceType:UMSocialUrlResourceTypeImage url:urlLogo];
    //短信
    data.extConfig.smsData.urlResource.url = url;
    data.extConfig.smsData.shareText = title;
    [data.extConfig.smsData.urlResource setResourceType:UMSocialUrlResourceTypeImage url:urlLogo];
    //微信好友
    data.extConfig.wechatSessionData.url = url;
    data.extConfig.wechatSessionData.shareText = title;
    [data.extConfig.wechatSessionData.urlResource setResourceType:UMSocialUrlResourceTypeImage url:urlLogo];
    //QQ好友
    data.extConfig.qqData.url = url;
    data.extConfig.qqData.shareText = title;
    [data.extConfig.qqData.urlResource setResourceType:UMSocialUrlResourceTypeImage url:urlLogo];
    //邮件
    data.extConfig.emailData.urlResource.url = url;
    data.extConfig.emailData.shareText = title;
    [data.extConfig.emailData.urlResource setResourceType:UMSocialUrlResourceTypeImage url:urlLogo];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"53df75a0fd98c5be20015ccf"
                                      shareText:title//文字
                                     shareImage:[UIImage imageNamed:@"logo.png"] //图片
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToQzone,UMShareToSms,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToEmail,nil]
                                       delegate:self];
}
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        //分享成功.面试次数++
        NSLog(@"分享成功");
        [FVCustomAlertView showDefaultDoneAlertOnView:self.view withTitle:@"分享成功!"];
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [FVCustomAlertView hideAlertFromView:self.view fading:NO];
        });
    }
}

-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData{
    NSLog(@"点击了分享平台");
}
-(UIBarButtonItem *)getLeftItem{
    UIImage *licon = [UIImage imageNamed:@"message.png"];
    UIButton *leftItemButton = [[UIButton alloc]init];
        leftItemButton.showsTouchWhenHighlighted = YES;
    [leftItemButton addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    leftItemButton.frame = CGRectMake(0, 0, 22, 18);
    [leftItemButton setImage:licon forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftItemButton];
    return leftItem;
}
-(void)leftItemClick{
    NSLog(@"左侧点击");
    [self pushViewControllerWithStorboardName:@"duihuan" sid:@"EMDuiHuanTableViewController" hiddenTabBar:YES];
}
-(void)rightItemClick{
    NSLog(@"又侧点击");
    [self pushViewControllerWithStorboardName:@"mingxi" sid:@"EMMingXiViewController" hiddenTabBar:NO];
}
-(BOOL)writeImage:(UIImage*)image toFileAtPath:(NSString*)aPath{
    if ((image == nil) || (aPath == nil) || ([aPath isEqualToString:@""]))
        return NO;
    @try
    {
        NSData *imageData = nil;
        NSString *ext = [aPath pathExtension];
        if ([ext isEqualToString:@"jpg"])
        {
            imageData = UIImageJPEGRepresentation(image, 0.00001);
        }
        else
        {
            // the rest, we write to jpeg
            
            // 0. best, 1. lost. about compress.
            imageData = UIImageJPEGRepresentation(image, 0);
        }
        if ((imageData == nil) || ([imageData length] == 0))
            
            return NO;
        
        [imageData writeToFile:aPath atomically:YES];
        
        return YES;
        
    }
    
    @catch (NSException *e)
    
    {
        
        NSLog(@"create thumbnail exception.");
        
    }
    
    return NO;
}

-(UIBarButtonItem *)getRightItem{
    UIImage *ricon = [UIImage imageNamed:@"daiban.png"];
    UIButton *rightItemButton = [[UIButton alloc]init];
    [rightItemButton addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    rightItemButton.frame = CGRectMake(0, 0, 22, 18);
    [rightItemButton setImage:ricon forState:UIControlStateNormal];
    rightItemButton.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightItemButton];
    return rightItem;

}
-(void)playSmallSoundForPath:(NSString *)path{
    static SystemSoundID shake_sound_male_id = 0;
    if (path) {
        //注册声音到系统
        AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:path],&shake_sound_male_id);
        AudioServicesPlaySystemSound(shake_sound_male_id);
        //        AudioServicesPlaySystemSound(shake_sound_male_id);//如果无法再下面播放，可以尝试在此播放
    }
    
    AudioServicesPlaySystemSound(shake_sound_male_id);   //播放注册的声音，（此句代码，可以在本类中的任意位置调用，不限于本方法中）
    
}
-(void)requestStarted:(ASIHTTPRequest *)request{
    
}
-(void)requestFinished:(ASIHTTPRequest *)request{
    
}
-(void)requestFailed:(ASIHTTPRequest *)request{
    
}
-(void)startWelcomePage{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    double delayInSeconds = 2;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        self.statusBarNotificationLabel.textColor = [UIColor whiteColor];
//        self.statusBarNotificationLabel.backgroundColor = [UIColor colorWithHexString:@"#ad1524"];
//        [self showStatusBarNotification:@"测试!!" forDuration:10];
//    });
    //检测版本更新
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    _userDef = [NSUserDefaults standardUserDefaults];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.tabBarController.tabBar setTintColor:[EMColorHex getColorWithHexString:@"#ad1524"]];
    [self initBaseLeftItem];
    [self initBaseRightItem];

} 
-(void)onItemClick:(NSUInteger)itemIndex{
    
}
-(void)onItemClickNSIndexPath:(NSIndexPath *)indexPath{
    
}
-(void)initBaseLeftItem{
    UIBarButtonItem* left = [self getLeftItem];
    self.navigationItem.leftBarButtonItem = left;
}
-(void)initBaseRightItem{
    UIBarButtonItem* right = [self getRightItem];
    self.navigationItem.rightBarButtonItem = right;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//设置本地存住方法
-(void)setBoolValueForKey:(NSString *)key val:(BOOL)value{
    [_userDef setBool:value forKey:key];
}
-(void)setStringValueForKey:(NSString *)key val:(NSString *)value{
    [_userDef setObject:value forKey:key];
}
-(void)setIntegerValueForKey:(NSString *)key val:(NSInteger)value{
    [_userDef setInteger:value forKey:key];
}
-(void)setFloatValueForKey:(NSString *)key val:(float)value{
    [_userDef setFloat:value forKey:key];
}

-(BOOL)getBoolValueForKey:(NSString *)key{
    return [_userDef boolForKey:key];
}
-(NSString *)getStringValueForKey:(NSString *)key{
    return     [_userDef objectForKey:key];
}
-(NSInteger)getIntegerValueForKey:(NSString *)key{
    return [_userDef integerForKey:key];
}
-(float)getFloatForKey:(NSString *)key{
    return [_userDef floatForKey:key];
}

-(void)dealloc{
    [super dealloc];
    [_userDef release];
    [_headerView release];
    [_baseAlertView release];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark - 确定和取消的对话框
-(void)showBaseDialog:(NSString *)message{
    _baseAlertView = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [_baseAlertView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"dialog click button at index:%d",buttonIndex);
}
@end
