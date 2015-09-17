//
//  ZKstuffInfoCell.m
//  掌上科大
//
//  Created by 樊樊帅 on 7/1/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKstuffInfoCell.h"
#import "ZKStuffInfoModel.h"
#import "UIImageView+WebCache.h"

@interface ZKstuffInfoCell()
/**
 *  物品图片view
 */
@property (nonatomic, weak) UIImageView *imgView;
/**
 *  物品名称label
 */
@property (nonatomic, weak) UILabel *nameLabel;
/**
 *  发布时间label
 */
@property (nonatomic, weak) UILabel *timeLabel;
/**
 *  类型view
 */
@property (nonatomic, weak) UIImageView *typeView;

@end

@implementation ZKstuffInfoCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"stuffInfo";
    ZKstuffInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ZKstuffInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.imgView.backgroundColor = [UIColor redColor];
        
//        self.nameLabel.backgroundColor = [UIColor blueColor];
        self.nameLabel.font = ZKNameFont;
        
//        self.timeLabel.backgroundColor = [UIColor greenColor];
        self.timeLabel.font = [UIFont systemFontOfSize:12];
        self.timeLabel.textColor = RGBColor(180, 180, 180);
        
//        self.typeView.backgroundColor = [UIColor redColor];
        self.imgView.contentMode = UIViewContentModeScaleToFill;
    }
    return self;
}

- (void)setStuffInfoFrameModel:(ZKStuffInfoFrameModel *)stuffInfoFrameModel {
    _stuffInfoFrameModel = stuffInfoFrameModel;
    
    ZKStuffInfoModel *model = stuffInfoFrameModel.stuffInfoModel;
    
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.imgFile.url] placeholderImage:[UIImage imageNamed:@"article_image_placeholder"]];
    self.imgView.frame = stuffInfoFrameModel.ImgViewF;
    
    self.nameLabel.frame = stuffInfoFrameModel.nameLabelF;
    self.nameLabel.text = model.name;
    
    self.timeLabel.frame = stuffInfoFrameModel.timeLabelF;
    self.timeLabel.text = model.creatTime;
    
    self.typeView.frame = stuffInfoFrameModel.typeViewF;
    if (model.found) {//招领
        self.typeView.image = [UIImage imageNamed:@"found_icon"];
    } else {//寻物
        self.typeView.image = [UIImage imageNamed:@"lost_icon"];
    }
    
//    NSLog(@"imgView----%@", NSStringFromCGRect(self.imgView.frame));
//    NSLog(@"nameLabel--%@", NSStringFromCGRect(self.nameLabel.frame));
//    NSLog(@"timeLabel--%@", NSStringFromCGRect(self.timeLabel.frame));
//    NSLog(@"typeView---%@", NSStringFromCGRect(self.typeView.frame));
    
}

#pragma mark - setters and getters
- (UIImageView *)imgView {
    if (_imgView == nil) {
        UIImageView *imgView = [[UIImageView alloc] init];
        _imgView = imgView;
        [self addSubview:_imgView];
    }
    return _imgView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        _nameLabel = label;
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        _timeLabel = label;
        [self addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UIImageView *)typeView {
    if (_typeView == nil) {
        UIImageView *imgView = [[UIImageView alloc] init];
        _typeView = imgView;
        [self addSubview:_typeView];
    }
    return _typeView;
}

@end
