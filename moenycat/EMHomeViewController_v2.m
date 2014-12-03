//
//  EMHomeViewController_v2.m
//  moenycat
//
//  Created by haicuan139 on 14-10-9.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import "EMHomeViewController_v2.h"

@interface EMHomeViewController_v2 ()

@end

@implementation EMHomeViewController_v2

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark - 检测新版本
-(void)onVersionChange:(NSString *)serverVersionCode content:(NSString *)content title:(NSString *)title dowUrl:(NSString *)downloadUrl{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    if ([serverVersionCode floatValue] > [app_Version floatValue]) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已经有新的版本!需要更新吗!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                //TODO:打开APPSTORE更新,更换为自己的APP序列号
                NSString *str = @"http://fir.im/x9a8/install";
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            }
        }];
    }

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

-(void)onLandScreen{
//    横屏时
    [super onLandScreen];
    NSLog(@"横屏了");

}
#pragma mark viewDidload
- (void)viewDidLoad
{
    [super viewDidLoad];
    //创建头像图片路径
    NSArray  *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    NSString *path=[paths        objectAtIndex:0];
    NSString *savedImagePath=[path stringByAppendingPathComponent:CONFIG_KEY_DEFAULT_HEADER];
    [self setStringValueForKey:CONFIG_KEY_LOCAL_HIPATH val:savedImagePath];
    _emclass = [[EMDelegateClass alloc ]init];
    _emclass.delegate = self;
    _emclass.rootView = self.view;
    _viewsArray = [[NSMutableArray alloc]init];
    _adListArray = [[NSMutableArray alloc]init];
    _adLoopListArray = [[NSMutableArray alloc]init];
    //测试保存设备唯一标识
    KeychainItemWrapper *key = [[KeychainItemWrapper alloc]initWithIdentifier:@"com.emperises.monerycat" accessGroup:nil];
    //检查是否已经存在ID
    NSString *deviceID = [key objectForKey:(id)kSecValueData];
    if ([deviceID hasSuffix:@"ios"]) {
//    if ([deviceID containsString:@"_ios"]) {
        //已经注册过ID
        [self setStringValueForKey:CONFIG_KEY_DEVICEID val:deviceID];
    } else {
        CFUUIDRef puuid = CFUUIDCreate( nil );
        CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
        NSString * result = (NSString *)CFStringCreateCopy( NULL, uuidString);
        NSString *isoID = [result stringByAppendingString:@"_ios"];
        CFRelease(puuid);
        CFRelease(uuidString);
        [key setObject:isoID forKey:(id)kSecValueData];
        [self setStringValueForKey:CONFIG_KEY_DEVICEID val:isoID];
    }


    //检测新版本
    [_emclass EMDelegateUpdateVersion];
    //注册设备
    [_emclass EMDelegateRegDevices];
    //初始化广告列表
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    

    [self.tableView setHidden:YES];
    //添加下拉刷新
    [self initPullRefreshView];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];

}
-(void)onRegDeviceDone{
    [_emclass EMDelegateInitAdlist];
    [_emclass EMDelegateInitAdLooplist];
    [self.tableView reloadData];
}
- (CGFloat )tableView:(UITableView  *)tableView heightForHeaderInSection:(NSInteger )section{
    //设定分组头部高度
    return 0.1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //这个方法用来告诉表格有几个分组
    return 1;
}


