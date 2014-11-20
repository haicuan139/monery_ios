//
//  EMDelegate.m
//  moenycat
//
//  Created by haicuan139 on 14-11-5.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import "EMDelegate.h"
@implementation EMDelegateClass : NSObject
#pragma mark - 检测版本号
-(void)EMDelegateUpdateVersion{
    NSURL *url = [self requestUrlForKey:SERVER_URL_UPDATE];
    __block ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :url];
    [request setCompletionBlock :^{
        //响应成功
        NSString *responseString = [request responseString ]; // 对于
                NSLog(@"response:%@",responseString);
        NSError         *error = nil;
        SBJsonParser    *parser = [[SBJsonParser alloc] init];
        NSDictionary    *rootDic = [parser objectWithString:responseString error:&error];
        NSString *code = [rootDic objectForKey:@"code"];
        if (![@"00" isEqualToString:code]) {
            return;
        }
        NSDictionary    *val = [rootDic objectForKey:@"val"];
        NSString        *versionCode = [val objectForKey:@"appVersion"];
        NSString        *versionContent = [val objectForKey:@"appContent"];
        NSString        *versionTitle = [val objectForKey:@"appTitle"];
        if ([_delegate respondsToSelector:@selector(onVersionChange:content:title:dowUrl:)]) {

            [_delegate onVersionChange:versionCode content:versionContent title:versionTitle dowUrl:@""];
            
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request error ];
        NSLog ( @"error:%@" ,[error userInfo ]);
    }];
    [request setStartedBlock:^{
        NSLog(@"请求开始...");
    }];
    [request startAsynchronous];

}
-(void)dealloc{
    [super dealloc];
//    [_ud release];
//    [_rootView release];
//    [_delegate release];
}
- (id) init
{
    if(self = [super init])
    {
        //为子类增加属性进行初始化
        if (!_ud) {
            _ud = [NSUserDefaults standardUserDefaults];
        }
    }
    return self; 
}
#pragma mark - 刷新个人信息
-(void)updateMyInfo{
    NSLog(@"加载网络信息");
    ASIFormDataRequest *request = [self resquestInstanceForUrl:[self requestUrlForKey:SERVER_URL_USERINFO]];
    [request setCompletionBlock :^{
        //响应成功
        NSString *responseString    = [request responseString];
        NSLog(@"response:%@",responseString);
        
        NSError         *error      = nil;
        SBJsonParser    *parser     = [[SBJsonParser alloc] init];
        NSDictionary    *rootDic    = [parser objectWithString:responseString error:&error];
        NSString *code = [rootDic objectForKey:@"code"];
        if (![@"00" isEqualToString:code]) {
            return;
        }
        NSDictionary    *val        = [rootDic objectForKey:@"val"];
        
        NSLog(@"info:%@",val);
        //保存！本地数据
        [_ud setObject:[val objectForKey:CONFIG_KEY_INFO_NICKNAME] forKey:CONFIG_KEY_INFO_NICKNAME];
        [_ud setObject:[val objectForKey:CONFIG_KEY_INFO_PHONE] forKey:CONFIG_KEY_INFO_PHONE];
        [_ud setObject:[val objectForKey:CONFIG_KEY_INFO_HEADER_URL] forKey:CONFIG_KEY_INFO_HEADER_URL];
        [_ud setObject:[val objectForKey:CONFIG_KEY_INFO_ADDRESS] forKey:CONFIG_KEY_INFO_ADDRESS];
        NSInteger age = [[val objectForKey:CONFIG_KEY_INFO_AGE] integerValue];
        if (age == 0) {
            age = 19;
        }
        
        NSString *ageStr  =  [[NSString alloc]initWithFormat:@"%ld",(long)age];
        [_ud setObject:ageStr forKey:CONFIG_KEY_INFO_AGE];
        [_ud setObject:[val objectForKey:CONFIG_KEY_INFO_RECOMMEND_CODE] forKey:CONFIG_KEY_INFO_RECOMMEND_CODE];
        NSString *genderStr = [val objectForKey:CONFIG_KEY_INFO_GENDER];
        if (genderStr.length == 0) {
            genderStr = @"男";
        }
        [_ud setObject:genderStr forKey:CONFIG_KEY_INFO_GENDER];
        if (_delegate) {            
            if ([_delegate respondsToSelector:@selector(onMyInfoInitDone:)]) {
                [_delegate onMyInfoInitDone:val];
            }
            [_ud setBool:YES forKey:CONFIG_KEY_INIMYINFO];
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request error ];
        NSLog ( @"error:%@" ,[error userInfo ]);
    }];
    [request setStartedBlock:^{
        NSLog(@"请求开始...");
    }];
    [request startAsynchronous];
}
#pragma mark - 初始化个人信息
-(void)EMDelegateInitMyInfo{

    if ([_ud boolForKey:CONFIG_KEY_INIMYINFO]) {
        //如果本地有个人信息
        //读取本地字典文件
        NSDictionary *dic = [self initMyInfoForLocal];
        //发送给代理
        if ([_delegate respondsToSelector:@selector(onMyInfoInitDone:)]) {
            [_delegate onMyInfoInitDone:dic];
            NSLog(@"加载本地信息");
        }
        return;
    }
    [self updateMyInfo];
}
-(NSURL *)requestUrlForKey:(NSString *)key{
    NSURL *url = [ NSURL URLWithString :[HTTP_BASE_URL stringByAppendingString:key]];
    return url;
}

