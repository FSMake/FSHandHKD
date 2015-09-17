//
//  ZKTableViewController.m
//  掌上科大
//
//  Created by 樊樊帅 on 6/27/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKTableViewController.h"
#import "ZKTableViewCellModel.h"
#import "ZKTableViewCell.h"
#import "ZKTableViewSectionModel.h"

@interface ZKTableViewController()

@end

@implementation ZKTableViewController

#pragma mark - Life Cycle

#pragma mark - delegate
#pragma mark UITableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ZKTableViewSectionModel *sectionModel = self.sectionList[section];
    return sectionModel.cellModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZKTableViewCell *cell = [ZKTableViewCell cellWithTableView:tableView];
    
    ZKTableViewSectionModel *sectionModel = self.sectionList[indexPath.section];
    
    ZKTableViewCellModel *model = sectionModel.cellModels[indexPath.row];
    cell.model = model;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    ZKTableViewSectionModel *sectionModel = self.sectionList[section];
    return sectionModel.header;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    ZKTableViewSectionModel *sectionModel = self.sectionList[section];
    return sectionModel.footer;
}

#pragma mark UITableview deldgate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZKTableViewSectionModel *sectionModel = self.sectionList[indexPath.section];
    ZKTableViewCellModel *model = sectionModel.cellModels[indexPath.row];
    
    //如果有目标控制器，跳转
    if (model.destinationVc) {
        [self.navigationController pushViewController:model.destinationVc animated:YES];
    }
    //如果有指定的操作，执行
    if (model.option) {
        model.option();
    }
}

#pragma mmark - event response

#pragma mark - private method

#pragma mark - getters and setters

@end
