//
//  ZKConnectMeController.m
//  掌上科大
//
//  Created by 樊樊帅 on 6/28/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKConnectMeController.h"
#import "ZKTableViewCellModel.h"
#import "ZKTableViewSectionModel.h"


@implementation ZKConnectMeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    self.tableView.scrollEnabled = NO;
    self.navigationItem.title = @"联系作者";
    
    ZKTableViewCellModel *mail = [ZKTableViewCellModel tableViewCellModelWith:@"邮箱" detailTextLable:@"fs_0527@163"];
    
    ZKTableViewCellModel *phone = [ZKTableViewCellModel tableViewCellModelWith:@"电话" detailTextLable:@"157-3793-3683"];
    phone.option = ^(){
        NSURL *url = [NSURL URLWithString:@"telprompt://15539736212"];
        [[UIApplication sharedApplication] openURL:url];
    };
    
    NSArray *cellModels = @[mail, phone];
    
    ZKTableViewSectionModel *section = [ZKTableViewSectionModel sectionWithCellModels:cellModels header:nil footer:nil];
    
    self.sectionList = @[section];
}

@end
