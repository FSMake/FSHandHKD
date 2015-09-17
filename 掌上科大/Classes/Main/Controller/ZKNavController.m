//
//  ZKNavController.m
//  掌上科大
//
//  Created by 樊樊帅 on 6/24/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKNavController.h"

@interface ZKNavController ()

@end

@implementation ZKNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationBar.tintColor = [UIColor whiteColor];
    
    //设置navBar标题字体
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    attributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:19];
    
    [self.navigationBar setTitleTextAttributes:attributes];
    
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBgBlue"] forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //判断的作用是跳过第一次push(四个主页面)
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    UIViewController *Vc = [super popViewControllerAnimated:animated];
    Vc.navigationController.navigationBar.hidden = NO;
    return Vc;
}

@end
