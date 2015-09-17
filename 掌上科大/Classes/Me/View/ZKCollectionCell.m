//
//  ZKCollectionCell.m
//  掌上科大
//
//  Created by 樊樊帅 on 6/29/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKCollectionCell.h"

@interface ZKCollectionCell()
/**
 *  标题
 */
@property (nonatomic, weak) UILabel *titleLabel;
/**
 *  信息
 */
@property (nonatomic, weak) UILabel *infoLabel;

@end

@implementation ZKCollectionCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel.font = ZKTitleLableFont;
        self.titleLabel.numberOfLines = 2;
        
        self.infoLabel.font = [UIFont systemFontOfSize:15];
        self.infoLabel.textColor = RGBColor(150, 150, 150);
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"Cell";
    ZKCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ZKCollectionCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (void)setCellFrameModel:(ZKCollectionCellFrameModel *)cellFrameModel {
    _cellFrameModel = cellFrameModel;
    
    self.titleLabel.frame = _cellFrameModel.titleViewF;
    self.titleLabel.text = _cellFrameModel.articleModel.title;
    
    self.infoLabel.frame = _cellFrameModel.infoViewF;
    self.infoLabel.text = [NSString stringWithFormat:@"%@ · %@", _cellFrameModel.articleModel.date, _cellFrameModel.articleModel.author];
}

#pragma mark - setters and getters
- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        _titleLabel = label;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)infoLabel {
    if (_infoLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        _infoLabel = label;
        [self addSubview:_infoLabel];
    }
    return _infoLabel;
}

@end
