//
//  EMMyInfoTitleView.m
//  moenycat
//
//  Created by haicuan139 on 14-8-26.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import "EMMyInfoTitleView.h"

@implementation EMMyInfoTitleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

+(EMMyInfoTitleView *)getInstance{
    //返回当前View
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"EMMyInfoTitleView" owner:nil options:nil];
    EMMyInfoTitleView * rView = [nibView objectAtIndex:0];
    //添加信息
    //添加下划线
    UIView *underLine = [[UIView alloc]init];
    underLine.backgroundColor = [EMColorHex getColorWithHexString:@"#ebebeb"];
    underLine.frame = CGRectMake(0, 41, rView.frame.size.width
                                 , 1);
    UIView *underLine_1 = [[UIView alloc]init];
    underLine_1.backgroundColor = [EMColorHex getColorWithHexString:@"#ebebeb"];
    underLine_1.frame = CGRectMake(0, 0, rView.frame.size.width
                                 , 0.3);
    [rView addSubview:underLine];
    [rView addSubview:underLine_1];
    
    return rView;
}

-(void)dealloc{
    [super dealloc];
    [_headerIcon release];
    [_nickNameLable release];
    [_normalInfoLable release];
    [_tixianButton release];
    [_balanceLable release];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
