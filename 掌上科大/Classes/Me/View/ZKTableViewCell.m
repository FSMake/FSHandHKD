//
//  ZKTableViewCell.m
//  掌上科大
//
//  Created by 樊樊帅 on 6/26/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKTableViewCell.h"
#import "ZKTableViewCellModel.h"

@implementation ZKTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"Cell";
    ZKTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ZKTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.model = nil;
    return cell;
}

- (void)setModel:(ZKTableViewCellModel *)model {
    _model = model;
    self.textLabel.text = model.title;
    self.detailTextLabel.text = model.subTitle;
    if (model.showArrow) {
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellArrow"]];
    }
}

@end
