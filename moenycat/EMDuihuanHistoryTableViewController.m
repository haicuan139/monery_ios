//
//  EMDuihuanHistoryTableViewController.m
//  moenycat
//
//  Created by haicuan139 on 14-11-12.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import "EMDuihuanHistoryTableViewController.h"

@interface EMDuihuanHistoryTableViewController ()

@end

@implementation EMDuihuanHistoryTableViewController

- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"兑换记录"];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    _delegateClass = [[EMDelegateClass alloc]init];
    _delegateClass.rootView = self.view;
    _delegateClass.delegate = self;
    _historyListArray = [[NSMutableArray alloc]init];
    [_delegateClass EMDelegateInitDuihuanHistory];
}
- (CGFloat )tableView:(UITableView  *)tableView heightForHeaderInSection:(NSInteger )section{
    //设定分组头部高度
    return 0.1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //这个方法用来告诉表格有几个分组
    return 1;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)onInitDuiHuanHistoryForServer:(NSArray *)historyArray{

    [_historyListArray removeAllObjects];
    if (historyArray && historyArray.count > 0) {
        for (int i=0; i<historyArray.count; i++) {
            NSDictionary *dic = [historyArray objectAtIndex:i];
            [_historyListArray addObject:dic];
        }
    } else {
        [FVCustomAlertView showDefaultWarningAlertOnView:self.view withTitle:@"没有记录"];
    }
    [self.tableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _historyListArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EMDuiHuanHistoryCell";
    EMDuiHuanHistoryCell *cell = (EMDuiHuanHistoryCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *marray = [[NSBundle mainBundle] loadNibNamed:@"EMDuiHuanHistoryCell" owner:self options:nil];
        cell = [marray objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    if (_historyListArray.count > 0 ) {
        
        NSDictionary *dic = [_historyListArray objectAtIndex:indexPath.row];
        NSString *time = [dic objectForKey:@"dhCreateTime"];
        NSString *title = [dic objectForKey:@"dhPname"];
        NSString *name = [dic objectForKey:@"dhUname"];
        NSString *addr = [dic objectForKey:@"dhAddress"];
        NSInteger state = [[dic objectForKey:@"dhStatus"] integerValue];
        if (state == 0) {
            [cell.duihuanStates setText:@"审核中"];
            [cell.duihuanStates setTextColor:[UIColor orangeColor]];
        } else if (state == 1){
            [cell.duihuanStates setText:@"审核通过"];
                        [cell.duihuanStates setTextColor:[UIColor greenColor]];

        } else if (state == 2){
            [cell.duihuanStates setText:@"未通过"];
                        [cell.duihuanStates setTextColor:[UIColor redColor]];
        }

        [cell.duihuanAddress setText:[@"收货地址:" stringByAppendingString:addr]];
        [cell.duihuanName setText:[@"收货人:" stringByAppendingString:name]];
        [cell.duihuanTime setText:time];
        [cell.duihuanTitle setText:title];
    }
    
    return cell;
}

-(void)dealloc{
    [super dealloc];
    [_delegateClass release];
    [_historyListArray release];
}

@end
