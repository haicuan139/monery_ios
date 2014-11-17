//
//  EMMyInfoTableViewController.h
//  moenycat
//
//  Created by haicuan139 on 14-9-7.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMBaseViewController.h"
#import "EMMyInfoHeaderIconCell.h"
#import "EMMyInfoLableTableViewCell.h"
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "SDWebImage/UIImageView+WebCache.h"
#import "FVCustomAlertView/FVCustomAlertView.h"
#import "EMAppDelegate.h"
@interface EMMyInfoTableViewController : EMBaseViewController <UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, VPImageCropperDelegate , UIPickerViewDataSource,UIPickerViewDelegate , EMDelegate>{
    
    NSArray *lableArray;
    NSArray *baseInfoArray;
    NSArray *otherInfoArray;
    NSArray *testValue;
    NSArray *testValue_1;
    UIImage *headerImage;
    NSMutableArray *ageArray;
    BOOL isPickerShow;
}

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) UIPickerView *pickView;
@property (retain, nonatomic) UIView *pickParentView;
-(void)initHeaderSelectView;
-(void)initAgeData;
-(BOOL)isPhotoLibraryAvailable;
-(void)initGenderSheet;
-(void)initPickerView;
-(void)pickLeftItemClick;
-(void)pickRightItemClick;
-(void)startInAnimation;
-(void)startOutAnimation;
-(void)animationStopSelector;
-(void)initLocalInfo;
-(void)showQrCodeImage;
@end
