//
//  EMEditIViewController.m
//  moenycat
//
//  Created by haicuan139 on 14-9-7.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import "EMEditIViewController.h"

@interface EMEditIViewController ()

@end

@implementation EMEditIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)cancel{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)saveText{

    //保存信息
    EMEditCell *cell = (EMEditCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    NSString *text = cell.edittext.text;
    if (text.length > 0) {
        EMAppDelegate *de = [[UIApplication sharedApplication] delegate];
        [self setStringValueForKey:de.editViewType val:text];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        //抖动一下
        CAKeyframeAnimation *keyAn = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        [keyAn setDuration:0.5f];
        NSArray *array = [[NSArray alloc] initWithObjects:
                          [NSValue valueWithCGPoint:CGPointMake(cell.edittext.center.x, cell.edittext.center.y)],
                          [NSValue valueWithCGPoint:CGPointMake(cell.edittext.center.x-5, cell.edittext.center.y)],
                          [NSValue valueWithCGPoint:CGPointMake(cell.edittext.center.x+5, cell.edittext.center.y)],
                          [NSValue valueWithCGPoint:CGPointMake(cell.edittext.center.x, cell.edittext.center.y)],
                          [NSValue valueWithCGPoint:CGPointMake(cell.edittext.center.x-5, cell.edittext.center.y)],
                          [NSValue valueWithCGPoint:CGPointMake(cell.edittext.center.x+5, cell.edittext.center.y)],
                          [NSValue valueWithCGPoint:CGPointMake(cell.edittext.center.x, cell.edittext.center.y)],
                          [NSValue valueWithCGPoint:CGPointMake(cell.edittext.center.x-5, cell.edittext.center.y)],
                          [NSValue valueWithCGPoint:CGPointMake(cell.edittext.center.x+5, cell.edittext.center.y)],
                          [NSValue valueWithCGPoint:CGPointMake(cell.edittext.center.x, cell.edittext.center.y)],
                          nil];
        [keyAn setValues:array];
        [array release];
        NSArray *times = [[NSArray alloc] initWithObjects:
                          [NSNumber numberWithFloat:0.1f],
                          [NSNumber numberWithFloat:0.2f],
                          [NSNumber numberWithFloat:0.3f],
                          [NSNumber numberWithFloat:0.4f],
                          [NSNumber numberWithFloat:0.5f],
                          [NSNumber numberWithFloat:0.6f],
                          [NSNumber numberWithFloat:0.7f],
                          [NSNumber numberWithFloat:0.8f],
                          [NSNumber numberWithFloat:0.9f],
                          [NSNumber numberWithFloat:1.0f],
                          nil];
        [keyAn setKeyTimes:times];
        [times release];
        [cell.edittext.layer addAnimation:keyAn forKey:@"TextAnim"];
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"编辑"];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    // Do any additional setup after loading the view.
    UIButton *saveButton = [[UIButton alloc]init];
    saveButton.showsTouchWhenHighlighted = YES;
    [saveButton setTitle:@"确定" forState:UIControlStateNormal];
    saveButton.frame = CGRectMake(0, 0, 45, 20);
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveText) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:saveButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    ////
    UIButton *cancel = [[UIButton alloc]init];
    cancel.showsTouchWhenHighlighted = YES;
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    cancel.frame = CGRectMake(0, 0, 45, 20);
    [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [cancel setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:cancel];
    self.navigationItem.leftBarButtonItem = leftItem;
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //这个方法用来告诉表格有几个分组
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //这个方法告诉表格第section个分组有多少行

    return 1;
}
- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"EMEditCell";
    EMEditCell *cell = (EMEditCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        NSArray *marray = [[NSBundle mainBundle] loadNibNamed:@"EMEditCell" owner:self options:nil];
        cell = [marray objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    EMAppDelegate *de = [[UIApplication sharedApplication] delegate];
    NSString *def = de.editViewDefaultValue;
    [cell.edittext setText:def];
    [cell.edittext becomeFirstResponder];
     cell.edittext.delegate = self;
    [cell.edittext addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    return cell;
}
- (void)textFieldDidChange:(UITextField *)textField{
    EMAppDelegate *de = [[UIApplication sharedApplication] delegate];
    NSString *type = de.editViewType;
    int length = 0; 
    if ([type isEqualToString:CONFIG_KEY_INFO_NICKNAME]) {
        //昵称
        length = 6;
    } else if ([type isEqualToString:CONFIG_KEY_INFO_ADDRESS]){
        length = 25;
    }
    if (textField.text.length > length) {
        textField.text = [textField.text substringToIndex:length];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self saveText];
    
    return YES;
}
-(void)initBaseLeftItem{
    
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
@end
