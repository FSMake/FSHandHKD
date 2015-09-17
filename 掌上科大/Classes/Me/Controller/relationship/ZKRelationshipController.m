//
//  ZKRelationshipController.m
//  掌上科大
//
//  Created by 樊樊帅 on 7/5/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKRelationshipController.h"

@interface ZKRelationshipController ()

@end

@implementation ZKRelationshipController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"我的关系";
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.width = 100;
    tipLabel.height = 44;
    tipLabel.centerX = self.view.centerX;
    tipLabel.centerY = self.view.height * 0.2;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = [UIFont systemFontOfSize:13];
    tipLabel.textColor = RGBColor(128, 128, 128);
    tipLabel.text = @"功能尚未开启";
    
    [self.view addSubview:tipLabel];
}


@end
