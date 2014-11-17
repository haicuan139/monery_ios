//
//  EMHomeViewController.m
//  moenycat
//
//  Created by haicuan139 on 14-8-25.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import "EMHomeViewController.h"

@interface EMHomeViewController ()

@end

@implementation EMHomeViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)initTabView{
    //初始化UITableView
    _tableView = [[UITableView alloc]init];
    _tableView.frame = CGRectMake(0, autoScrollViewH + _tableViewOffest, self.view.frame.size.width, self.view.frame.size.height);
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.scrollEnabled = NO;
    [_baseScrollView addSubview:_tableView];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSUInteger index = [indexPath row];
    [self onItemClick:index];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableViewT cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EMADInfoCellID";
    EMADInfoCell *cell = (EMADInfoCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        NSArray *marray = [[NSBundle mainBundle] loadNibNamed:@"EMADInfoCell" owner:self options:nil];
        cell = [marray objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
     UIColor* color=[EMColorHex getColorWithHexString:@"#FDB2B2"];//通过RGB来定义颜色
     cell.selectedBackgroundView=[[[UIView alloc]initWithFrame:cell.frame]autorelease];
     cell.selectedBackgroundView.backgroundColor=color;
        UIImage *image = [UIImage imageNamed:@"adtest4.png"];
    [cell.adIconImageView setImage:image];

	return cell;
}
-(void)onItemClick:(NSUInteger)itemIndex{

    [self pushViewControllerWithStorboardName:@"adhtml5" sid:@"adhtml5" hiddenTabBar:YES];

}
- (void)initAutoScrollView{
     _baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _baseScrollView.delegate = self;
//    _baseScrollView.backgroundColor = [self getColorWithHexString:@"#F6F8F9"];
    _baseScrollView.backgroundColor = [UIColor whiteColor];
    _baseScrollView.pagingEnabled = YES;
    _baseScrollView.showsVerticalScrollIndicator = NO;
    _baseScrollView.showsHorizontalScrollIndicator = NO;
    _baseScrollView.pagingEnabled = NO;

    CGSize newSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    [_baseScrollView setContentSize:newSize];
        [self.view addSubview:_baseScrollView];
    NSMutableArray *viewsArray = [@[] mutableCopy];

    NSArray *array = [[NSArray alloc]initWithObjects:@"adtest1.png",@"adtest2.png",@"adtest3.png",@"adtest4.png",@"adtest5.png", nil];
    for (int i = 0; i < 5; ++i) {
        UIImage *image = [UIImage imageNamed:array[i]];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        [viewsArray addObject:imageView];
    }
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.frame = CGRectMake(self.view.frame.size.width / 2, autoScrollViewH - 10, 0, 0);
    pageControl.numberOfPages = 5;
    pageControl.currentPage = 0;
//    pageControl.currentPageIndicatorTintColor = [self getColorWithHexString:@"#ad1524"];
    [pageControl addTarget:self action:@selector(onPageControlClickCallback) forControlEvents:UIControlEventValueChanged];
    self.mainScorllView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, autoScrollViewH) animationDuration:2];
    [self.mainScorllView addSubview:pageControl];
    self.mainScorllView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.1];
    
    self.mainScorllView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){

        return viewsArray[pageIndex];
    };
    self.mainScorllView.totalPagesCount = ^NSInteger(void){
        return 5;
    };
    self.mainScorllView.TapActionBlock = ^(NSInteger pageIndex){
//                    NSLog(@"点击了第%d个%d",pageIndex);
    };
    self.mainScorllView.TapChangeBlock = ^(NSInteger pageIndex){
        pageControl.currentPage = pageIndex;
    };
    [_baseScrollView addSubview:self.mainScorllView];
}

-(void)onPageControlClickCallback{
    //失效
    NSLog(@"onPageClick");
}
- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CGSize s = CGSizeMake(self.view.frame.size.width, (30 * 30) - 40);
    [_baseScrollView setContentSize:s];
    return 30;
}
-(void)initPullToRefresh{
    //初始化下拉刷新控件
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.frame = CGRectMake(self.view.frame.size.width/2, 0, 0, 0);
    [_refreshControl addTarget:self action:@selector(onPullRefreshCallBack:) forControlEvents:UIControlEventValueChanged];
    [_baseScrollView addSubview:_refreshControl];
}
-(void)onPullRefreshCallBack:(UIRefreshControl *)refresh{
    if (self.refreshControl.refreshing) {
        //添加新的模拟数据
        NSDate *date = [[NSDate alloc] init];
        //模拟请求完成之后，回调方法callBackMethod
        [self performSelector:@selector(onPullDoneCallBack:) withObject:date afterDelay:3];
    }
        NSLog(@"正在刷新");
}
- (void)onPullDoneCallBack:(id)obj{
    [self.refreshControl endRefreshing];
    NSLog(@"刷新完成");
    //    [self.tableView reloadData];
//    UIImage *image = [UIImage imageNamed:@"rating_full.png"];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    autoScrollViewH = 150;
    tabCellHeight = 30;
    _tableViewOffest = 40;
    [self initAutoScrollView];
    [self initPullToRefresh];
    [self initTabView];
    [self initTitleItem];
    [self initHeaderView];
}
//废弃的方法
-(void)setHeaderViewGone:(BOOL)hidden{
    if (hidden) {
        self.headerView.hidden = YES;
        _tableView.frame = CGRectMake(0, autoScrollViewH, self.view.frame.size.width, self.view.frame.size.height);
    }else{
        self.headerView.hidden = NO;
        _tableView.frame = CGRectMake(0, autoScrollViewH + _tableViewOffest, self.view.frame.size.width, self.view.frame.size.height);
    }
}
-(void)initTitleItem{

    UIBarButtonItem* left = [self getLeftItem];
    self.navigationItem.leftBarButtonItem = left;
    [left release];
}
-(void)initHeaderView{
    CGRect frame = CGRectMake(0, 150, self.view.frame.size.width, 42);
    
    [_baseScrollView addSubview:[self getMyInfoHeaderView:frame]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
