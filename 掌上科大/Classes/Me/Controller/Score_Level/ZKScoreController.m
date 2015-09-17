//
//  ZKScoreController.m
//  掌上科大
//
//  Created by 樊樊帅 on 6/28/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKScoreController.h"
#import "ZKTableViewCellModel.h"
#import "ZKTableViewSectionModel.h"
#import <BmobSDK/Bmob.h>

@implementation ZKScoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"积分查看";
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    self.tableView.scrollEnabled = NO;
    
    BmobUser *user = [BmobUser getCurrentUser];
    NSNumber *userScore = [user objectForKey:@"score"];
    
    ZKTableViewCellModel *score = [ZKTableViewCellModel tableViewCellModelWith:@"当前积分" detailTextLable:[NSString stringWithFormat:@"%@", userScore]];
    
    NSArray *cellModels = @[score];
    
    ZKTableViewSectionModel *section = [ZKTableViewSectionModel sectionWithCellModels:cellModels header:nil footer:@"每日签到可获取积分,积分可以提升等级"];
    
    self.sectionList = @[section];
}

@end
