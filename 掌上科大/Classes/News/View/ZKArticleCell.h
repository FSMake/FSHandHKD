//
//  ZKArticleCell.h
//  掌上科大
//
//  Created by 樊樊帅 on 6/28/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZKArticleFrameModel;

@interface ZKArticleCell : UITableViewCell

@property (nonatomic, strong) ZKArticleFrameModel *articleFrameModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
