//
//  EMMessageCell.h
//  moenycat
//
//  Created by haicuan139 on 14-11-13.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMMessageCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *msgTitle;
@property (retain, nonatomic) IBOutlet UILabel *msgContent;
@property (retain, nonatomic) IBOutlet UILabel *msgTime;

@end
