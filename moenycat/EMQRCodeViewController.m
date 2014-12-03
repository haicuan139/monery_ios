//
//  EMQRCodeViewController.m
//  moenycat
//
//  Created by haicuan139 on 14-11-11.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import "EMQRCodeViewController.h"

@interface EMQRCodeViewController ()

@end

@implementation EMQRCodeViewController
-(void)initBaseLeftItem{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"二维码"];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *nickName = [ud stringForKey:CONFIG_KEY_INFO_NICKNAME];
    NSString *imagePath =        [ud stringForKey:CONFIG_KEY_LOCAL_HIPATH];
    NSString *headerUrl =        [ud stringForKey:CONFIG_KEY_INFO_HEADER_URL];
    UIImage *image = [UIImage imageNamed:imagePath];
    [_headerImage setImageWithURL:[NSURL URLWithString:headerUrl] placeholderImage:image];
    [_nickName setText:nickName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



- (void)dealloc {
    [_headerImage release];
    [_nickName release];
    [super dealloc];
}
@end
