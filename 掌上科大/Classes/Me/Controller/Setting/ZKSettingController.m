//
//  ZKSettingController.m
//  掌上科大
//
//  Created by 樊樊帅 on 6/26/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKSettingController.h"
#import "ZKTableViewCellModel.h"
#import "ZKTableViewCell.h"
#import "MBProgressHUD+MJ.h"
#import <BmobSDK/Bmob.h>
#import "ZKLoginController.h"
#import "ZKConnectMeController.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "UMSocial.h"
#import "ZKFeedbackController.h"

@interface ZKSettingController () <UMSocialUIDelegate>


@property (nonatomic, strong) NSArray *cellList;

@end

@implementation ZKSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.backgroundColor = randomColor;
    self.navigationItem.title = @"设置";
    //清除缓存
    ZKTableViewCellModel *clearCache = [ZKTableViewCellModel tableViewCellModelWith:@"清除缓存" showArrow:NO destinationVc:nil];
    clearCache.option = ^() {
        [MBProgressHUD showMessage:@"正在清除缓存"];
        SDWebImageManager *mgr = [SDWebImageManager sharedManager];
        [mgr.imageCache clearMemory];
        [mgr.imageCache cleanDiskWithCompletionBlock:^{
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].windows lastObject]];
            [MBProgressHUD showSuccess:@"缓存清除完毕"];
        }];
    };
    
    //推荐给好友
    ZKTableViewCellModel *callFriend = [ZKTableViewCellModel tableViewCellModelWith:@"推荐给好友" showArrow:NO destinationVc:nil];
    __weak ZKSettingController *Vc = self;
    callFriend.option = ^(){
        [UMSocialSnsService presentSnsIconSheetView:Vc
                                             appKey:nil
                                          shareText:@"掌上科大推荐给大家"
                                         shareImage:[UIImage imageNamed:@"icon.png"]
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina, UMShareToTencent,UMShareToRenren, UMShareToWechatFavorite, UMShareToWechatSession, UMShareToWechatTimeline, nil]
                                           delegate:Vc];

    };
    
    //联系我们
    ZKConnectMeController *connectMeVc = [[ZKConnectMeController alloc] initWithStyle:UITableViewStyleGrouped];
    ZKTableViewCellModel *connectUs = [ZKTableViewCellModel tableViewCellModelWith:@"联系我们" showArrow:YES destinationVc:connectMeVc];
    
    //意见反馈
    ZKTableViewCellModel *ideaBack = [ZKTableViewCellModel tableViewCellModelWith:@"意见反馈" showArrow:YES destinationVc:[[ZKFeedbackController alloc] init]];
    
    
    self.cellList = @[clearCache, callFriend, connectUs, ideaBack];
    
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    self.tableView.scrollEnabled = NO;
    
    [self setupLogOutBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZKTableViewCell *cell = [ZKTableViewCell cellWithTableView:tableView];
    

    ZKTableViewCellModel *model = self.cellList[indexPath.row];
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZKTableViewCellModel *model = self.cellList[indexPath.row];
    if (model.destinationVc) {
        [self.navigationController pushViewController:model.destinationVc animated:YES];
    }
    
    if (model.option) {
        model.option();
    }
}

#pragma mark - event response
- (void)logout {
    [BmobUser logout];
    ZKLoginController *loginVc = [[ZKLoginController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = loginVc;
}

#pragma mark - private method
- (void)setupLogOutBtn {
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutBtn.width = 280;
    logoutBtn.height = 30;
    logoutBtn.centerX = self.view.centerX;
    logoutBtn.centerY = self.view.height * 0.9;
    [logoutBtn setBackgroundImage:[UIImage imageNamed:@"logoutBtn"] forState:UIControlStateNormal];
    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:logoutBtn];
}

@end
