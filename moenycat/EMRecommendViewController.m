//
//  EMRecommendViewController.m
//  moenycat
//
//  Created by haicuan139 on 14-8-25.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import "EMRecommendViewController.h"

@interface EMRecommendViewController ()

@end

@implementation EMRecommendViewController

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
//    [self setHeaderViewGone:YES];
    self.headerView.hidden = YES;
    self.tableView.frame = CGRectMake(0, autoScrollViewH, self.view.frame.size.width, 44 * 10);
    // Do any additional setup after loading the view.
    
}
-(UITableViewCell *)tableView:(UITableView *)tableViewT cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    NSUInteger index = [indexPath row];
    if (index == 0) {
        UIImage *image = [UIImage imageNamed:@"task_sign_item.png"];
        [cell.taskIcon setImage:image];
    } else if (index == 1){
        UIImage *image = [UIImage imageNamed:@"task_wode_myinfo.png"];
        [cell.taskIcon setImage:image];
    } else if (index == 2){
        UIImage *image = [UIImage imageNamed:@"task_wode_recommend.png"];
        [cell.taskIcon setImage:image];
    }else{
        UIImage *image = [UIImage imageNamed:@"task_wode_recommend.png"];
        [cell.taskIcon setImage:image];
    }

//    cell.selectedBackgroundView=[[[UIView alloc]initWithFrame:cell.frame]autorelease];
//    cell.selectedBackgroundView.backgroundColor=color;
//    UIImage *image = [UIImage imageNamed:@"adtest4.png"];
//    [cell.adIconImageView setImage:image];

	return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSUInteger index = [indexPath row];
    [self onItemClick:index];
    
}
-(void)onItemClick:(NSUInteger)itemIndex{
    NSLog(@"点击了ITEM");
}
- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CGSize s = CGSizeMake(self.view.frame.size.width, 44 * 10 + self.mainScorllView.frame.size.height + 88 + 30);
    [self.baseScrollView setContentSize:s];
    return 10;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
