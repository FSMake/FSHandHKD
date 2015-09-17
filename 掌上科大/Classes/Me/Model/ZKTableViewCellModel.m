//
//  FSTableViewCellModel.m
//  Lottery(彩票)
//
//  Created by 樊樊帅 on 5/11/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKTableViewCellModel.h"

@implementation ZKTableViewCellModel

+ (instancetype)tableViewCellModelWith:(NSString *)title showArrow:(BOOL)showArrow destinationVc:(UIViewController *)destinationVc{
    ZKTableViewCellModel *model = [[self alloc] init];
    model.title = title;
    model.showArrow = showArrow;
    model.destinationVc = destinationVc;
    return model;
}

+ (instancetype)tableViewCellModelWith:(NSString *)title detailTextLable:(NSString *)detailTitle {
    ZKTableViewCellModel *model = [[self alloc] init];
    model.title = title;
    model.subTitle = detailTitle;
    return model;
}

@end
