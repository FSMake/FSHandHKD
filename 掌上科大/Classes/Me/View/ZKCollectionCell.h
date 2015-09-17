//
//  ZKCollectionCell.h
//  掌上科大
//
//  Created by 樊樊帅 on 6/29/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKCollectionCellFrameModel.h"

@interface ZKCollectionCell : UITableViewCell

@property (nonatomic, strong) ZKCollectionCellFrameModel *cellFrameModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
