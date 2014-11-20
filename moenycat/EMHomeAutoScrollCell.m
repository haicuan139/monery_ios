//
//  EMHomeAutoScrollCell.m
//  moenycat
//
//  Created by haicuan139 on 14-10-9.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import "EMHomeAutoScrollCell.h"

@implementation EMHomeAutoScrollCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {


    }
    return self;
}

-(void)onMyInfoInitDone:(NSDictionary *)myInfo{
    //加载个人信息
    NSString *tel = [myInfo objectForKey:CONFIG_KEY_INFO_PHONE];
    NSString *nickName = [myInfo objectForKey:CONFIG_KEY_INFO_NICKNAME];
    NSURL *url = [ NSURL URLWithString :[myInfo objectForKey:CONFIG_KEY_INFO_HEADER_URL]];
//    如果本地有图片就使用本地的图片
        [_headerImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"test_headimage3.jpg"]];
    
    [_nickNameLable setText:nickName];
    [_telPhoneLable setText:tel];
    NSLog(@"加载个人信息的回掉执行!");
}

-(void)onBalanceChangeForServer:(NSString *)balance{

    double r = [balance floatValue] / 100;
    NSString *rmb = [[NSString alloc]initWithFormat:@"余额:%ld喵币(%0.2f元)",(long)[balance integerValue],r];
    [_balanceLable setText:rmb];
}
-(void)initInfo{
    _delegateClass = [[EMDelegateClass alloc] init];
    _delegateClass.delegate = self;
    [_delegateClass EMDelegateInitMyInfo];
    [_delegateClass EMDelegateInitBalanceForServer];
}
- (void)awakeFromNib
{
    [self initInfo];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_autoScrollView release];
    [_headerImage release];
    [_nickNameLable release];
    [_telPhoneLable release];
    [_balanceLable release];
    [_delegateClass release];
    [super dealloc];
}
@end
