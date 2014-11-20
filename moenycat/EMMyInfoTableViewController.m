//
//  EMMyInfoTableViewController.m
//  moenycat
//
//  Created by haicuan139 on 14-9-7.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import "EMMyInfoTableViewController.h"
#define ORIGINAL_MAX_WIDTH 640.0f
@interface EMMyInfoTableViewController ()

@end

@implementation EMMyInfoTableViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - init age data
-(void)initAgeData{
    ageArray = [[NSMutableArray alloc]init];
    [ageArray retain];
//    [ageArray addObject:@"10岁以下"];
    for (int i = 10; i <= 40; i++) {
        NSString *ageStr = [NSString stringWithFormat:@"%d岁",i];
        [ageArray addObject:ageStr];
    }
//    [ageArray addObject:@"40岁以上"];
}
-(void)initLocalInfo{
    //昵称，等级，性别，年龄，地址，余额，手机号码，专属链接，二维码
    lableArray = [NSArray arrayWithObjects:@"昵称",@"生日",@"性别",@"余额",@"二维码",@"手机号码",@"专属链接",@"我的地址", nil];
    [lableArray retain];
    baseInfoArray = [NSArray arrayWithObjects:@"昵称",@"性别",@"年龄", nil];
    otherInfoArray = [NSArray arrayWithObjects:@"二维码",@"手机号码",@"专推荐码",@"我的地址", nil];
    [baseInfoArray retain];
    [otherInfoArray retain];
    NSString *nickName = [self getStringValueForKey:CONFIG_KEY_INFO_NICKNAME];
    NSString *gender   = [self getStringValueForKey:CONFIG_KEY_INFO_GENDER];
    NSString *age = [self getStringValueForKey:CONFIG_KEY_INFO_AGE];
    testValue = [NSArray arrayWithObjects:nickName,gender,[age stringByAppendingString:@"岁"],@"Lv.20", nil];
    NSString *tel = [self getStringValueForKey:CONFIG_KEY_INFO_PHONE];
    NSString *rcode = [self getStringValueForKey:CONFIG_KEY_INFO_RECOMMEND_CODE];
    NSString *address = [self getStringValueForKey:CONFIG_KEY_INFO_ADDRESS];
    testValue_1 = [NSArray arrayWithObjects:@"点击查看",tel,rcode, address,nil];
    [testValue retain];
    [testValue_1 retain];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initAgeData];
    [self setTitle:@"我"];
    isPickerShow = NO;
    _tableView.dataSource  = self;
    _tableView.delegate    = self;
    UIButton *right = [[UIButton alloc]init];
    [right addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    right.frame = CGRectMake(0, 0, 45, 20);
    [right setTitle:@"保存" forState:UIControlStateNormal];
    [right setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    right.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *ritem = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = ritem;
}

-(void)rightItemClick{
    NSLog(@"保存个人信息");
    //将UIImage 保存到本地
    if (headerImage) {
        NSArray  *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *path=[paths        objectAtIndex:0];
        NSString *savedImagePath=[path stringByAppendingPathComponent:@"headerImage.jpg"];
        if ([self writeImage:headerImage toFileAtPath:savedImagePath]) {
            NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
            [d setObject:savedImagePath forKey:CONFIG_KEY_LOCAL_HIPATH];
            NSLog(@"保存头像的路径:%@",savedImagePath);
        } else {
            NSLog(@"保存头像出错!");
        }
    }
    //如果个人信息的内容都不为空

        NSString *nickName  = [self getStringValueForKey:CONFIG_KEY_INFO_NICKNAME];
        NSString *address   = [self getStringValueForKey:CONFIG_KEY_INFO_ADDRESS];
        NSString *gender    = [self getStringValueForKey:CONFIG_KEY_INFO_GENDER];
        NSString *age       = [self getStringValueForKey:CONFIG_KEY_INFO_AGE];
    if (nickName.length > 0 && address.length >0 && gender.length > 0 && age.length > 0) {
        EMDelegateClass *delegate = [[EMDelegateClass alloc]init];
        delegate.rootView = self.view;
        delegate.delegate = self;
        [delegate EMDelegatePostMyInfo];//提交个人信息
    } else {
        [FVCustomAlertView showDefaultWarningAlertOnView:self.view withTitle:@"信息不完整"];
    }
    
}
-(void)onMyInfoUpdateDoneToServer{

}
-(void)initBaseLeftItem{

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //这个方法用来告诉表格有几个分组
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //这个方法告诉表格第section个分组有多少行
    int number = 0;
    if (section == 0) {
        number = 1;
    }else if(section == 1){
        number = 1;
       
    }else if(section == 2){
        number = 3;
        
    }else if(section == 3){
        number = 4;
        
    }
    return number;
}
- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int cellH = 43;
    NSInteger index = [indexPath section];
    if (index == 0) {
        cellH = 80;
    }else if (index == 1){
        cellH = 43;
    }
    return cellH;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self onItemClickNSIndexPath:indexPath];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = [indexPath row];
    NSInteger section = [indexPath section];
    static NSString *CellIdentifier = @"EMMyInfoHeaderIconCell";
    EMMyInfoHeaderIconCell *cell = (EMMyInfoHeaderIconCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        NSArray *marray = [[NSBundle mainBundle] loadNibNamed:@"EMMyInfoHeaderIconCell" owner:self options:nil];
        cell = [marray objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    UIColor* color=[EMColorHex getColorWithHexString:@"#FDB2B2"];//通过RGB来定义颜色
    cell.selectedBackgroundView=[[[UIView alloc]initWithFrame:cell.frame]autorelease];
    cell.selectedBackgroundView.backgroundColor=color;
    [cell.headerIcon.layer setMasksToBounds:YES];
    [cell.headerIcon.layer setCornerRadius:5.0];
    //如果有本地图片
        NSString *url = [self getStringValueForKey:CONFIG_KEY_INFO_HEADER_URL];
        NSURL *hur = [NSURL URLWithString:url];
        [cell.headerIcon setImageWithURL:hur placeholderImage:[UIImage imageNamed:@"test_headimage3.jpg"]];
    //加载刚刚选择的图片
    if (headerImage) {
        [cell.headerIcon setImage:headerImage];
    }
    static NSString *CellIdentifier_1 = @"EMMyInfoLableTableViewCell";
    EMMyInfoLableTableViewCell *cell_1 = (EMMyInfoLableTableViewCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier_1];
    if(cell_1 == nil){
        NSArray *marray = [[NSBundle mainBundle] loadNibNamed:@"EMMyInfoLableTableViewCell" owner:self options:nil];
        cell_1 = [marray objectAtIndex:0];
        [cell_1 setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    cell_1.selectedBackgroundView=[[[UIView alloc]initWithFrame:cell.frame]autorelease];
    cell_1.selectedBackgroundView.backgroundColor=color;

    if (section == 1) {
     //余额分组
        NSInteger intBalance = [[self getStringValueForKey:CONFIG_KEY_LOCAL_BALANCE] integerValue];
        NSString *balance = [[NSString alloc]initWithFormat:@"%ld喵币",(long)intBalance];
        cell_1.itemLable.text = @"余额";
        cell_1.itemContent.text = balance;
    } else if (section == 2){
        cell_1.itemLable.text = baseInfoArray[index];
        cell_1.itemContent.text = testValue[index];
    } else if (section == 3){
        cell_1.itemLable.text = otherInfoArray[index];
                cell_1.itemContent.text = testValue_1[index];
    }
    if (section == 0) {
        return cell;
    }else{
        return cell_1;
    }

}
#pragma mark - onItemClick
-(void)onItemClickNSIndexPath:(NSIndexPath *)indexPath{
    EMAppDelegate *app = [[UIApplication sharedApplication] delegate];
    //条目点击事件
    NSInteger index = [indexPath row];
    NSInteger section = [indexPath section];
    if (section == 0) {
                    [self startOutAnimation];
        NSLog(@"头像选择");
        [self initHeaderSelectView];
    } else if(section == 1){
        [self startOutAnimation];
        //收支明细
            [self pushViewControllerWithStorboardName:@"mingxi" sid:@"EMMingXiViewController" hiddenTabBar:NO];
    } else if (section == 2){
        if (index == 0){
            [self startOutAnimation];
            //编辑昵称
            app.editViewDefaultValue = [testValue objectAtIndex:index];
            app.editViewType = CONFIG_KEY_INFO_NICKNAME;
            [self pushViewControllerWithStorboardName:@"edit" sid:@"EMEditIViewController" hiddenTabBar:NO];
        } else if (index == 1){
            [self startOutAnimation];
            //性别
            [self initGenderSheet];
            NSLog(@"性别");
        } else if (index == 2){
            //选择年龄
            NSLog(@"年龄");
            if (!isPickerShow) {
                [self initPickerView];
            }else{
                [self startOutAnimation];
            }
        }
    } else if (section == 3) {
        [self startOutAnimation];
        if (index == 0) {
            //二维码界面
            NSLog(@"二维码界面");
            [self showQrCodeImage];
        } else if (index == 1){
            
            //绑定手机号码界面
            NSLog(@"绑定手机号码界面");
        } else if (index == 2) {
            //复制专属链接到剪切板
            NSLog(@"专属链接");
        } else if (index == 3){
            //编辑我的地址
            NSLog(@"编辑我的地址");
            app.editViewDefaultValue = [testValue_1 objectAtIndex:index];
            app.editViewType = CONFIG_KEY_INFO_ADDRESS;
                [self pushViewControllerWithStorboardName:@"edit" sid:@"EMEditIViewController" hiddenTabBar:NO];
        }
    }

}
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 0) {
        
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
                }
            }
        } else if (actionSheet.tag == 1){
            if (buttonIndex == 0) {
                [self setStringValueForKey:CONFIG_KEY_INFO_GENDER val:@"男"];
            }else{
                [self setStringValueForKey:CONFIG_KEY_INFO_GENDER val:@"女"];
            }
            [self initLocalInfo];
            [_tableView reloadData];
        }
}
#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage{
    headerImage = editedImage;
    [_tableView reloadData];
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"View消失");
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            NSLog(@"imagePickerController");
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}
-(void)initGenderSheet{
    //初始化头像选择View
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"男", @"女",nil];
        choiceSheet.tag = 1;
    [choiceSheet showInView:self.view];
}
-(void)initHeaderSelectView{
    //初始化头像选择View
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    choiceSheet.tag = 0;
    [choiceSheet showInView:self.view];
}
- (void)initPickerView{
    _pickParentView = [[UIView alloc]init];
    _pickParentView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 216 + 44);
    _pickParentView.backgroundColor = [UIColor colorWithRed:0.466 green:0.466 blue:0.466 alpha:0.8];
    //初始化年龄选择
    _pickView = [[UIPickerView alloc]init];
    _pickView.frame = CGRectMake(0, 44,self.view.frame.size.width , 216);
    _pickView.backgroundColor = [UIColor whiteColor];
    _pickView.showsSelectionIndicator = YES;
    _pickView.dataSource   = self;
    _pickView.delegate     = self;
    [_pickView selectRow:10 inComponent:0 animated:YES];
    UIToolbar *toolBar = [[UIToolbar alloc]init];
    toolBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    toolBar.backgroundColor = [UIColor whiteColor];
    //添加button
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(pickLeftItemClick)];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickRightItemClick)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSMutableArray *items = [NSMutableArray array];
    [items addObject:left];
    [items addObject:space];
    [items addObject:right];
    [toolBar setItems:items animated:YES];
    [_pickParentView addSubview:toolBar];
    [_pickParentView addSubview:_pickView];
    [self.view addSubview:_pickParentView];
    [self startInAnimation];
}
-(void)pickLeftItemClick{
    NSLog(@"cancel");
    [self startOutAnimation];
}
-(void)pickRightItemClick{
    [self startOutAnimation];
    NSInteger row = [_pickView selectedRowInComponent:0];
    NSString *selectAge = [ageArray objectAtIndex:row];
    NSMutableString *s = [[NSMutableString alloc]initWithString:selectAge];
    [s deleteCharactersInRange:[s rangeOfString:@"岁"]];
    [self setStringValueForKey:CONFIG_KEY_INFO_AGE val:s];
    NSLog(@"done :%@",s);
    [self initLocalInfo];
    [_tableView reloadData];
}
-(void)startInAnimation{
    //开启动画
    if (!isPickerShow) {
        isPickerShow = YES;
        _pickParentView.transform = CGAffineTransformIdentity;
        [UIView beginAnimations:nil context:nil];
        _pickParentView.frame = CGRectMake(0, self.view.frame.size.height - 216, self.view.frame.size.height, 216 + 44);
        [UIView commitAnimations];
    }
}
-(void)startOutAnimation{
    //开启动画
    if (_pickParentView && isPickerShow) {
        _pickParentView.transform = CGAffineTransformIdentity;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationStopSelector)];
        _pickParentView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.height, 216 + 44);
        [UIView commitAnimations];
        isPickerShow = NO;
    }
}
-(void)animationStopSelector{
    NSLog(@"动画停止");
    [_pickParentView removeFromSuperview];
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 200;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSLog(@"当前:%ld",(long)row);
    return [ageArray objectAtIndex:row];
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return ageArray.count;
}
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (void)dealloc {
    [_tableView release];
    [lableArray release];
    [baseInfoArray release];
    [otherInfoArray release];
    [testValue release];
    [testValue_1 release];
    [_pickView release];
    [_pickParentView release];
    [ageArray release];
    [super dealloc];
}
-(void)showQrCodeImage{
    [self pushViewControllerWithStorboardName:@"qrcode" sid:@"qrcode" hiddenTabBar:NO];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initLocalInfo];
    [_tableView reloadData];
}
@end