-(ASIFormDataRequest *)resquestInstanceForUrl:(NSURL *)url{
    __block ASIFormDataRequest *request = [ ASIFormDataRequest requestWithURL :url];
    //默认传入一个设备ID
    NSString *devicesid = [_ud stringForKey:CONFIG_KEY_DEVICEID];
    NSLog(@"提交的设备ID:%@",devicesid);
    [request setPostValue:devicesid forKey:URL_PARAMS_DEVICEID];
    return request;
}
#pragma mark - 注册设备
-(void)EMDelegateRegDevices{

    ASIFormDataRequest *request = [self resquestInstanceForUrl:[self requestUrlForKey:SERVER_URL_REG]];
    [request setCompletionBlock :^{
        //响应成功
        NSString *responseString = [request responseString ]; // 对于
        NSError         *error = nil;
        SBJsonParser    *parser = [[SBJsonParser alloc] init];
        NSDictionary    *rootDic = [parser objectWithString:responseString error:&error];
        NSDictionary    *val = [rootDic objectForKey:@"val"];
        NSLog(@"注册设备ID%@",val);
        //保存注册标识
        if ([_delegate respondsToSelector:@selector(onRegDeviceDone)]) {
            [_delegate onRegDeviceDone];
        }
        [_ud setBool:YES forKey:CONFIG_KEY_FIRST_REG];
        [_ud setBool:YES forKey:CONFIG_KEY_REG_DEVICE];
        
    }];
    [request setFailedBlock:^{
        NSError *error = [request error ];
        NSLog ( @"error:%@" ,[error userInfo ]);
    }];
    [request setStartedBlock:^{
        NSLog(@"请求开始...");
    }];
    [request startAsynchronous];
}
-(NSString *)replaceUnicode:(NSString *)unicodeStr {
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    
    //NSLog(@"Output = %@", returnStr);
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}
#pragma mark - 更新余额
-(void)updateBalance{
    ASIFormDataRequest *request = [self resquestInstanceForUrl:[self requestUrlForKey:SERVER_URL_GETBALANCE]];
    [request setCompletionBlock :^{
        //响应成功
        NSString *responseString = [request responseString ]; // 对于
        NSError         *error = nil;
        SBJsonParser    *parser = [[SBJsonParser alloc] init];
        NSDictionary    *rootDic = [parser objectWithString:responseString error:&error];
        NSString * balance  = [rootDic objectForKey:@"val"];
        [_ud setObject:balance forKey:CONFIG_KEY_LOCAL_BALANCE];
        NSLog(@"balance:%@",balance);
        if (_delegate) {
            if ([_delegate respondsToSelector:@selector(onBalanceChangeForServer:)]) {
                [_delegate onBalanceChangeForServer:balance];
            }
            [_ud setBool:YES forKey:CONFIG_KEY_BALANCE_FLG];
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request error ];
        NSLog ( @"error:%@" ,[error userInfo ]);
    }];
    [request setStartedBlock:^{
        NSLog(@"请求开始...");
    }];
    [request startAsynchronous];

}
#pragma mark - 初始化余额
-(void)EMDelegateInitBalanceForServer{
    
    if ([_ud boolForKey:CONFIG_KEY_BALANCE_FLG]) {

        NSString *balance = [_ud stringForKey:CONFIG_KEY_LOCAL_BALANCE];
        
        if ([_delegate respondsToSelector:@selector(onBalanceChangeForServer:)]) {
            [_delegate onBalanceChangeForServer:balance];
        }
        return;
    }
    [self updateBalance];
}
#pragma mark - 加载广告焦点图列表
-(void)EMDelegateInitAdLooplist{
    //获得列表广告
    ASIFormDataRequest *request = [self resquestInstanceForUrl:[self requestUrlForKey:SERVER_URL_LOOPLIST]];
    [request setPostValue:@"0" forKey:@"type"];
    [request setCompletionBlock :^{
        //响应成功
        NSString *responseString = [request responseString ]; // 对于
        NSError         *error = nil;
        SBJsonParser    *parser = [[SBJsonParser alloc] init];
        NSDictionary    *rootDic = [parser objectWithString:responseString error:&error];
        NSString *code = [rootDic objectForKey:@"code"];
        if (![@"00" isEqualToString:code]) {
            return;
        }
        NSArray *val = [rootDic objectForKey:@"rows"];
        if (val && [@"00" isEqualToString:code]) {
            if ([_delegate respondsToSelector:@selector(onInitAdLoopListForServer:)]) {
                [_delegate onInitAdLoopListForServer:val];
            }
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request error ];
        NSLog ( @"error:%@" ,[error userInfo ]);
    }];
    [request setStartedBlock:^{
        NSLog(@"请求开始...");
    }];
    [request startAsynchronous];
}
#pragma mark - 加载广告列表
-(void)EMDelegateInitAdlist{

    //获得列表广告
    ASIFormDataRequest *request = [self resquestInstanceForUrl:[self requestUrlForKey:SERVER_URL_GETADLIST]];
    [request setPostValue:@"0" forKey:@"type"];
    [request setCompletionBlock :^{
        //响应成功
        NSString *responseString = [request responseString ]; // 对于
        NSError         *error = nil;
        SBJsonParser    *parser = [[SBJsonParser alloc] init];
        NSDictionary    *rootDic = [parser objectWithString:responseString error:&error];
        NSArray *val = [rootDic objectForKey:@"rows"];
        NSString *code = [rootDic objectForKey:@"code"];

        if ([@"00" isEqualToString:code]) {
            if (_rootView) {
                [FVCustomAlertView hideAlertFromView:_rootView fading:YES];
            }
            if ([_delegate respondsToSelector:@selector(onInitAdListForServer:)]) {
                [_delegate onInitAdListForServer:val];
            }
        } else {
            if (_rootView) {
                [FVCustomAlertView hideAlertFromView:_rootView fading:NO];
                [FVCustomAlertView showDefaultErrorAlertOnView:_rootView withTitle:@"加载超时!"];
            }
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request error ];
        NSLog ( @"error:%@" ,[error userInfo ]);
        if (_rootView) {
            [FVCustomAlertView hideAlertFromView:_rootView fading:NO];
            [FVCustomAlertView showDefaultErrorAlertOnView:_rootView withTitle:@"加载超时!"];
        }
        if ([_delegate respondsToSelector:@selector(onAdLisrLoadError)]) {
            [_delegate onAdLisrLoadError];
        }
        
    }];
    [request setStartedBlock:^{
        NSLog(@"请求开始...");
        if (_rootView) {

            [FVCustomAlertView showDefaultLoadingAlertOnView:_rootView withTitle:@"加载中.."];
        }
    }];
    [request startAsynchronous];
    
    
}

