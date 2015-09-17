//
//  ZKLostFoundController.m
//  掌上科大
//
//  Created by 樊樊帅 on 6/30/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKLostFoundController.h"
#import "ZKTitleButton.h"
#import "ZKDropDownList.h"
#import "ZKTitleDropController.h"
#import "ZKLostController.h"
#import <BmobSDK/Bmob.h>
#import "ZKStuffInfoModel.h"
#import "ZKstuffInfoCell.h"
#import "ZKStuffInfoFrameModel.h"
#import "ZKStuffViewController.h"

@interface ZKLostFoundController () <ZKDropDownListDelegate, ZKTitleDropControllerDelegate>

@property (nonatomic, strong) ZKDropDownList *titleDropDownList;

@property (nonatomic, strong) NSMutableArray *stuffInfoFrames;
/**
 *  备份数据
 */
@property (nonatomic, strong) NSMutableArray *backupStuffInfoFrames;

@end

@implementation ZKLostFoundController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self setupNav];
    
    BmobQuery *bQuery = [[BmobQuery alloc] initWithClassName:@"stuffInfo"];
    
    [bQuery includeKey:@"announcer"];
    
    [bQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (int i = 0; i < array.count; i++) {
            ZKStuffInfoModel *model = [ZKStuffInfoModel stuffInfoModelWithStuffInfoObject:array[i]];
            ZKStuffInfoFrameModel *frameModel = [ZKStuffInfoFrameModel stuffInfoFrameModelWith:model];
            [self.stuffInfoFrames addObject:frameModel];
            if (i == array.count - 1) {
                [self.tableView reloadData];
                self.backupStuffInfoFrames = self.stuffInfoFrames;
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.stuffInfoFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZKstuffInfoCell *cell = [ZKstuffInfoCell cellWithTableView:tableView];
    
    ZKStuffInfoFrameModel *frameModel = self.stuffInfoFrames[indexPath.row];
    
    cell.stuffInfoFrameModel = frameModel;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZKStuffInfoFrameModel *frameModel = self.stuffInfoFrames[indexPath.row];
    return frameModel.rowH;
}

#pragma mark Tabel view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZKstuffInfoCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    ZKStuffInfoFrameModel *frameModel = self.stuffInfoFrames[indexPath.row];
    ZKStuffInfoModel *model = frameModel.stuffInfoModel;
    
    ZKStuffViewController *stuffVc = [[ZKStuffViewController alloc] init];
    stuffVc.stuffModel = model;
    [self.navigationController pushViewController:stuffVc animated:YES];
}


#pragma mark ZKDropDownListDelegate
/**
 *  下拉菜单消失
 */
- (void)dropDownListDidDismiss:(ZKDropDownList *)dropDownList {
    UIButton *btn = (UIButton *)self.navigationItem.titleView;
    btn.selected = NO;
}
/**
 *  下拉菜单显示
 */
- (void)dropDownListDidShow:(ZKDropDownList *)dropDownList {
    UIButton *btn = (UIButton *)self.navigationItem.titleView;
    btn.selected = YES;
}

#pragma mark ZKTitleDropControllerDelegate
/**
 *  点击了显示全部
 */
- (void)titleDropControllerDidSelectedShowAll:(ZKTitleDropController *)titleDropController {
    NSLog(@"显示全部");
    
    [UIView animateWithDuration:0.2 animations:^{
        _titleDropDownList.alpha = 0;
    } completion:^(BOOL finished) {
        [_titleDropDownList dismiss];
    }];
    
    self.stuffInfoFrames = self.backupStuffInfoFrames;
    [self.tableView reloadData];
    
}

/**
 *  点击了只看招领
 */
- (void)titleDropControllerDidSelectedShowFound:(ZKTitleDropController *)titleDropController {
    NSLog(@"只看招领");
    [UIView animateWithDuration:0.2 animations:^{
        _titleDropDownList.alpha = 0;
    } completion:^(BOOL finished) {
        [_titleDropDownList dismiss];
    }];
    self.stuffInfoFrames = self.backupStuffInfoFrames;
    /**
     *  把完整数据备份
     */
    self.backupStuffInfoFrames = self.stuffInfoFrames;
    
    NSMutableArray *foundFrameModels = [NSMutableArray array];
    
    for (int i = 0; i < self.stuffInfoFrames.count; i++) {
        ZKStuffInfoFrameModel *frameModel = self.stuffInfoFrames[i];
        ZKStuffInfoModel *model = frameModel.stuffInfoModel;
        if (model.found) {//说明是招领信息
            [foundFrameModels addObject:frameModel];
        }
    }
    self.stuffInfoFrames = foundFrameModels;
    [self.tableView reloadData];
}

/**
 *  点击了只看失物
 */
- (void)titleDropControllerDidSelectedShowLost:(ZKTitleDropController *)titleDropController {
    NSLog(@"只看失物");
    [UIView animateWithDuration:0.2 animations:^{
        _titleDropDownList.alpha = 0;
    } completion:^(BOOL finished) {
        [_titleDropDownList dismiss];
    }];
    self.stuffInfoFrames = self.backupStuffInfoFrames;
    /**
     *  把完整数据备份
     */
    self.backupStuffInfoFrames = self.stuffInfoFrames;
    
    NSMutableArray *lostFrameModels = [NSMutableArray array];
    
    for (int i = 0; i < self.stuffInfoFrames.count; i++) {
        ZKStuffInfoFrameModel *frameModel = self.stuffInfoFrames[i];
        ZKStuffInfoModel *model = frameModel.stuffInfoModel;
        if (!model.found) {//说明是招领信息
            [lostFrameModels addObject:frameModel];
        }
    }
    self.stuffInfoFrames = lostFrameModels;
    [self.tableView reloadData];
}

#pragma mark - event response
/**
 *  标题点击，展开下拉菜单
 */
- (void)titleClick:(UIButton *)btn {
    NSLog(@"%s", __func__);
    //创建下拉菜单
    ZKDropDownList *dropDownList = [ZKDropDownList dropDownList];
    _titleDropDownList = dropDownList;
    //设置菜单内容
    ZKTitleDropController *dropDownVc = [[ZKTitleDropController alloc] initWithStyle:UITableViewStylePlain];
    
    dropDownVc.delegate = self;
    
    dropDownList.tableViewVc = dropDownVc;
    dropDownList.caller = btn;
    dropDownList.delegate = self;
    
    //显示下拉菜单
    [dropDownList show];
}

/**
 *  发布信息点击
 */
- (void)lostSomething {
    NSLog(@"丢东西了");
    ZKLostController *lostVc = [[ZKLostController alloc] init];
    [self.navigationController pushViewController:lostVc animated:YES];
}

#pragma mark - private method
- (void)setupNav {
    self.navigationItem.title = @"失物招领";
    
    //设置标题view
    ZKTitleButton *titleBtn = [ZKTitleButton buttonWithType:UIButtonTypeCustom];
    [titleBtn setTitle:@"失物招领" forState:UIControlStateNormal];
    [titleBtn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleBtn;
    
    //右边按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(lostSomething)];
}

#pragma mark - getters and setters
- (NSMutableArray *)stuffInfoFrames {
    if (_stuffInfoFrames == nil) {
        _stuffInfoFrames = [NSMutableArray array];
    }
    return _stuffInfoFrames;
}

@end
