//
//  EMMyInfoTitleView.h
//  moenycat
//
//  Created by haicuan139 on 14-8-26.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMColorHex.h"
@interface EMMyInfoTitleView : UIView

+(EMMyInfoTitleView *)getInstance;
@property (nonatomic , retain) IBOutlet UIButton *headerIcon;
@property (nonatomic , retain) IBOutlet UILabel *nickNameLable;
@property (nonatomic , retain) IBOutlet UILabel *normalInfoLable;//显示等和手机号码
@property (nonatomic , retain) IBOutlet UILabel *balanceLable;//显示余额
@property (nonatomic , retain) IBOutlet UIButton *tixianButton;//显示余额

@end