#pragma mark - 加载任务列表
-(void)EMDelegateInitTaskList{
    ASIFormDataRequest *request = [self resquestInstanceForUrl:[self requestUrlForKey:SERVER_URL_GETADLIST]];
    [request setPostValue:@"1" forKey:@"type"];
    [request setCompletionBlock :^{
        //响应成功
        NSString *responseString = [request responseString ]; // 对于
        NSError         *error = nil;
        SBJsonParser    *parser = [[SBJsonParser alloc] init];
        NSDictionary    *rootDic = [parser objectWithString:responseString error:&error];
        NSString *code = [rootDic objectForKey:@"code"];
        if (![@"00" isEqualToString:code]) {
            return;
        }
        NSArray *val = [rootDic objectForKey:@"rows"];
        if (!val) {
            NSLog(@"EMDelegateInitTaskList 异常");
        }
        if ([_delegate respondsToSelector:@selector(onInitTaskListForServer:)]) {
            [_delegate onInitTaskListForServer:val];
        }
        if (_rootView) {
            [FVCustomAlertView hideAlertFromView:_rootView fading:YES];
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request error ];
        NSLog ( @"error:%@" ,[error userInfo ]);
        if (_rootView) {
            [FVCustomAlertView hideAlertFromView:_rootView fading:NO];
            [FVCustomAlertView showDefaultErrorAlertOnView:_rootView withTitle:@"加载超时!"];
        }
        if ([_delegate respondsToSelector:@selector(onAdLisrLoadError)]) {
            [_delegate onAdLisrLoadError];
        }
        
    }];
    [request setStartedBlock:^{
        NSLog(@"请求开始...");
        if (_rootView) {
            
            [FVCustomAlertView showDefaultLoadingAlertOnView:_rootView withTitle:@"加载中.."];
        }
    }];
    [request startAsynchronous];
}

