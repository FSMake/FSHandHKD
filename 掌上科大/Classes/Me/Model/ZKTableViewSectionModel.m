//
//  ZKTableViewSectionModel.m
//  掌上科大
//
//  Created by 樊樊帅 on 6/28/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKTableViewSectionModel.h"

@implementation ZKTableViewSectionModel

+ (instancetype)sectionWithCellModels:(NSArray *)models header:(NSString *)header footer:(NSString *)footer {
    ZKTableViewSectionModel *sectionModel = [[ZKTableViewSectionModel alloc] init];
    sectionModel.cellModels = models;
    sectionModel.header = header;
    sectionModel.footer = footer;
    return sectionModel;
}

@end
