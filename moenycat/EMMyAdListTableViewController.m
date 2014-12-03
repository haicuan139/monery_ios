//
//  EMMyAdListTableViewController.m
//  moenycat
//
//  Created by haicuan139 on 14-9-7.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import "EMMyAdListTableViewController.h"

@interface EMMyAdListTableViewController ()

@end

@implementation EMMyAdListTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    [self setTitle:@"广告记录"];
    _delegateClass = [[EMDelegateClass alloc]init];
    _delegateClass.rootView = self.view;
    _delegateClass.delegate = self;
    _adlistArray = [[NSMutableArray alloc]init];
    [_delegateClass EMDelegateInitAdlistHistory];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _adlistArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSUInteger index = [indexPath row];
    [self onItemClick:index];
    
}
-(void)initBaseLeftItem{
}
    
-(UITableViewCell *)tableView:(UITableView *)tableViewT cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    if(_adlistArray.count > 0 ){
        NSInteger position = indexPath.row;
        NSDictionary *dic = [_adlistArray objectAtIndex:position];
        NSLog(@"当前position:%ld",(long)position);
        NSURL *imageUrl = [NSURL URLWithString:[dic objectForKey:@"adIcon"]];
        [cell.adIconImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"logo.png"]];
        NSString *title = [dic objectForKey:@"adTitle"];
        NSString *balance = [dic objectForKey:@"adAwardBalance"];
        NSString *balanceText = [[NSString alloc] initWithFormat:@"剩余:%@喵币",balance];
        NSString *content = [dic objectForKey:@"adContent"];
        [cell.adContentLable setText:content];
        [cell.adTitleLable setText:title];
        [cell.adBalanceLable setTitle:balanceText forState:UIControlStateNormal];
        
    }
    
	return cell;
}
-(void)onItemClick:(NSUInteger)itemIndex{
    
//    [self pushViewControllerWithStorboardName:@"adhtml5" sid:@"adhtml5" hiddenTabBar:YES];
    
}
#pragma mark - 广告记录
-(void)onInitMyAdListHistoryForServer:(NSArray *)adList{
    [_adlistArray removeAllObjects];
    for (int i = 0; i < adList.count; i++) {
        NSDictionary *dic = [adList objectAtIndex:i];
        [_adlistArray addObject:dic];
    }
    if (_adlistArray.count == 0) {
        [self.tableView setHidden:YES];
        [FVCustomAlertView showDefaultWarningAlertOnView:self.view withTitle:@"没有记录"];
    }
    [self.tableView reloadData];
}
- (void)dealloc {
    [self.tableView release];
    [_adlistArray release];
    [_delegateClass release];
    [super dealloc];
    
}
@end
