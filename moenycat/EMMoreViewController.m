//
//  EMMoreViewController.m
//  moenycat
//
//  Created by haicuan139 on 14-8-25.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import "EMMoreViewController.h"

@interface EMMoreViewController ()

@end

@implementation EMMoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //这个方法用来告诉表格有几个分组
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //这个方法告诉表格第section个分组有多少行
    int number = 0;
    if (section == 0) {
        number = 4;
    }else if(section == 1){
        number = 2;
    }
    
    return number;
}
- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 44;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_moreTableView deselectRowAtIndexPath:indexPath animated:NO];
    [self onItemClickNSIndexPath:indexPath];
    
}
-(void)onItemClickNSIndexPath:(NSIndexPath *)indexPath{
    

    int index = [indexPath row];
    int section = [indexPath section];
    if (section == 0) {
        if (index == 0) {
            //安全信息
            if ([self getBoolValueForKey:CONFIG_KEY_BIND_FLG]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已经绑定过!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {

                }];
            } else {
                [self pushViewControllerWithStorboardName:@"bind_input" sid:@"bind" hiddenTabBar:YES];
                
            }
        }else if (index == 1){
            //关于我们
            [self setStringValueForKey:CONFIG_KEY_WEB_TYPE val:@"关于我们"];
            [self pushViewControllerWithStorboardName:@"about" sid:@"about" hiddenTabBar:YES];
        }else if (index == 2){
            //意见反馈
            [self pushViewControllerWithStorboardName:@"feedback" sid:@"feedback" hiddenTabBar:YES];
        }else if (index == 3){
            //消息中心
            [self pushViewControllerWithStorboardName:@"messagelist" sid:@"messagelist" hiddenTabBar:YES];
        } 
    } else if (section == 1){
        if (index == 0) {

                        [self setStringValueForKey:CONFIG_KEY_WEB_TYPE val:@"商务合作"];
            [self pushViewControllerWithStorboardName:@"about" sid:@"about" hiddenTabBar:YES];
        } else if (index == 1){
                                    [self setStringValueForKey:CONFIG_KEY_WEB_TYPE val:@"版本信息"];
            [self pushViewControllerWithStorboardName:@"about" sid:@"about" hiddenTabBar:YES];
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    int index = [indexPath row];
    int indexSection = [indexPath section];
    static NSString *CellIdentifier = @"EMMoreItemCell";
    EMMoreItemCell *cell = (EMMoreItemCell *)[_moreTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        NSArray *marray = [[NSBundle mainBundle] loadNibNamed:@"EMMoreItemCell" owner:self options:nil];
        cell = [marray objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    UIColor* color=[EMColorHex getColorWithHexString:@"#FDB2B2"];//通过RGB来定义颜色
    cell.selectedBackgroundView=[[[UIView alloc]initWithFrame:cell.frame]autorelease];
    cell.selectedBackgroundView.backgroundColor=color;

    //第二组cell
    static NSString *CellIdentifier_1 = @"EMMoreSoundOffCell";
    EMMoreSoundOffCell *cell_1 = (EMMoreSoundOffCell *)[_moreTableView dequeueReusableCellWithIdentifier:CellIdentifier_1];
    if(cell_1 == nil){
        NSArray *marray = [[NSBundle mainBundle] loadNibNamed:@"EMMoreSoundOffCell" owner:self options:nil];
        cell_1 = [marray objectAtIndex:0];
        [cell_1 setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    cell_1.selectedBackgroundView=[[[UIView alloc]initWithFrame:cell.frame]autorelease];
    cell_1.selectedBackgroundView.backgroundColor=color;
    

    if (indexSection == 0) {
        cell.itemLable.text = moreItemArray[index];
        return cell;
    }else{
        cell_1.itemLable.text = moreItemArray_sound[index];
        return cell_1;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _moreTableView.dataSource = self;
    _moreTableView.delegate = self;
    //init array
    moreItemArray = [NSArray arrayWithObjects:@"安全信息",@"关于我们",@"意见反馈",@"消息中心", nil];
    [moreItemArray retain];
    moreItemArray_sound = [NSArray arrayWithObjects:@"商务合作",@"版本信息", nil];
    [moreItemArray_sound retain];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    [_moreTableView release];
    [moreItemArray release];
    [moreItemArray_sound release];
    [super dealloc];
}
@end
