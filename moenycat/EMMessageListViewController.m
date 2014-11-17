//
//  EMMessageListViewController.m
//  moenycat
//
//  Created by haicuan139 on 14-9-5.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import "EMMessageListViewController.h"

@interface EMMessageListViewController ()

@end

@implementation EMMessageListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (CGFloat )tableView:(UITableView  *)tableView heightForHeaderInSection:(NSInteger )section{
    //设定分组头部高度
    return 0.1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //这个方法用来告诉表格有几个分组
    return 1;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"消息中心"];
    _refreshController = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [_refreshController addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];

    _messageArray = [[NSMutableArray alloc]init];
    _delegateClass = [[EMDelegateClass alloc]init];
    _delegateClass.rootView = self.view;
    _delegateClass.delegate = self;
    [_delegateClass EMDelegateInitMessageList];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
}

-(void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl{
    [_delegateClass EMDelegateInitMessageList];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return _messageArray.count;
}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
     static NSString *CellIdentifier = @"EMMessageCell";
     EMMessageCell *cell = (EMMessageCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if (cell == nil) {
         NSArray *marray = [[NSBundle mainBundle] loadNibNamed:@"EMMessageCell" owner:self options:nil];
         cell = [marray objectAtIndex:0];
         [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
     }

     if (_messageArray.count > 0 ) {
         NSDictionary *dic = [_messageArray objectAtIndex:indexPath.row];
         NSString *content = [dic objectForKey:@"mcontent"];
         NSString *time = [dic objectForKey:@"mcreateTime"];
         NSString *title = [dic objectForKey:@"mtitle"];
         [cell.msgTitle setText:title];
         [cell.msgContent setText:content];
         [cell.msgTime setText:time];
     }
     return cell;
 }

-(void)onInitMessageList:(NSArray *)messageList{
    if (messageList && messageList.count > 0) {
        
        [_messageArray removeAllObjects];
        for (int i = 0; i < messageList.count; i++) {
            NSDictionary *dic = [messageList objectAtIndex:i];
            [_messageArray addObject:dic];
        }
        [self.tableView reloadData];
    } else {
        [FVCustomAlertView showDefaultWarningAlertOnView:self.view withTitle:@"没有记录"];
    }
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [_refreshController endRefreshing];
    });
    
}
- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67;
}
-(void)dealloc{
    [super dealloc];
    [_delegateClass release];
    [_messageArray release];
    [_refreshController release];
}
@end
