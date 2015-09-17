//
//  ZKstuffInfoCell.h
//  掌上科大
//
//  Created by 樊樊帅 on 7/1/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKStuffInfoFrameModel.h"

@interface ZKstuffInfoCell : UITableViewCell
/**
 *  cell的信息model
 */
@property (nonatomic, strong) ZKStuffInfoFrameModel *stuffInfoFrameModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
