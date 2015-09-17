//
//  ZKTableViewSectionModel.h
//  掌上科大
//
//  Created by 樊樊帅 on 6/28/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZKTableViewCell.h"

@interface ZKTableViewSectionModel : NSObject

@property (nonatomic, strong) NSArray *cellModels;

@property (nonatomic, copy) NSString *header;

@property (copy, nonatomic) NSString *footer;

+ (instancetype)sectionWithCellModels:(NSArray *)models header:(NSString *)header footer:(NSString *)footer;

@end
