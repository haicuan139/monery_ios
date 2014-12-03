//
//  EMRecommendViewController_v2.m
//  moenycat
//
//  Created by haicuan139 on 14-10-9.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import "EMRecommendViewController_v2.h"

@interface EMRecommendViewController_v2 ()

@end

@implementation EMRecommendViewController_v2

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //添加下拉刷新
    [self initPullRefreshView];
     _delegateClass = [[EMDelegateClass alloc]init];
    _delegateClass.delegate = self;
    _delegateClass.rootView = self.view;
    [_delegateClass EMDelegateInitTaskList];
    _viewsArray = [[NSMutableArray alloc] init];
    _taskListArray = [[NSMutableArray alloc]init];
    _taskLoopListArray = [[NSMutableArray alloc]init];
    [self.tableView setHidden:YES];
    [_delegateClass EMDelegateInitTaskList];
    [_delegateClass EMDelegateInitTaskLoop];
    NSLog(@"初始化任务列表");
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
}

-(void)onAdLisrLoadError{
    [self.tableView setHidden:NO];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_refreshView endRefreshing];
}
#pragma mark - 初始化任务列表的时候
-(void)onInitTaskListForServer:(NSArray *)taskList{
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_taskListArray removeAllObjects];
        NSLog(@"当前数组数量任务列表:%lu",(unsigned long)taskList.count);
    for (int i = 0; i < taskList.count; i++) {
        [_taskListArray addObject:[taskList objectAtIndex:i]];
    }
    [self.tableView reloadData];
    [self.tableView setHidden:NO];
}
#pragma mark - 初始化焦点图列表
-(void)onInitTaskLoopListForServer:(NSArray *)loopList{
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    NSLog(@"当前数组数量焦点图列表:%lu",(unsigned long)loopList.count);
    [_viewsArray removeAllObjects];
    [_taskLoopListArray removeAllObjects];
    for (int i = 0; i < loopList.count; i++) {
        NSDictionary *dic = [loopList objectAtIndex:i];
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(0, 0, self.view.frame.size.width,150);
        UIImage *def = [UIImage imageNamed:@"logo.png"];
        //图片地址
        NSURL *url = [NSURL URLWithString:[dic objectForKey:@"adImage"]];
        [imageView setImageWithURL:url placeholderImage:def];
        [_viewsArray addObject:imageView];
        [_taskLoopListArray addObject:dic];
    }
    [self.tableView reloadData];
    [self.tableView setHidden:NO];
    double delayInSeconds = 0.5f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [_refreshView endRefreshing];
    });
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}
//cell高度
- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return  150;
    }
    return 55;
}
//tab数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (_taskListArray.count > 0) {
        return _taskListArray.count + 1;
    }
    
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self onItemClick:indexPath.row];
}
-(void)onItemClick:(NSUInteger)itemIndex{
    EMAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.adInfoDicToH5  =  [_taskListArray objectAtIndex:itemIndex - 1];
    [self pushViewControllerWithStorboardName:@"adhtml5" sid:@"adhtml5" hiddenTabBar:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableViewT cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //加载轮询
    if (indexPath.row == 0) {
        static NSString *CellIdentifier_autoscroll = @"EMRecommendAutoScrollCell";
        EMHomeAutoScrollCell *cell_sutoscroll = (EMHomeAutoScrollCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier_autoscroll];
        if(cell_sutoscroll == nil){
            NSArray *marray = [[NSBundle mainBundle] loadNibNamed:@"EMRecommendAutoScrollCell" owner:self options:nil];
            cell_sutoscroll = [marray objectAtIndex:0];
            [cell_sutoscroll setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        cell_sutoscroll.selectionStyle = UITableViewCellSelectionStyleNone;
        //初始化轮询view
        if (_viewsArray.count > 0 ) {
            [self initAutoScrollView];
            [self initPageControl];
        }
        [cell_sutoscroll.autoScrollView addSubview:_autoScrollView];
        [cell_sutoscroll.autoScrollView addSubview:_pageControl];
        
        return cell_sutoscroll;
    } else {
        //加载广告Cell
        static NSString *CellIdentifier = @"EMADTaskCell";
        EMADTaskCell *cell = (EMADTaskCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil){
            NSArray *marray = [[NSBundle mainBundle] loadNibNamed:@"EMADTaskCell" owner:self options:nil];
            cell = [marray objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        UIColor* color=[EMColorHex getColorWithHexString:@"#FDB2B2"];//通过RGB来定义颜色
        cell.selectedBackgroundView=[[[UIView alloc]initWithFrame:cell.frame]autorelease];
        cell.selectedBackgroundView.backgroundColor=color;

            UIImage *image = [UIImage imageNamed:@"logo.png"];
            [cell.taskIcon setImage:image];
        if (_taskListArray.count > 0 ) {
            NSInteger position = indexPath.row;
            NSDictionary *dic = [_taskListArray objectAtIndex:position - 1];
            NSString *title = [dic objectForKey:@"adTitle"];
            [cell.tableTitle setText:title];
        }
        return cell;
    }
}
#pragma mark 初始化下拉刷新控件
-(void)initPullRefreshView{
    
     _refreshView = [[ODRefreshControl alloc]initInScrollView:self.tableView];
    [_refreshView addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    
}
#pragma mark - 正在刷新
-(void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl{
    [_delegateClass EMDelegateInitTaskList];
    [_delegateClass EMDelegateInitTaskLoop];

}
#pragma mark UIPageControl 点击事件
-(void)onPageControlClickCallback{
    
}
#pragma mark 初始化UIPageControl
-(void)initPageControl{
    if (_pageControl) {
        return;
    }
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.frame = CGRectMake(self.view.frame.size.width / 2, 140, 0, 0);
    _pageControl.numberOfPages = _viewsArray.count;
    _pageControl.currentPage = 0;
    [_pageControl setTintColor:[UIColor redColor]];
}
#pragma mark 初始化轮询广告view
-(void)initAutoScrollView{
    
    if (_autoScrollView) {
        return;
    }
    NSLog(@"初始化轮询广告");
    _autoScrollView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180) animationDuration:2];
    _autoScrollView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        
        return _viewsArray[pageIndex];
    };
    _autoScrollView.totalPagesCount = ^NSInteger(void){
        return _viewsArray.count;
    };
    _autoScrollView.TapActionBlock = ^(NSInteger pageIndex){
        EMAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        delegate.adInfoDicToH5  =  [_taskLoopListArray objectAtIndex:pageIndex];
        [self pushViewControllerWithStorboardName:@"adhtml5" sid:@"adhtml5" hiddenTabBar:YES];
    };
    _autoScrollView.TapChangeBlock = ^(NSInteger pageIndex){

        _pageControl.currentPage = pageIndex;
    };
    
}
- (CGFloat )tableView:(UITableView  *)tableView heightForHeaderInSection:(NSInteger )section{
    //设定分组头部高度
    return 0.1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //这个方法用来告诉表格有几个分组
    return 1;
}
-(void)dealloc{
    [super dealloc];
    [self.tableView release];
    [_viewsArray release];
    [_autoScrollView release];
    [_pageControl release];
    [_taskListArray release];
    [_refreshView release];
    [_taskLoopListArray release];
}


@end
