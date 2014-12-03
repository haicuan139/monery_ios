//
//  EMTiXianTableViewController.m
//  moenycat
//
//  Created by haicuan139 on 14-9-7.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import "EMTiXianTableViewController.h"

@interface EMTiXianTableViewController ()

@end

@implementation EMTiXianTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"我要提现"];
    _delegateClass = [[EMDelegateClass alloc]init];
    _delegateClass.rootView = self.view;
    _delegateClass.delegate = self;
    _tixianArray = [[NSMutableArray alloc]init];
    [_delegateClass EMDelegateInitTixianList];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)onInitTixianListForServer:(NSArray *)tixianList{
    [_tixianArray removeAllObjects];
    for (int i = 0; i < tixianList.count; i++) {
        NSDictionary *dic = [tixianList objectAtIndex:i];
        [_tixianArray addObject:dic];
    }
    [self.tableView reloadData];
}
-(void)initBaseLeftItem{
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //这个方法告诉表格第section个分组有多少行
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //这个方法用来告诉表格有几个分组
    return _tixianArray.count;
}
- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 95;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self onItemClickNSIndexPath:indexPath];
    
}
-(void)onItemClickNSIndexPath:(NSIndexPath *)indexPath{
    //点击事件
     if ([self getBoolValueForKey:CONFIG_KEY_BIND_FLG]) {
        NSInteger balance = [self getIntegerValueForKey:CONFIG_KEY_LOCAL_BALANCE];
        if ((balance / 100) < 1) {
            [FVCustomAlertView showDefaultWarningAlertOnView:self.view withTitle:@"余额不足!"];
        } else {
            EMAppDelegate *dele = (EMAppDelegate *)[[UIApplication sharedApplication]delegate];
            NSInteger  section = [indexPath section];
            NSDictionary *dic = [_tixianArray objectAtIndex:section];
            NSInteger num = [[dic objectForKey:@"pnum"] integerValue];
            if (num == 0) {
                //提现数量不够
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"本月的提现数量已经用完了哦!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
                return;
            }
            dele.tixianId = [dic objectForKey:@"pid"];
            [self pushViewControllerWithStorboardName:@"tixian_input" sid:@"tixian_input" hiddenTabBar:YES];
        }
     } else {
         [self showBindDialog];
     }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger  section = [indexPath section];
        static NSString *CellIdentifier = @"EMTixianCell";
    EMTixianCell *cell = (EMTixianCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *marray = [[NSBundle mainBundle] loadNibNamed:@"EMTixianCell" owner:self options:nil];
        cell = [marray objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    cell.selectedBackgroundView=[[[UIView alloc]initWithFrame:cell.frame]autorelease];
    cell.selectedBackgroundView.backgroundColor = [UIColor grayColor];
    cell.titleLable.textColor = [UIColor whiteColor];
    cell.descriptionLable.textColor = [UIColor whiteColor];
    UIColor* color=[EMColorHex getColorWithHexString:@"#FDB2B2"];//通过RGB来定义颜色
    NSDictionary *dic = [_tixianArray objectAtIndex:section];
    NSString *title = [dic objectForKey:@"pname"];
    NSString *desc = [dic objectForKey:@"pdesc"];
    NSInteger num = [[dic objectForKey:@"pnum"] integerValue];
    NSString *numStr = [NSString stringWithFormat:@"(剩:%ld份)",(long)num];
    cell.descriptionLable.text = [desc stringByAppendingString:numStr];
    cell.titleLable.text = title;
//    cell.numLable.text = numStr;
//    [cell.numLable setTextColor:[UIColor whiteColor]];
    if (section == 0) {
        cell.backgroundColor = color;
    } else {
        cell.selectedBackgroundView=[[[UIView alloc]initWithFrame:cell.frame]autorelease];
        cell.selectedBackgroundView.backgroundColor = color;
        cell.backgroundColor = [UIColor grayColor];
    }
    return cell;
}
- (void)dealloc {
    [self.tableView release];
    [_tixianArray release];
    [_delegateClass release];
    [super dealloc];
}
@end
