//
//  ZKProfileController.m
//  掌上科大
//
//  Created by 樊樊帅 on 6/27/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKProfileController.h"
#import "ZKTableViewCell.h"
#import "ZKTableViewCellModel.h"
#import <BmobSDK/Bmob.h>
#import "ZKSignEditController.h"
#import "ZKNavController.h"
#import "ZKTableViewSectionModel.h"

@interface ZKProfileController()

@property (nonatomic, strong) NSArray *infoList;

@end

@implementation ZKProfileController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"个人资料";
    
    //拿到用户信息
    BmobUser *user = [BmobUser getCurrentUser];
    NSLog(@"%@", user);
    //得到用户姓名
    NSString *userName = [user objectForKey:@"name"];
    //得到用户学院
    NSString *userCollege = [user objectForKey:@"college"];
    //得到用户专业
    NSString *userMajor = [user objectForKey:@"major"];
    //得到用户年级
    NSString *userPeriod = [user objectForKey:@"period"];
    
    ZKTableViewCellModel *name = [ZKTableViewCellModel tableViewCellModelWith:@"姓名" detailTextLable:userName];
    ZKTableViewCellModel *college = [ZKTableViewCellModel tableViewCellModelWith:@"学院" detailTextLable:userCollege];
    ZKTableViewCellModel *major = [ZKTableViewCellModel tableViewCellModelWith:@"专业" detailTextLable:userMajor];
    ZKTableViewCellModel *period = [ZKTableViewCellModel tableViewCellModelWith:@"年级" detailTextLable:userPeriod];
    ZKTableViewCellModel *sign = [ZKTableViewCellModel tableViewCellModelWith:@"编辑个性签名" showArrow:YES destinationVc:[[ZKSignEditController alloc] init]];
    
    NSArray *cellModels = @[name, college, major, period, sign];
    
    ZKTableViewSectionModel *sectionModel = [ZKTableViewSectionModel sectionWithCellModels:cellModels header:nil footer:nil];
    
    self.sectionList = @[sectionModel];
    
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    self.tableView.scrollEnabled = NO;
}

@end
