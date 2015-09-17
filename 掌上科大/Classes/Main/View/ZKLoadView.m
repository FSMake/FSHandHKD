//
//  ZKLoadView.m
//  掌上科大
//
//  Created by 樊樊帅 on 6/29/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKLoadView.h"

@implementation ZKLoadView

+ (instancetype)loadView {
    ZKLoadView *loadView = [[ZKLoadView alloc] initWithFrame:CGRectMake(0, 0, screenW, screenH + 64)];
    loadView.backgroundColor = RGBColor(200, 200, 200);
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    activityIndicatorView.centerX = screenW * 0.5;
    activityIndicatorView.centerY = screenH * 0.5;
    [activityIndicatorView startAnimating];
    [loadView addSubview:activityIndicatorView];
    
    loadView.x = 0;
    loadView.y = -64;
    return loadView;
}

@end
