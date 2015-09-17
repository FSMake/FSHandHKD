//
//  ZKNewsController.m
//  掌上科大
//
//  Created by 樊樊帅 on 6/26/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKNewsController.h"
#import <BmobSDK/Bmob.h>
#import "ZKArticleModel.h"
#import "ZKArticleCell.h"
#import "ZKArticleFrameModel.h"
#import "ZKNewDetailController.h"
#import "ZKLoadView.h"
#import "MJRefresh.h"
#import "ZKSearchBar.h"
#import "MBProgressHUD+MJ.h"

@interface ZKNewsController () <UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *articles;

@property (nonatomic, weak) UISegmentedControl *titleView;
/**
 *  搜索遮罩
 */
//@property (nonatomic, weak) UIView *searchCover;

@end

@implementation ZKNewsController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = RGBColor(220, 220, 220);
    
    //盖一层蒙版提示用户正在加载
    ZKLoadView *loadView = [ZKLoadView loadView];
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:loadView];
    
    self.navigationItem.title = @"新闻";
    
    [self setupNav];
    
    //请求服务器的前10篇文章数据，结果按照索引排序
    BmobQuery *query = [BmobQuery queryWithClassName:@"article"];
    [query orderByDescending:@"index"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            ZKArticleModel *model = [ZKArticleModel articleWithArticleObj:obj];
            ZKArticleFrameModel *frameModel = [ZKArticleFrameModel frameWithArticleModel:model];
            [self.articles addObject:frameModel];
        }
        
        //更新用户的阅读记录
        BmobUser *user = [BmobUser getCurrentUser];
        ZKArticleFrameModel *lastArticleFrame = [self.articles firstObject];
        ZKArticleModel *lastArticle = lastArticleFrame.articleModel;
        [user setObject:[NSNumber numberWithInt:lastArticle.index] forKey:@"lastReadIndex"];
        [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {//更新成功
            //去除蒙版
            [loadView removeFromSuperview];
            self.tableView.scrollEnabled = YES;
            
            [self.tableView reloadData];
        }];
        
    }];
    
    //设置下拉刷新控件
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownRefresh:)];
    header.lastUpdatedTimeLabel.font = [UIFont boldSystemFontOfSize:12];
    self.tableView.header = header;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
}

#pragma mark - delegate
#pragma mark Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.articles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZKArticleCell *cell = [ZKArticleCell cellWithTableView:tableView];
    
    ZKArticleFrameModel *frameModel = self.articles[indexPath.row];
    
    cell.articleFrameModel = frameModel;
    
    return cell;
}

#pragma mark TableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    
    ZKArticleFrameModel *articleFrameModel = self.articles[indexPath.row];
    ZKArticleModel *articleModel = articleFrameModel.articleModel;
    
    ZKNewDetailController *detailVc = [[ZKNewDetailController alloc] init];
    detailVc.articleModel = articleModel;
    [self.navigationController pushViewController:detailVc animated:YES];
}

//#pragma mark UITextFieldDelegate
//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    NSLog(@"搜索");
//    [MBProgressHUD showError:@"没有搜索到任何信息"];
//    return YES;
//}

#pragma mark - event response
- (void)titleChange:(UISegmentedControl *)segControl {
    if (segControl.selectedSegmentIndex == 0) {//点击了最新
        //按照索引值排序
        for (int i = 0; i < self.articles.count - 1; i++) {
            for (int j = i; j < self.articles.count; j++) {
                //拿出i对应的article
                ZKArticleFrameModel *frameModelI = self.articles[i];
                ZKArticleModel *articleModelI = frameModelI.articleModel;
                //拿出j对应的article
                ZKArticleFrameModel *frameModelJ = self.articles[j];
                ZKArticleModel *articleModelJ = frameModelJ.articleModel;
                
                if (articleModelJ.index > articleModelI.index) {
                    //交换i和j的位置
                    [self.articles exchangeObjectAtIndex:i withObjectAtIndex:j];
                }
            }
        }
    }
    
    if (segControl.selectedSegmentIndex == 1) {//点击了最热
        //按照赞和踩的总数排序
        for (int i = 0; i < self.articles.count - 1; i++) {
            for (int j = i; j < self.articles.count; j++) {
                //拿出i对应的article
                ZKArticleFrameModel *frameModelI = self.articles[i];
                ZKArticleModel *articleModelI = frameModelI.articleModel;
                //拿出j对应的article
                ZKArticleFrameModel *frameModelJ = self.articles[j];
                ZKArticleModel *articleModelJ = frameModelJ.articleModel;
                //判断谁的赞+踩个数多
                if (articleModelI.likeCount + articleModelI.unlikeCount < articleModelJ.likeCount + articleModelJ.unlikeCount) {
                    //交换i和j的位置
                    [self.articles exchangeObjectAtIndex:i withObjectAtIndex:j];
                }
            }
        }
    }
    
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZKArticleFrameModel *frameModel = self.articles[indexPath.row];
    return frameModel.rowH;
}
/**
 *  右上角按钮点击
 */
