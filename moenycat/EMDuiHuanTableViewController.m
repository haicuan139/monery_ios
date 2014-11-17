//
//  EMDuiHuanTableViewController.m
//  moenycat
//
//  Created by haicuan139 on 14-9-7.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import "EMDuiHuanTableViewController.h"

@interface EMDuiHuanTableViewController ()

@end

@implementation EMDuiHuanTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)initBaseLeftItem{
}
#pragma mark - 刷新中
-(void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl{
    [_delegateClass EMDelegateInitDuiHuanList];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"超值兑换"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    UIButton *right = [[UIButton alloc]init];
    [right addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    right.frame = CGRectMake(0, 0, 45, 20);
    [right setTitle:@"记录" forState:UIControlStateNormal];
    [right setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    right.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *ritem = [[UIBarButtonItem alloc]initWithCustomView:right];
    
    //添加点击事件
    self.navigationItem.rightBarButtonItem = ritem;
    //添加下拉刷新控件
    _refreshControl = [[ODRefreshControl alloc]initInScrollView:_tableView];
    [_refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    //初始化兑换列表
    _delegateClass = [[EMDelegateClass alloc]init];
    _delegateClass.rootView = self.view;
    _delegateClass.delegate = self;
    _duihuanArray = [[NSMutableArray alloc]init];
    [_delegateClass EMDelegateInitDuiHuanList];
}
-(void)rightItemClick{
    //跳转到兑换记录
    NSLog(@"跳转到兑换记录");
    [self pushViewControllerWithStorboardName:@"duihuan_history" sid:@"duihuan_history"hiddenTabBar:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"EMDuiHuanCell";
    EMDuiHuanCell *cell = (EMDuiHuanCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *marray = [[NSBundle mainBundle] loadNibNamed:@"EMDuiHuanCell" owner:self options:nil];
        cell = [marray objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
        UIColor* color=[EMColorHex getColorWithHexString:@"#FDB2B2"];
    cell.selectedBackgroundView=[[[UIView alloc]initWithFrame:cell.frame]autorelease];
    cell.selectedBackgroundView.backgroundColor = color;
    [cell setBackgroundColor:_tableView.backgroundColor];
    NSDictionary *dic = [_duihuanArray objectAtIndex:indexPath.row];
    NSString *title = [dic objectForKey:@"pname"];
    NSString *num = [[dic objectForKey:@"pnum"] stringValue];
    NSString *price = [[dic objectForKey:@"pprice"] stringValue];
    NSString *url = [dic objectForKey:@"plogo"];
    [cell.title setText:title];
    NSString *numstr = @"数量";
    UIImage *d = [UIImage imageNamed:@"logo.png"];
    [cell.adImage setImageWithURL:[NSURL URLWithString:url] placeholderImage:d];
    [cell.dcount setText:[numstr stringByAppendingString:num]];
    [cell.balance setText:[price stringByAppendingString:@"喵币"]];
    return  cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //这个方法告诉表格第section个分组有多少行
    return _duihuanArray.count;
}
- (CGFloat )tableView:(UITableView  *)tableView heightForHeaderInSection:(NSInteger )section{
    //设定分组头部高度
    return 0.1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //这个方法用来告诉表格有几个分组
    return 1;
}
- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 160;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self onItemClickNSIndexPath:indexPath];
    
}
-(void)onItemClickNSIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"当前Index %d",indexPath.row);
    //如果绑定过
    if ([self getBoolValueForKey:CONFIG_KEY_BIND_FLG]) {
        //如果余额充足
        NSDictionary *pd = [_duihuanArray objectAtIndex:indexPath.row];
        int price = [[pd objectForKey:@"pprice"] integerValue];
        int balance = [self getIntegerValueForKey:CONFIG_KEY_LOCAL_BALANCE];
        if (balance >= price) {
            EMAppDelegate *del = [[UIApplication sharedApplication] delegate];
            del.duihuanDic = pd;
            [self pushViewControllerWithStorboardName:@"duihuan_input" sid:@"duihuan_input" hiddenTabBar:YES];
        } else {
            [FVCustomAlertView showDefaultWarningAlertOnView:self.view withTitle:@"余额不足!"];
        }

    } else {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"绑定手机号码后才能兑换哦!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"绑定", nil];
        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self pushViewControllerWithStorboardName:@"bind_input" sid:@"bind" hiddenTabBar:YES];
                
            }
        }];

    }

    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 初始化兑换列表
-(void)onInitDuiHuanListForServer:(NSArray *)duihuanList{
    [_duihuanArray removeAllObjects];
    if (duihuanList) {
        for (int i = 0; i < duihuanList.count; i++) {
            NSDictionary *dic = [duihuanList objectAtIndex:i];
            [_duihuanArray addObject:dic];
        }
    }
    [_tableView reloadData];
    double delayInSeconds = 0.5f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [_refreshControl endRefreshing];
    });
}

- (void)dealloc {


    [_tableView release];
    [_refreshControl release];
    [_duihuanArray release];
    [_delegateClass release];
    [super dealloc];
}
@end