#pragma mark - 任务列表焦点图
-(void)EMDelegateInitTaskLoop{
    ASIFormDataRequest *request = [self resquestInstanceForUrl:[self requestUrlForKey:SERVER_URL_LOOPLIST]];
    [request setPostValue:@"1" forKey:@"type"];
    [request setCompletionBlock :^{
        //响应成功
        NSString *responseString = [request responseString ]; // 对于
        NSError         *error = nil;
        SBJsonParser    *parser = [[SBJsonParser alloc] init];
        NSDictionary    *rootDic = [parser objectWithString:responseString error:&error];
        NSString *code = [rootDic objectForKey:@"code"];
        if (![@"00" isEqualToString:code]) {
            return;
        }
        NSArray *val = [rootDic objectForKey:@"rows"];
        if (!val) {
            NSLog(@"EMDelegateInitTaskLoop 异常");
        }
        if ([_delegate respondsToSelector:@selector(onInitTaskLoopListForServer:)]) {
            [_delegate onInitTaskLoopListForServer:val];
        }
        
    }];
    [request setFailedBlock:^{
        NSError *error = [request error ];
        NSLog ( @"error:%@" ,[error userInfo ]);
        
        
    }];
    [request setStartedBlock:^{
        NSLog(@"请求开始...");
        
    }];
    [request startAsynchronous];
}
#pragma mark - 加载本地个人信息
-(NSDictionary *)initMyInfoForLocal{
        //加载本地个人信息的配置
        //更改为数据库或者其他模式 --debugging

        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:7];
        [dic setObject:[_ud stringForKey:CONFIG_KEY_INFO_PHONE] forKey:CONFIG_KEY_INFO_PHONE];
        [dic setObject:[_ud stringForKey:CONFIG_KEY_INFO_HEADER_URL] forKey:CONFIG_KEY_INFO_HEADER_URL];
        [dic setObject:[_ud stringForKey:CONFIG_KEY_INFO_ADDRESS] forKey:CONFIG_KEY_INFO_ADDRESS];
        [dic setObject:[_ud stringForKey:CONFIG_KEY_INFO_NICKNAME] forKey:CONFIG_KEY_INFO_NICKNAME];
        [dic setObject:[_ud stringForKey:CONFIG_KEY_INFO_GENDER] forKey:CONFIG_KEY_INFO_GENDER];
        [dic setObject:[_ud stringForKey:CONFIG_KEY_INFO_AGE] forKey:CONFIG_KEY_INFO_AGE];
        [dic setObject:[_ud stringForKey:CONFIG_KEY_INFO_RECOMMEND_CODE] forKey:CONFIG_KEY_INFO_RECOMMEND_CODE];

    return dic;
}
#pragma mark - 提交个人信息
-(void)EMDelegatePostMyInfo{
   NSString *address    =      [_ud stringForKey:CONFIG_KEY_INFO_ADDRESS];
   NSString *nickname   =      [_ud stringForKey:CONFIG_KEY_INFO_NICKNAME];
   NSString *gender     =      [_ud stringForKey:CONFIG_KEY_INFO_GENDER];
   NSString *age        =      [_ud stringForKey:CONFIG_KEY_INFO_AGE];
   NSString *path       =       [_ud stringForKey:CONFIG_KEY_LOCAL_HIPATH];
    NSString *uzname    =       [_ud stringForKey:CONFIG_KEY_BIND_SAFE_NAME];
    NSString *unumber = [_ud stringForKey:CONFIG_KEY_BIND_SAFE_NUMBER];
    
    ASIFormDataRequest *request = [self resquestInstanceForUrl:[self requestUrlForKey:SERVER_URL_POSTUSERINFO]];
    [request setPostValue:@"0"          forKey:@"action_type"];
    [request setPostValue:nickname      forKey:@"uname"];
    [request setPostValue:gender        forKey:@"usex"];
    [request setPostValue:address       forKey:@"uadress"];
    [request setPostValue:age           forKey:@"uage"];
    //身份证号码
        [request setPostValue:uzname           forKey:@"uzsname"];
    //姓名
        [request setPostValue:unumber           forKey:@"uidentity"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        [request setFile:path forKey:@"file"];
    }
    [request setCompletionBlock :^{
//        //响应成功
        NSString *responseString = [request responseString ]; // 对于
        NSError         *error = nil;
        SBJsonParser    *parser = [[SBJsonParser alloc] init];
        NSDictionary    *rootDic = [parser objectWithString:responseString error:&error];
        NSString *msg = [rootDic objectForKey:@"code"];
        NSLog(@"提交用户信息:%@",msg);
        if ([msg isEqualToString:@"00"]) {
            //成功之后更新余额
            [self updateBalance];
            if ([_delegate respondsToSelector:@selector(onMyInfoUpdateDoneToServer)]) {
                [_delegate onMyInfoUpdateDoneToServer];
            }
            if (_rootView) {
                [FVCustomAlertView hideAlertFromView:_rootView fading:NO];
                [FVCustomAlertView showDefaultDoneAlertOnView:_rootView withTitle:@"保存成功"];
                [_ud setBool:YES forKey:CONFIG_KEY_SAVE_MYINFO];//是否保存过个人信息
            }
            double delayInSeconds = 1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                if (_rootView) {
                    
                    [FVCustomAlertView hideAlertFromView:_rootView fading:NO];
                }
            });
        } else {
            if (_rootView) {
                [FVCustomAlertView hideAlertFromView:_rootView fading:NO];
                [FVCustomAlertView showDefaultWarningAlertOnView:_rootView withTitle:@"出现异常!"];
            }
        }
        
    }];
    [request setFailedBlock:^{
        NSError *error = [request error ];
        NSLog ( @"error:%@" ,[error userInfo ]);
        if (_rootView) {
            [FVCustomAlertView hideAlertFromView:_rootView fading:NO];
            [FVCustomAlertView showDefaultErrorAlertOnView:_rootView withTitle:@"加载超时!"];
        }
        
    }];
    [request setStartedBlock:^{
        NSLog(@"请求开始...");
        if (_rootView) {
            
            [FVCustomAlertView showDefaultLoadingAlertOnView:_rootView withTitle:@"加载中.."];
        }
    }];
    [request startAsynchronous];
}
-(void)EMDelegateInitMingXiList{
    ASIFormDataRequest *request = [self resquestInstanceForUrl:[self requestUrlForKey:SERVER_URL_MINXI]];
    [request setCompletionBlock :^{
        //响应成功
        NSString *responseString = [request responseString ]; // 对于
        NSError         *error = nil;
        SBJsonParser    *parser = [[SBJsonParser alloc] init];
        NSDictionary    *rootDic = [parser objectWithString:responseString error:&error];
        NSArray *val = [rootDic objectForKey:@"rows"];
        if (!val) {
            NSLog(@"EMDelegateInitMingXiList 异常");
        }
        if ([_delegate respondsToSelector:@selector(onInitMinXiListLoadDone:)]) {
            [_delegate onInitMinXiListLoadDone:val];
        }
        if (_rootView) {
            [FVCustomAlertView hideAlertFromView:_rootView fading:YES];
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request error ];
        NSLog ( @"error:%@" ,[error userInfo ]);
        if (_rootView) {
            [FVCustomAlertView hideAlertFromView:_rootView fading:NO];
            [FVCustomAlertView showDefaultErrorAlertOnView:_rootView withTitle:@"加载超时!"];
        }
        
    }];
    [request setStartedBlock:^{
        NSLog(@"请求开始...");
        if (_rootView) {
            
            [FVCustomAlertView showDefaultLoadingAlertOnView:_rootView withTitle:@"加载中.."];
        }
    }];
    [request startAsynchronous];
}
#pragma mark - 初始化广告记录
-(void)EMDelegateInitAdlistHistory{
    //获得列表广告
    ASIFormDataRequest *request = [self resquestInstanceForUrl:[self requestUrlForKey:SERVER_URL_ADHISTORY]];
    [request setCompletionBlock :^{
        //响应成功
        NSString *responseString = [request responseString ]; // 对于
        NSError         *error = nil;
        SBJsonParser    *parser = [[SBJsonParser alloc] init];
        NSDictionary    *rootDic = [parser objectWithString:responseString error:&error];
        NSArray *val = [rootDic objectForKey:@"rows"];
        if (!val) {
            NSLog(@"EMDelegateInitAdlistHistory 异常");
        }
        if (_rootView) {
            [FVCustomAlertView hideAlertFromView:_rootView fading:NO];
        }
        if ([_delegate respondsToSelector:@selector(onInitMyAdListHistoryForServer:)]) {
            [_delegate onInitMyAdListHistoryForServer:val];
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request error ];
        NSLog ( @"error:%@" ,[error userInfo ]);
        if (_rootView) {
            [FVCustomAlertView hideAlertFromView:_rootView fading:NO];
            [FVCustomAlertView showDefaultErrorAlertOnView:_rootView withTitle:@"加载超时!"];
        }
        
    }];
    [request setStartedBlock:^{
        NSLog(@"请求开始...");
        if (_rootView) {
            
            [FVCustomAlertView showDefaultLoadingAlertOnView:_rootView withTitle:@"加载中.."];
        }
    }];
    [request startAsynchronous];
    
}
#pragma mark - 初始化提现列表
-(void)EMDelegateInitTixianList{

    ASIFormDataRequest *request = [self resquestInstanceForUrl:[self requestUrlForKey:SERVER_URL_TIXIANLIST]];
    [request setPostValue:@"1" forKey:@"type"];
    [request setCompletionBlock :^{
        //响应成功
        NSString *responseString = [request responseString ]; // 对于
        NSError         *error = nil;
        SBJsonParser    *parser = [[SBJsonParser alloc] init];
        NSDictionary    *rootDic = [parser objectWithString:responseString error:&error];
        NSArray *val = [rootDic objectForKey:@"rows"];
        if (!val) {
            NSLog(@"EMDelegateInitTixianList 异常");
        }
        if (_rootView) {
            [FVCustomAlertView hideAlertFromView:_rootView fading:YES];
        }
        if ([_delegate respondsToSelector:@selector(onInitTixianListForServer:)]) {
            [_delegate onInitTixianListForServer:val];
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request error ];
        NSLog ( @"error:%@" ,[error userInfo ]);
        if (_rootView) {
            [FVCustomAlertView hideAlertFromView:_rootView fading:NO];
            [FVCustomAlertView showDefaultErrorAlertOnView:_rootView withTitle:@"加载超时!"];
        }
        
    }];
    [request setStartedBlock:^{
        NSLog(@"请求开始...");
        if (_rootView) {
            
            [FVCustomAlertView showDefaultLoadingAlertOnView:_rootView withTitle:@"加载中.."];
        }
    }];
    [request startAsynchronous];
}
#pragma mark - 提现申请
-(void)EMDelegateTixianCommit{
    ASIFormDataRequest *request = [self resquestInstanceForUrl:[self requestUrlForKey:SERVER_URL_TIXIAN]];
    
    EMAppDelegate *del = [[UIApplication sharedApplication] delegate];

    NSString *name = [_ud stringForKey:CONFIG_KEY_BANK_NAME];
    NSString *bkn = [_ud stringForKey:CONFIG_KEY_BANK_NUMBER];
    NSString *bka = [_ud stringForKey:CONFIG_KEY_BANK_ADDR];
    [request setPostValue:bkn forKey:@"ubankno"];
    [request setPostValue:bka forKey:@"ubankName"];
    [request setPostValue:name forKey:@"uname"];
    [request setPostValue:del.tixianId forKey:@"pId"];
    [request setCompletionBlock :^{
        //响应成功
        NSString *responseString = [request responseString ]; // 对于
        NSError         *error = nil;
        SBJsonParser    *parser = [[SBJsonParser alloc] init];
        NSDictionary    *rootDic = [parser objectWithString:responseString error:&error];
        if ([@"00" isEqualToString:[rootDic objectForKey:@"code"]]) {
            if (_rootView) {
                [FVCustomAlertView hideAlertFromView:_rootView fading:NO];
                [FVCustomAlertView showDefaultDoneAlertOnView:_rootView withTitle:@"申请成功"];
                double delayInSeconds = 1;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    if (_rootView) {
                        
                        [FVCustomAlertView hideAlertFromView:_rootView fading:NO];
                    }
                });
                if ([_delegate respondsToSelector:@selector(onTixianCommitDone)]) {
                    [_delegate onTixianCommitDone];
                }
            }
        } else {
            if (_rootView) {
                [FVCustomAlertView hideAlertFromView:_rootView fading:NO];
                [FVCustomAlertView showDefaultWarningAlertOnView:_rootView withTitle:@"申请失败"];
            }
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request error ];
        NSLog ( @"error:%@" ,[error userInfo ]);
        if (_rootView) {
            [FVCustomAlertView hideAlertFromView:_rootView fading:NO];
            [FVCustomAlertView showDefaultErrorAlertOnView:_rootView withTitle:@"加载超时!"];
        }
        
    }];
    [request setStartedBlock:^{
        NSLog(@"请求开始...");
        if (_rootView) {
            
            [FVCustomAlertView showDefaultLoadingAlertOnView:_rootView withTitle:@"加载中.."];
        }
    }];
    [request startAsynchronous];
}
#pragma mark - 初始化兑换列表
-(void)EMDelegateInitDuiHuanList{
    
    ASIFormDataRequest *request = [self resquestInstanceForUrl:[self requestUrlForKey:SERVER_URL_DUIHUANLIST]];
    [request setCompletionBlock :^{
        //响应成功
        NSString *responseString = [request responseString ]; // 对于
        NSError         *error = nil;
        SBJsonParser    *parser = [[SBJsonParser alloc] init];
        NSDictionary    *rootDic = [parser objectWithString:responseString error:&error];
        NSArray *val = [rootDic objectForKey:@"rows"];
        if (!val) {
            NSLog(@"EMDelegateInitTixianList 异常");
        }
        if (_rootView) {
            [FVCustomAlertView hideAlertFromView:_rootView fading:YES];
        }
        if ([_delegate respondsToSelector:@selector(onInitDuiHuanListForServer:)]) {
            [_delegate onInitDuiHuanListForServer:val];
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request error ];
        NSLog ( @"error:%@" ,[error userInfo ]);
        if (_rootView) {
            [FVCustomAlertView hideAlertFromView:_rootView fading:NO];
            [FVCustomAlertView showDefaultErrorAlertOnView:_rootView withTitle:@"加载超时!"];
        }
        
    }];
    [request setStartedBlock:^{
        NSLog(@"请求开始...");
        if (_rootView) {
            
            [FVCustomAlertView showDefaultLoadingAlertOnView:_rootView withTitle:@"加载中.."];
        }
    }];
    [request startAsynchronous];
}
#pragma mark - 提交兑换信息
-(void)EMDelegatePostDuiHuanInfo{
    
    ASIFormDataRequest *request = [self resquestInstanceForUrl:[self requestUrlForKey:SERVER_URL_POST_DUIHUAN_INFO]];
    EMAppDelegate *del = [[UIApplication sharedApplication] delegate];
    NSDictionary *dic = del.duihuanDic;
    NSString *pid = [dic objectForKey:@"pid"];
    NSString *addr = [_ud stringForKey:CONFIG_KEY_DUIHUAN_ADDR];
    NSString *name = [_ud stringForKey:CONFIG_KEY_DUIHUAN_NAME];
    NSString *phone = [_ud stringForKey:CONFIG_KEY_DUIHUAN_PHONE];
    NSString *count = [_ud stringForKey:CONFIG_KEY_DUIHUAN_COUNT];
    NSString *qq = [_ud stringForKey:CONFIG_KEY_DUIHUAN_QQ];
    [request setPostValue:pid forKey:@"productId"];
    [request setPostValue:phone forKey:@"telephone"];
    [request setPostValue:name forKey:@"uname"];
    [request setPostValue:addr forKey:@"uaddress"];
    [request setPostValue:count forKey:@"num"];
    [request setPostValue:qq forKey:@"dh_qq"];
    [request setCompletionBlock :^{
        //响应成功
        
        NSString *responseString = [request responseString ]; // 对于
        NSError         *error = nil;
        SBJsonParser    *parser = [[SBJsonParser alloc] init];
        NSDictionary    *rootDic = [parser objectWithString:responseString error:&error];
        NSString *msg = [rootDic objectForKey:@"code"];
        NSLog(@"提交兑换信息:%@",msg);
        if ([msg isEqualToString:@"00"]) {
            if (_rootView) {
                [FVCustomAlertView hideAlertFromView:_rootView fading:YES];
                [FVCustomAlertView showDefaultDoneAlertOnView:_rootView withTitle:@"申请成功"];
                [self updateBalance];
            }
            if ([_delegate respondsToSelector:@selector(onPostDuihuanInfoDone)]) {
                [_delegate onPostDuihuanInfoDone];
            }
            double delayInSeconds = 1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                if (_rootView) {
                    
                    [FVCustomAlertView hideAlertFromView:_rootView fading:NO];
                }
            });
        } else {
            if (_rootView) {
                [FVCustomAlertView hideAlertFromView:_rootView fading:NO];
                [FVCustomAlertView showDefaultWarningAlertOnView:_rootView withTitle:@"兑换失败!"];
            }
        }

    }];
    [request setFailedBlock:^{
        NSError *error = [request error ];
        NSLog ( @"error:%@" ,[error userInfo ]);
        if (_rootView) {
            [FVCustomAlertView hideAlertFromView:_rootView fading:NO];
            [FVCustomAlertView showDefaultErrorAlertOnView:_rootView withTitle:@"加载超时!"];
        }
        
    }];
    [request setStartedBlock:^{
        NSLog(@"请求开始...");
        if (_rootView) {
            
            [FVCustomAlertView showDefaultLoadingAlertOnView:_rootView withTitle:@"加载中.."];
        }
    }];
    [request startAsynchronous];
}
#pragma mark - 发送短信验证码
-(void)EMDelegateSendSmsCode{
    ASIFormDataRequest *request = [self resquestInstanceForUrl:[self requestUrlForKey:SERVER_URL_SENDSMSCODE]];
    NSString *tel = [_ud stringForKey:CONFIG_KEY_BIND_SAFE_PHONE];
    [request setPostValue:tel forKey:@"telephone"];
    [request setCompletionBlock :^{
        //响应成功
        NSString *responseString = [request responseString ]; // 对于
        NSError         *error = nil;
        SBJsonParser    *parser = [[SBJsonParser alloc] init];
        NSDictionary    *rootDic = [parser objectWithString:responseString error:&error];
        NSString *msg = [rootDic objectForKey:@"code"];
        NSString *code = [rootDic objectForKey:@"val"];
        if ([msg isEqualToString:@"00"]) {
            
            if (_rootView) {
                [FVCustomAlertView hideAlertFromView:_rootView fading:NO];
                [FVCustomAlertView showDefaultDoneAlertOnView:_rootView withTitle:@"发送成功"];

            }
            if ([_delegate respondsToSelector:@selector(onSmsCodeSendDone:)]) {
                [_delegate onSmsCodeSendDone:code];
            }
            //保存短信验证码
            [_ud setObject:code forKey:CONFIG_KEY_BIND_SMSCODE];
            double delayInSeconds = 1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                if (_rootView) {
                    [FVCustomAlertView hideAlertFromView:_rootView fading:NO];
                }
            });
        } else {
            //请求异常
            [FVCustomAlertView hideAlertFromView:_rootView fading:NO];
            [FVCustomAlertView showDefaultWarningAlertOnView:_rootView withTitle:@"发送失败!"];
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request error ];
        NSLog ( @"error:%@" ,[error userInfo ]);
        if (_rootView) {
            [FVCustomAlertView hideAlertFromView:_rootView fading:NO];
            [FVCustomAlertView showDefaultErrorAlertOnView:_rootView withTitle:@"加载超时!"];
        }
        
    }];
    [request setStartedBlock:^{
        NSLog(@"请求开始...");
        if (_rootView) {
            
            [FVCustomAlertView showDefaultLoadingAlertOnView:_rootView withTitle:@"加载中.."];
        }
    }];
    [request startAsynchronous];
}
#pragma mark - 提交绑定信息
-(void)EMDelegatePostBindInfo{
    ASIFormDataRequest *request = [self resquestInstanceForUrl:[self requestUrlForKey:SERVER_URL_BINDPHONE]];
    NSString *tel = [_ud stringForKey:CONFIG_KEY_BIND_SAFE_PHONE];
    NSString *code = [_ud stringForKey:CONFIG_KEY_BIND_SMSCODE];
    [request setPostValue:tel forKey:@"utelephone"];
    [request setPostValue:code forKey:@"smsCode"];
    [request setCompletionBlock :^{
        //响应成功
        NSString *responseString = [request responseString ]; // 对于
        NSError         *error = nil;
        SBJsonParser    *parser = [[SBJsonParser alloc] init];
        NSDictionary    *rootDic = [parser objectWithString:responseString error:&error];
        NSString *msg = [rootDic objectForKey:@"code"];
        if ([msg isEqualToString:@"00"]) {
            if (_rootView) {
                [FVCustomAlertView hideAlertFromView:_rootView fading:NO];
                [FVCustomAlertView showDefaultDoneAlertOnView:_rootView withTitle:@"绑定成功"];
            }
            if ([_delegate respondsToSelector:@selector(onPostBindInfoDone)]) {
                [_delegate onPostBindInfoDone];
            }
            double delayInSeconds = 1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                if (_rootView) {
                    [FVCustomAlertView hideAlertFromView:_rootView fading:NO];
                }
                
            });
            //绑定FLG
            [_ud setBool:YES forKey:CONFIG_KEY_BIND_FLG];
            //重新加载个人信息
            [self updateMyInfo];
        } else {
            //请求异常
            [FVCustomAlertView hideAlertFromView:_rootView fading:NO];
            [FVCustomAlertView showDefaultWarningAlertOnView:_rootView withTitle:@"出现异常!"];
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request error ];
        NSLog ( @"error:%@" ,[error userInfo ]);
        if (_rootView) {
            [FVCustomAlertView hideAlertFromView:_rootView fading:NO];
            [FVCustomAlertView showDefaultErrorAlertOnView:_rootView withTitle:@"加载超时!"];
        }
        
    }];
    [request setStartedBlock:^{
        NSLog(@"请求开始...");
        if (_rootView) {
            
            [FVCustomAlertView showDefaultLoadingAlertOnView:_rootView withTitle:@"加载中.."];
        }
    }];
    [request startAsynchronous];
}
#pragma mark - 初始化兑换记录
-(void)EMDelegateInitDuihuanHistory{
    ASIFormDataRequest *request = [self resquestInstanceForUrl:[self requestUrlForKey:SERVER_URL_DUIHUAN_HISTORY]];
    [request setCompletionBlock :^{
        //响应成功
        NSString *responseString = [request responseString ]; // 对于
        NSError         *error = nil;
        SBJsonParser    *parser = [[SBJsonParser alloc] init];
        NSDictionary    *rootDic = [parser objectWithString:responseString error:&error];
        NSArray *val = [rootDic objectForKey:@"rows"];
        if (!val) {
            NSLog(@"EMDelegateInitTixianList 异常");
        }
        if (_rootView) {
            [FVCustomAlertView hideAlertFromView:_rootView fading:YES];
        }
        if ([_delegate respondsToSelector:@selector(onInitDuiHuanHistoryForServer:)]) {
            [_delegate onInitDuiHuanHistoryForServer:val];
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request error ];
        NSLog ( @"error:%@" ,[error userInfo ]);
        if (_rootView) {
            [FVCustomAlertView hideAlertFromView:_rootView fading:NO];
            [FVCustomAlertView showDefaultErrorAlertOnView:_rootView withTitle:@"加载超时!"];
        }
        
    }];
    [request setStartedBlock:^{
        NSLog(@"请求开始...");
        if (_rootView) {
            
            [FVCustomAlertView showDefaultLoadingAlertOnView:_rootView withTitle:@"加载中.."];
        }
    }];
    [request startAsynchronous];
}
#pragma mark - 初始化消息中心数据
-(void)EMDelegateInitMessageList{
    ASIFormDataRequest *request = [self resquestInstanceForUrl:[self requestUrlForKey:SERVER_URL_MESSAGE]];
        NSString *devicesid = [_ud stringForKey:CONFIG_KEY_DEVICEID];
    [request setPostValue:@"1" forKey:@"page"];
    [request setPostValue:@"100" forKey:@"rows"];
    [request setPostValue:devicesid forKey:@"devicesId"];
    [request setCompletionBlock :^{
        //响应成功
        NSString *responseString = [request responseString ]; // 对于
        NSError         *error = nil;
        SBJsonParser    *parser = [[SBJsonParser alloc] init];
        NSDictionary    *rootDic = [parser objectWithString:responseString error:&error];
        NSArray *val = [rootDic objectForKey:@"rows"];
        if (!val) {
            NSLog(@"EMDelegateInitTixianList 异常");
        }
        if (_rootView) {
            [FVCustomAlertView hideAlertFromView:_rootView fading:NO];
        }
        if ([_delegate respondsToSelector:@selector(onInitMessageList:)]) {
            [_delegate onInitMessageList:val];
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request error ];
        NSLog ( @"error:%@" ,[error userInfo ]);
        if (_rootView) {
            [FVCustomAlertView hideAlertFromView:_rootView fading:NO];
            [FVCustomAlertView showDefaultErrorAlertOnView:_rootView withTitle:@"加载超时!"];
        }
        
    }];
    [request setStartedBlock:^{
        NSLog(@"请求开始...");
        if (_rootView) {
            
            [FVCustomAlertView showDefaultLoadingAlertOnView:_rootView withTitle:@"加载中.."];
        }
    }];
    [request startAsynchronous];
    
}
-(void)EMDelegatePostFeedBack:(NSString *)text{
    ASIFormDataRequest *request = [self resquestInstanceForUrl:[self requestUrlForKey:SERVER_URL_FEEDBACK]];
    [request setPostValue:text forKey:@"fcontent"];
    [request setCompletionBlock :^{
        //        //响应成功
        NSString *responseString = [request responseString ]; // 对于
        NSError         *error = nil;
        SBJsonParser    *parser = [[SBJsonParser alloc] init];
        NSDictionary    *rootDic = [parser objectWithString:responseString error:&error];
        NSString *msg = [rootDic objectForKey:@"code"];
        if ([msg isEqualToString:@"00"]) {
            //成功之后更新余额
            if ([_delegate respondsToSelector:@selector(onPOstFeedBackDone)]) {
                [_delegate onPOstFeedBackDone];
            }
            if (_rootView) {
                [FVCustomAlertView hideAlertFromView:_rootView fading:NO];
                [FVCustomAlertView showDefaultDoneAlertOnView:_rootView withTitle:@"提交成功"];
            }
        } else {
            if (_rootView) {
                [FVCustomAlertView hideAlertFromView:_rootView fading:NO];
                [FVCustomAlertView showDefaultWarningAlertOnView:_rootView withTitle:@"出现异常!"];
            }
        }
        
    }];
    [request setFailedBlock:^{
        NSError *error = [request error ];
        NSLog ( @"error:%@" ,[error userInfo ]);
        if (_rootView) {
            [FVCustomAlertView hideAlertFromView:_rootView fading:NO];
            [FVCustomAlertView showDefaultErrorAlertOnView:_rootView withTitle:@"加载超时!"];
        }
        
    }];
    [request setStartedBlock:^{
        NSLog(@"请求开始...");
        if (_rootView) {
            
            [FVCustomAlertView showDefaultLoadingAlertOnView:_rootView withTitle:@"加载中.."];
        }
    }];
    [request startAsynchronous];

}
@end
