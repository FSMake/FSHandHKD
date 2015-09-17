//
//  ZKLevelController.m
//  掌上科大
//
//  Created by 樊樊帅 on 6/28/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKLevelController.h"
#import "ZKTableViewCellModel.h"
#import "ZKTableViewSectionModel.h"
#import <BmobSDK/Bmob.h>

@implementation ZKLevelController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    self.tableView.scrollEnabled = NO;
    self.navigationItem.title = @"我的等级";
    
    BmobUser *user = [BmobUser getCurrentUser];
    NSNumber *userLevel = [user objectForKey:@"level"];
    
    ZKTableViewCellModel *level = [ZKTableViewCellModel tableViewCellModelWith:@"当前等级" detailTextLable:[NSString stringWithFormat:@"Lev %@", userLevel]];
    
    NSArray *cellModels = @[level];
    
    ZKTableViewSectionModel *section = [ZKTableViewSectionModel sectionWithCellModels:cellModels header:nil footer:@"提升等级可以获得更多权限"];
    
    self.sectionList = @[section];
}

@end
