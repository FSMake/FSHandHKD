//
//  ZKCollectionController.m
//  掌上科大
//
//  Created by 樊樊帅 on 6/29/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKCollectionController.h"
#import <BmobSDK/Bmob.h>
#import "ZKArticleModel.h"
#import "ZKCollectionCellFrameModel.h"
#import "ZKCollectionCell.h"
#import "ZKNewDetailController.h"
#import "MBProgressHUD+MJ.h"
#import "ZKLoadView.h"

@interface ZKCollectionController()

@property (nonatomic, strong) NSMutableArray *articels;

@end

@implementation ZKCollectionController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    
    //盖一层蒙版，提示用户正在加载
    ZKLoadView *loadView = [ZKLoadView loadView];
    loadView.backgroundColor = RGBColor(200, 200, 200);
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:loadView];
    
    self.navigationItem.title = @"我的收藏";
    
    BmobUser *user = [BmobUser getCurrentUser];
    //取出用户的收藏列表
    NSArray *collections = [user objectForKey:@"collections"];
    
    if (collections == nil) {
        [MBProgressHUD showError:@"您还没有收藏任何文章"];
        [loadView removeFromSuperview];
        self.tableView.scrollEnabled = YES;
        return;
    }
    
    //根据收藏列表中的id，向服务器请求数据
    BmobQuery *bQuery = [BmobQuery queryWithClassName:@"article"];
    //添加条件约束，查找指定ID的多条数据
    [bQuery whereKey:@"objectId" containedIn:collections];
    
    [bQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        NSLog(@"%@", array);
        
        for (BmobObject *object in array) {
            ZKArticleModel *articleModel = [ZKArticleModel articleWithArticleObj:object];
            ZKCollectionCellFrameModel *frameModel = [ZKCollectionCellFrameModel frameModelWithArticleModel:articleModel];
            [self.articels addObject:frameModel];
        }
        [loadView removeFromSuperview];
        self.tableView.scrollEnabled = YES;
        [self.tableView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - delegate
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.articels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZKCollectionCell *cell = [ZKCollectionCell cellWithTableView:tableView];
    
    ZKCollectionCellFrameModel *frameModel = self.articels[indexPath.row];

    cell.cellFrameModel = frameModel;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZKCollectionCellFrameModel *frameModel = self.articels[indexPath.row];
    
    return frameModel.rowH;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.selected = NO;
    
    ZKCollectionCellFrameModel *frameModel = self.articels[indexPath.row];
    ZKArticleModel *articleModel = frameModel.articleModel;
    
    ZKNewDetailController *newDetailVc = [[ZKNewDetailController alloc] init];
    newDetailVc.articleModel = articleModel;
    [self.navigationController pushViewController:newDetailVc animated:YES];
}

#pragma mmark - event response

#pragma mark - private method

#pragma mark - getters and setters
- (NSMutableArray *)articels {
    if (_articels == nil) {
        _articels = [NSMutableArray array];
    }
    return _articels;
}


@end
