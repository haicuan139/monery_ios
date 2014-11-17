//
//  EMMainViewController.m
//  moenycat
//
//  Created by haicuan139 on 14-11-5.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import "EMMainViewController.h"
#import "LocalConfigKey.h"
@interface EMMainViewController ()

@end

@implementation EMMainViewController


-(float)getAppVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"当前版本号,%@",app_Version);
    return [app_Version floatValue];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    float localVersion = [ud floatForKey:CONFIG_KEY_VERSIONCODE];
    if ([self getAppVersion] > localVersion) {
        //如果当前版本大于本地版本
        [self showWellcome];
        //保存版本号
        [ud setFloat:[self getAppVersion] forKey:CONFIG_KEY_VERSIONCODE];
    }
    // Do any additional setup after loading the view.
}
-(void)showWellcome{
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"传播价值";
    page1.desc = @"分享信息获得奖励.转发微信、微博、QQ空间等平台之后，如有10个用户点击，则收获100喵币，此次参与共获益110喵币";
    page1.bgImage = [UIImage imageNamed:@"welcome_bg_1"];
    page1.titleImage = [UIImage imageNamed:@"original"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"推荐招财喵";
    page2.desc = @"在“喵福利”频道点击“推荐招财喵”即可一键生成个人专属推广链接，分享后，朋友们通过这条链接完成的下载注册，自身收获2元，您作为推荐人也可收获2元，多多益善，无上限哦！";
    page2.bgImage = [UIImage imageNamed:@"welcome_bg_2"];
    page2.titleImage = [UIImage imageNamed:@"supportcat"];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"超值兑换";
    page3.desc = @"如果您想兑换其它商品，同样只需按照要求提供相关信息即可，例如虚拟卡券类我们会提供给您电子码，实物类我们会安排快递，确保您不会付出任何成本。";
    page3.bgImage = [UIImage imageNamed:@"welcome_bg_3"];
    page3.titleImage = [UIImage imageNamed:@"femalecodertocat"];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3]];
    
    [intro setDelegate:self];
    [intro showInView:self.view animateDuration:0.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end