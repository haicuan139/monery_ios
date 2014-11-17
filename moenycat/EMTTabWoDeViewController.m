//
//  EMTTabWoDeViewController.m
//  moenycat
//
//  Created by haicuan139 on 14-8-25.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import "EMTTabWoDeViewController.h"

@interface EMTTabWoDeViewController ()

@end

@implementation EMTTabWoDeViewController

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
    // Do any additional setup after loading the view.
    _myinfoTableView.delegate = self;
    _myinfoTableView.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //这个方法用来告诉表格有几个分组
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //这个方法告诉表格第section个分组有多少行
    int number = 0;
    if (section == 0) {
        number = 1;
    }else if(section == 1){
        number = 3;
    }

    return number;
}
- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int cellH = 0;
    int index = [indexPath section];
    NSLog(@"index:%d",index);
    if (index == 0) {
        cellH = 80;
    }else if (index == 1){
        cellH = 43;
    }
    return cellH;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_myinfoTableView deselectRowAtIndexPath:indexPath animated:NO];
    [self onItemClickNSIndexPath:indexPath];
    
}
-(void)onItemClickNSIndexPath:(NSIndexPath *)indexPath{
    int  index =  [indexPath row];
    int  section = [indexPath section];
    if (section == 0) {
        if (index == 0) {
            //跳转我的个人信息
            [self pushViewControllerWithStorboardName:@"myinfo" sid:@"EMMyInfoTableViewController" hiddenTabBar:YES];
        }
    }else if (section == 1){
        if (index == 0) {
            //我的广告
            [self pushViewControllerWithStorboardName:@"myad" sid:@"EMMyAdListTableViewController" hiddenTabBar:YES];
        }else if (index == 1){
        //我要提现
            [self pushViewControllerWithStorboardName:@"tixian" sid:@"EMTiXianTableViewController" hiddenTabBar:YES];
    }else if (index == 2){
        //超值兑换
        [self pushViewControllerWithStorboardName:@"duihuan" sid:@"EMDuiHuanTableViewController" hiddenTabBar:YES];
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"EMTABWodeInfoHeader";
    EMTABWodeInfoHeader *cell = (EMTABWodeInfoHeader *)[_myinfoTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        NSArray *marray = [[NSBundle mainBundle] loadNibNamed:@"EMTABWodeInfoHeader" owner:self options:nil];
        cell = [marray objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    UIColor* color=[EMColorHex getColorWithHexString:@"#FDB2B2"];//通过RGB来定义颜色
    cell.selectedBackgroundView=[[[UIView alloc]initWithFrame:cell.frame]autorelease];
    cell.selectedBackgroundView.backgroundColor=color;
    UIImage *image = [UIImage imageNamed:@"test_headimage3.jpg"];
    [cell.tabHeaderIcon.layer setMasksToBounds:YES];
    [cell.tabHeaderIcon.layer setCornerRadius:5.0];
    //如果有本地图片
   
        NSString *hurl = [self getStringValueForKey:CONFIG_KEY_INFO_HEADER_URL];
        NSURL *url = [NSURL URLWithString:hurl];
        [cell.tabHeaderIcon setImageWithURL:url placeholderImage:image];
    
    NSString *nickName = [self getStringValueForKey:CONFIG_KEY_INFO_NICKNAME];
    NSString *tel      = [self getStringValueForKey:CONFIG_KEY_INFO_PHONE];
    NSString *gender   = [self getStringValueForKey:CONFIG_KEY_INFO_GENDER];
    NSString *age      = [self getStringValueForKey:CONFIG_KEY_INFO_AGE];
    NSString *address  = [self getStringValueForKey:CONFIG_KEY_INFO_ADDRESS];
    NSString *lineStr = [[NSString alloc]initWithFormat:@"%@ %@岁 %@",gender,   age ,address];
    [cell.tabHeaderNickLable setText:nickName];
    [cell.tabHeaderTelLable setText:tel];
    [cell.tabHeaderBaseInfoLable setText:lineStr];
    //第二组cell
    static NSString *CellIdentifier_1 = @"EMTableListCell";
    EMTableListCell *cell_1 = (EMTableListCell *)[_myinfoTableView dequeueReusableCellWithIdentifier:CellIdentifier_1];
    if(cell_1 == nil){
        NSArray *marray = [[NSBundle mainBundle] loadNibNamed:@"EMTableListCell" owner:self options:nil];
        cell_1 = [marray objectAtIndex:0];
        [cell_1 setSelectionStyle:UITableViewCellSelectionStyleGray];
    }

    cell_1.selectedBackgroundView=[[[UIView alloc]initWithFrame:cell.frame]autorelease];
    cell_1.selectedBackgroundView.backgroundColor=color;

    NSString* imageName = @"";
    NSString* lableText = @"";
        int index = [indexPath row];
    int indexSection = [indexPath section];
    if (index == 0) {
        imageName = @"wodeguanggao.png";
        lableText = @"我的广告";
    }else if (index == 1){
                lableText = @"我要提现";
        imageName = @"woyaotixian.png";
    }else if (index == 2){
                lableText = @"超值兑换";
                imageName = @"chaozhiduihuan.png";
    }
    UIImage* iconImage = [UIImage imageNamed:imageName];
    [cell_1.itemIcon setImage:iconImage];
    cell_1.itemLable.text = lableText;
    if (indexSection == 0) {
        return cell;
    }else{
        return cell_1;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_myinfoTableView reloadData];
}
- (void)dealloc {
    [_myinfoTableView release];
    [super dealloc];
}
@end