//cell高度
- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return  200;
    }
    return 80;
}
//tab数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_adListArray.count > 0 ) {
        return _adListArray.count + 1;
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
    

    if (itemIndex != 0) {        
        EMAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        delegate.adInfoDicToH5  =  [_adListArray objectAtIndex:itemIndex - 1];
        [self pushViewControllerWithStorboardName:@"adhtml5" sid:@"adhtml5" hiddenTabBar:YES];
    } else {
            [self pushViewControllerWithStorboardName:@"myinfo" sid:@"EMMyInfoTableViewController" hiddenTabBar:YES];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableViewT cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    //加载轮询
    if (indexPath.row == 0) {
        static NSString *CellIdentifier_autoscroll = @"EMHomeAutoScrollCell";
        EMHomeAutoScrollCell *cell_sutoscroll = (EMHomeAutoScrollCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier_autoscroll];
        if(cell_sutoscroll == nil){
            NSArray *marray = [[NSBundle mainBundle] loadNibNamed:@"EMHomeAutoScrollCell" owner:self options:nil];
            cell_sutoscroll = [marray objectAtIndex:0];
            [cell_sutoscroll setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        cell_sutoscroll.selectionStyle = UITableViewCellSelectionStyleNone;
        //初始化轮询view
        if (_viewsArray.count > 0) {            
            [self initAutoScrollView];
            [self initPageControl];
        }
        [cell_sutoscroll.autoScrollView addSubview:_autoScrollView];
        [cell_sutoscroll.autoScrollView addSubview:_pageControl];


    return cell_sutoscroll;
    } else {
        //加载广告Cell
        static NSString *CellIdentifier = @"EMADInfoCellID";
        EMADInfoCell *cell = (EMADInfoCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil){
            NSArray *marray = [[NSBundle mainBundle] loadNibNamed:@"EMADInfoCell" owner:self options:nil];
            cell = [marray objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        
        UIColor* color=[EMColorHex getColorWithHexString:@"#FDB2B2"];//通过RGB来定义颜色
        cell.selectedBackgroundView=[[[UIView alloc]initWithFrame:cell.frame]autorelease];
        cell.selectedBackgroundView.backgroundColor=color;

        if(_adListArray.count > 0 ){
            NSInteger position = indexPath.row;
            NSDictionary *dic = [_adListArray objectAtIndex:position - 1];

            NSURL *imageUrl = [NSURL URLWithString:[dic objectForKey:@"adIcon"]];
            [cell.adIconImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"logo.png"]];
            NSString *title = [dic objectForKey:@"adTitle"];
//            NSString *balance = [dic objectForKey:@"adAwardBalance"];
//            NSString *balanceText = [[NSString alloc] initWithFormat:@"剩余:%@喵币",balance];
            NSString *content = [dic objectForKey:@"adContent"];
            NSString *ad_des = [dic objectForKey:@"ad_desc"];
            [cell.adContentLable setText:content];
            [cell.adTitleLable setText:title];
            [cell.adBalanceLable setTitle:ad_des forState:UIControlStateNormal];
            
        }

        return cell;
    }
}
#pragma mark 初始化下拉刷新控件
-(void)initPullRefreshView{
    //
    _odRefreshView = [[ODRefreshControl alloc]initInScrollView:self.tableView];
    [_odRefreshView addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    
}
#pragma mark - 广告列表加载失败
-(void)onAdLisrLoadError{
    [self.tableView setHidden:NO];
    [_odRefreshView endRefreshing];

}
#pragma mark - 刷新中
-(void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl{
    [_emclass EMDelegateInitAdlist];
    [_emclass EMDelegateInitAdLooplist];
    //更新余额
    [_emclass updateBalance];
}
-(void)onBalanceChangeForServer:(NSString *)balance{
    [self.tableView reloadData];
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

    _autoScrollView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180) animationDuration:2];
    _autoScrollView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        
        return _viewsArray[pageIndex];
    };
    _autoScrollView.totalPagesCount = ^NSInteger(void){
        return _viewsArray.count;
    };
    _autoScrollView.TapActionBlock = ^(NSInteger pageIndex){
        EMAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        delegate.adInfoDicToH5  =  [_adLoopListArray objectAtIndex:pageIndex ];
        [self pushViewControllerWithStorboardName:@"adhtml5" sid:@"adhtml5" hiddenTabBar:YES];
    };
    _autoScrollView.TapChangeBlock = ^(NSInteger pageIndex){

        _pageControl.currentPage = pageIndex;
    };
    
}


#pragma mark - 加载列表广告
-(void)onInitAdListForServer:(NSArray *)adList{
    if (adList && adList.count > 0) {
        [_adListArray removeAllObjects];
        //添加到数组
        for (int i = 0; i < adList.count; i++) {

            [_adListArray addObject:[adList objectAtIndex:i]];
        }
        //加载完成reload
        [self.tableView reloadData];
        [self.tableView setHidden:NO];
        double delayInSeconds = 0.5f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [_odRefreshView endRefreshing];
        });
    } else {

    }
}
#pragma mark - 加载焦点图广告
-(void)onInitAdLoopListForServer:(NSArray *)adList{
    if (!adList) {

        return;
    }

    [_viewsArray removeAllObjects];
    [_adLoopListArray removeAllObjects];
    for (int i = 0; i < adList.count; i++) {

        NSDictionary *dic = [adList objectAtIndex:i];
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(0, 0, self.view.frame.size.width,150);
        UIImage *def = [UIImage imageNamed:@"logo.png"];
        //图片地址
        NSURL *url = [NSURL URLWithString:[dic objectForKey:@"adImage"]];
        [imageView setImageWithURL:url placeholderImage:def];
        [_viewsArray addObject:imageView];
        [_adLoopListArray addObject:dic];
    }
    [self.tableView reloadData];
    [self.tableView setHidden:NO];
    //加载完成reload
}
-(void)dealloc{
    [super dealloc];
    [self.tableView release];
    [_viewsArray release];
    [_adListArray release];
    [_autoScrollView release];
    [_pageControl release];
    [_odRefreshView release];
    [_adLoopListArray release];
    [_emclass release];
}
@end
