//
//  UrlPostInterface.h
//  moenycat
//
//  Created by haicuan139 on 14-11-4.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#ifndef moenycat_UrlPostInterface_h
#define moenycat_UrlPostInterface_h

//日志提交地址

#define HTTP_REQUEST_SUCCESS @"0"

#define HTTP_BASE_URL @"http://115.28.136.194:8086/zcm/"
#define SERVER_URL_REG @"user/bind_devices.do" //绑定
#define SERVER_URL_GETBALANCE @"user/query_user_balance.do" //查询余额
#define SERVER_URL_GETADLIST @"advert/query_advert.do" //广告列表
#define SERVER_URL_UPDATE @"app/query_new_version.do" //更新APP
#define SERVER_URL_SENDSMSCODE @"user/sendSms.do" //发送短信验证码
#define SERVER_URL_DUIHUANLIST @"product/query_products.do" //兑换列表
#define SERVER_URL_TIXIANLIST @"product/query_products.do" //提现列表 type=1
#define SERVER_URL_USERINFO @"user/query_user_info.do"//用户信息
#define SERVER_URL_LOOPLIST @"advert/query_poll_advert.do"//焦点图列表
#define SERVER_URL_POSTUSERINFO @"user/perfect_user.do" //提交用户信息
#define SERVER_URL_MINXI @"trans/user_accounts.do"//余额明细
#define SERVER_URL_ADHISTORY @"advert/query_user_logs.do" //广告记录
#define SERVER_URL_TIXIAN @"trans/trans_tixian.do" //提现
#define SERVER_URL_BINDPHONE @"user/bind_phone.do" //绑定手机
#define SERVER_URL_UPLOADFILE @"rh_ext/rh_ext_save.do"//上传文件
#define SERVER_URL_POST_DUIHUAN_INFO @"/trans/trans_duihuan.do"//提交兑换信息
#define SERVER_URL_MESSAGE @"/messages/query_msgs.do" //消息列表
#define SERVER_URL_FEEDBACK @"/feedback/add.do" //提交意见反馈
#define SERVER_URL_UPLOAD_LOGFILE @"user/upload_user_log_file.do"//提交日志文件
#define SERVER_URL_DUIHUAN_HISTORY @"/duihuan/query_logs.do" //兑换记录
//URL 参数
#define URL_PARAMS_DEVICEID @"udevicesId"
#endif
