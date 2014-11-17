//
//  EMMingXiViewController.m
//  moenycat
//
//  Created by haicuan139 on 14-9-11.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import "EMMingXiViewController.h"

@interface EMMingXiViewController ()

@end

@implementation EMMingXiViewController
-(void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl{
    [_delegateClass EMDelegateInitMingXiList];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [refreshControl endRefreshing];
    });
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _mingxiArray.count;
}
- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self onItemClickNSIndexPath:indexPath];
    
}
-(void)onItemClickNSIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击明细");//进入每个条目的明细
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"EMMingXiCell";
    EMMingXiCell *cell = (EMMingXiCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *marray = [[NSBundle mainBundle] loadNibNamed:@"EMMingXiCell" owner:self options:nil];
        cell = [marray objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    UIColor* color=[EMColorHex getColorWithHexString:@"#FDB2B2"];
    cell.selectedBackgroundView=[[[UIView alloc]initWithFrame:cell.frame]autorelease];
    cell.selectedBackgroundView.backgroundColor = color;
    int index = [indexPath row];
    if (_mingxiArray.count > 0) {
        NSDictionary *dic = [_mingxiArray objectAtIndex:index];
        NSString *title = [dic objectForKey:@"trRemark"];
        NSString *time = [dic objectForKey:@"trBeginTime"];
        NSDecimalNumber *balance = [dic objectForKey:@"trBalance"];
        NSDecimalNumber *amount = [dic objectForKey:@"trAmount"];

        int type = [[dic objectForKey:@"trInOrOut"]integerValue];
        [cell.typeLable setText:title];
        [cell.timeLable setText:time];
        NSString *balanceStr = [@"余额:" stringByAppendingString:[balance stringValue]];

        [cell.balanceLable setText: [balanceStr stringByAppendingString:@"喵币"]];
        if (type == 1) {
            //收入
            cell.balanceStateLable.textColor = [EMColorHex getColorWithHexString:@"#399B42"];
            cell.balanceStateLable.text = [@"+" stringByAppendingString:[amount stringValue]];
        } else if (type == 2){
            //支出
            cell.balanceStateLable.text = [@"-" stringByAppendingString:[amount stringValue]];
        }
    }
    return cell;
}
-(void)initBaseLeftItem{
    
}
- (CGFloat )tableView:(UITableView  *)tableView heightForHeaderInSection:(NSInteger )section{
    //设定分组头部高度
    return 0.1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //这个方法用来告诉表格有几个分组
    return 1;
}
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
    [self setTitle:@"收支明细"];
    //下拉刷新
    ODRefreshControl *refresh = [[ODRefreshControl alloc]initInScrollView:self.tableView];
    [refresh addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    _delegateClass = [[EMDelegateClass alloc]init];
    _delegateClass.rootView = self.view;
    _delegateClass.delegate = self;
    [_delegateClass EMDelegateInitMingXiList];
    _mingxiArray = [[NSMutableArray alloc]init];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
}
-(void)onInitMinXiListLoadDone:(NSArray *)mingxiList{
    [_mingxiArray removeAllObjects];
    for (int  i = 0; i < mingxiList.count; i++) {
        [_mingxiArray addObject:[mingxiList objectAtIndex:i]];
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    [super dealloc];
    [_mingxiArray release];
    [_delegateClass release];
}
@end
