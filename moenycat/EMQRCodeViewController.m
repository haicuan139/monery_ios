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
    NSString *nickName = [self getStringValueForKey:CONFIG_KEY_INFO_NICKNAME];
    NSString *imagePath = [self getStringValueForKey:CONFIG_KEY_INFO_HEADER_URL];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:imagePath]) {
        UIImage *h = [UIImage imageWithContentsOfFile:imagePath];
        [_headerImage setImage:h];
    } else {
        [_headerImage setImage:[UIImage imageNamed:@"test_headimage3.jpg"]];
    }
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
