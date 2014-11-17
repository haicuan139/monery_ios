//
//  LocalConfigKey.h
//  moenycat
//
//  Created by haicuan139 on 14-11-4.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#ifndef moenycat_LocalConfigKey_h
#define moenycat_LocalConfigKey_h
#define CONFIG_KEY_FIRST_RUN        @"_first_run" //是否是第一次运行
#define CONFIG_KEY_INIMYINFO        @"_init_myfino"//个人信息初始化标识
#define CONFIG_KEY_VERSIONCODE      @"_current_version" //存储版本号
#define CONFIG_KEY_BIND_FLG         @"_bind_flg" //是否绑定过
#define CONFIG_KEY_LOCAL_BALANCE    @"_local_balance" //本地存储的余额
#define CONFIG_KEY_BALANCE_FLG      @"_init_balance"//加载余额的标识
#define CONFIG_KEY_FIRST_REG        @"_first_reg"//是否注册过
#define CONFIG_KEY_DUIHUAN_NAME     @"_duihuan_name"//兑换名字
#define CONFIG_KEY_DUIHUAN_ADDR     @"_duihuan_addr"//兑换地址
#define CONFIG_KEY_DUIHUAN_PHONE    @"_duihuan_phone"//兑换手机号码
#define CONFIG_KEY_DUIHUAN_COUNT    @"_duihuan_count"//兑换数量
#define CONFIG_KEY_BIND_SAFE_NUMBER      @"_safe_number"//身份证号码
#define CONFIG_KEY_BIND_SAFE_NAME        @"_safe_name"//安全信息姓名
#define CONFIG_KEY_BIND_SAFE_PHONE      @"_safe_phone"//绑定的手机号
#define CONFIG_KEY_BIND_SMSCODE     @"_sms_code"//接收到的短信验证码
#define CONFIG_KEY_BANK_ADDR        @"_bank_addr"//银行卡开户行
#define CONFIG_KEY_BANK_NAME        @"_bank_name"//银行卡姓名
#define CONFIG_KEY_BANK_NUMBER      @"_bank_number"//银行卡
#define CONFIG_KEY_BANK_PHONE       @"_bank_phone"//电话
#define CONFIG_KEY_DEVICEID         @"_deviceid" //设备ID
#define CONFIG_KEY_REG_DEVICE       @"_reg_device_done"//注册设备标志
#define CONFIG_KEY_LOCAL_HIPATH     @"_header_local_path" //本地的头像
//个人信息
#define CONFIG_KEY_INFO_NICKNAME            @"uname" //昵称
#define CONFIG_KEY_INFO_PHONE               @"utelephone" //电话号码
#define CONFIG_KEY_INFO_HEADER_URL          @"uImage" //头像url
#define CONFIG_KEY_INFO_ADDRESS             @"uaddress" //地址
#define CONFIG_KEY_INFO_AGE                 @"uage" //年龄
#define CONFIG_KEY_INFO_RECOMMEND_CODE      @"utgm"//推广码
#define CONFIG_KEY_INFO_GENDER              @"usex"//性别
#define CONFIG_KEY_SAVE_MYINFO              @"save_info_flg"//
#define CONFIG_KEY_WEB_TYPE                 @"_web_type"//加载网页的类型更多里面使用
#endif
