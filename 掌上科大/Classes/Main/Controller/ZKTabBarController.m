//
//  ZKTabBarController.m
//  掌上科大
//
//  Created by 樊樊帅 on 6/26/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKTabBarController.h"
#import "ZKNavController.h"
#import "ZKNewsController.h"
#import "ZKMeController.h"
#import "ZKLostFoundController.h"

@interface ZKTabBarController ()

@end

@implementation ZKTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //新闻
    ZKNewsController *news = [[ZKNewsController alloc] init];
    ZKNavController *newsNavVc = [[ZKNavController alloc] initWithRootViewController:news];
    news.tabBarItem.title = @"新闻";
    news.tabBarItem.image = [UIImage imageNamed:@"tabBar_new"];
    UIImage *newsIcon = [UIImage imageNamed:@"tabBar_new_highLight"];
    [news.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: RGBColor(34, 127, 255)} forState:UIControlStateSelected];
    news.tabBarItem.selectedImage = [newsIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:newsNavVc];
    
    //发现
    ZKLostFoundController *lostFoundVc = [[ZKLostFoundController alloc] init];
    ZKNavController *lostFoundNavVc = [[ZKNavController alloc] initWithRootViewController:lostFoundVc];
    lostFoundVc.tabBarItem.title = @"失物";
    lostFoundVc.tabBarItem.image = [UIImage imageNamed:@"tabBar_discover"];
    UIImage *discoverIcon = [UIImage imageNamed:@"tabBar_discover_highLight"];
    [lostFoundVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: RGBColor(34, 127, 255)} forState:UIControlStateSelected];
    lostFoundVc.tabBarItem.selectedImage = [discoverIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    lostFoundVc.view.backgroundColor = randomColor;
    [self addChildViewController:lostFoundNavVc];
    
    //我
    ZKMeController *me = [[ZKMeController alloc] init];
    ZKNavController *meNavVc = [[ZKNavController alloc] initWithRootViewController:me];
    me.tabBarItem.title = @"我";
    me.tabBarItem.image = [UIImage imageNamed:@"tabBar_me"];
    UIImage *meIcon = [UIImage imageNamed:@"tabBar_me_highLight"];
    [me.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: RGBColor(34, 127, 255)} forState:UIControlStateSelected];
    me.tabBarItem.selectedImage = [meIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:meNavVc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