//- (void)search {
//    NSLog(@"search");
//    //遮罩
//    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW, screenH)];
//    coverView.backgroundColor = RGBAColor(0, 0, 0, 0.5);
//    self.searchCover = coverView;
//
//    //navBar
//    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, screenW, 64)];
//    [bar setBackgroundImage:[UIImage imageNamed:@"navBgBlue"] forBarMetrics:UIBarMetricsDefault];
//    //item
//    UINavigationItem *item = [[UINavigationItem alloc] init];
//    ZKSearchBar *searchBar = [ZKSearchBar searchBar];
//    searchBar.delegate = self;
//    item.titleView = searchBar;
//    
//    //把item加到bar上
//    [bar pushNavigationItem:item animated:YES];
//    
//    [coverView addSubview:bar];
//    [[UIApplication sharedApplication].keyWindow addSubview:coverView];
//    
//    [searchBar becomeFirstResponder];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverTap)];
//    [coverView addGestureRecognizer:tap];
//}
/**
 *  下拉刷新调用
 */
- (void)pullDownRefresh:(MJRefreshNormalHeader *)refreshHeader {
    NSLog(@"刷新");
    
    BmobUser *user = [BmobUser getCurrentUser];
    
    BmobQuery *bQuery = [BmobQuery queryWithClassName:@"article"];
    //查找索引值比用户已读记录大得文章,结果按照索引值排序
    [bQuery whereKey:@"index" greaterThan:[user objectForKey:@"lastReadIndex"]];
    [bQuery orderByDescending:@"index"];
    [bQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        NSMutableArray *newArticles = [NSMutableArray array];
        for (BmobObject *obj in array) {
            ZKArticleModel *model = [ZKArticleModel articleWithArticleObj:obj];
            ZKArticleFrameModel *frameModel = [ZKArticleFrameModel frameWithArticleModel:model];
            [newArticles addObject:frameModel];
        }
        
        NSRange newArticlesRange = NSMakeRange(0, newArticles.count);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:newArticlesRange];
        [self.articles insertObjects:newArticles atIndexes:indexSet];
        
        //更新用户已读索引
        int maxIndex = 0;
        for (ZKArticleFrameModel *articleFrame in self.articles) {
            ZKArticleModel *articleModel = articleFrame.articleModel;
            if (articleModel.index > maxIndex) {
                maxIndex = articleModel.index;
            }
        }
        [user setObject:[NSNumber numberWithInt:maxIndex] forKey:@"lastReadIndex"];
        [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            //更新成功，刷新表格
            [refreshHeader endRefreshing];
            [self.tableView reloadData];
        }];
    }];
}
/**
 *  点击了搜索遮罩
 */
//- (void)coverTap {
//    [self.searchCover removeFromSuperview];
//}

#pragma mark - private method
/**
 *  设置导航栏
 */
- (void)setupNav {
    //设置标题view
    UISegmentedControl *segControl = [[UISegmentedControl alloc] initWithItems:@[@"最新", @"最热"]];
    [segControl addTarget:self action:@selector(titleChange:) forControlEvents:UIControlEventValueChanged];
    segControl.height = 25;
    segControl.width = 120;
    segControl.selectedSegmentIndex = 0;
    self.navigationItem.titleView = segControl;
    self.titleView = segControl;
    
//    //设置右上角按钮
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(search)];
//    
//    //设置左上角按钮
    
}

#pragma mark - getters and setters
- (NSMutableArray *)articles {
    if (_articles == nil) {
        _articles = [NSMutableArray array];
    }
    return _articles;
}


@end
