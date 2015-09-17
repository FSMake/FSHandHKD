//
//  ZKTableViewCell.h
//  掌上科大
//
//  Created by 樊樊帅 on 6/26/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZKTableViewCellModel;

@interface ZKTableViewCell : UITableViewCell

@property (nonatomic, strong) ZKTableViewCellModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
