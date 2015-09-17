//
//  ZKMessageController.m
//  掌上科大
//
//  Created by 樊樊帅 on 6/30/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKMessageController.h"
#import "ZKTableViewCellModel.h"
#import "ZKTableViewSectionModel.h"

@interface ZKMessageController ()

@end

@implementation ZKMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    
    self.navigationItem.title = @"信息";
    
    ZKTableViewCellModel *welcome = [ZKTableViewCellModel tableViewCellModelWith:@"感谢您注册掌上科大" detailTextLable:nil];
    
    ZKTableViewSectionModel *section = [ZKTableViewSectionModel sectionWithCellModels:@[welcome] header:@"当前信息" footer:nil];
    
    self.sectionList = @[section];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
