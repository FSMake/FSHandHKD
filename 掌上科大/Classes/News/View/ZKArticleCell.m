//
//  ZKArticleCell.m
//  掌上科大
//
//  Created by 樊樊帅 on 6/28/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKArticleCell.h"
#import "ZKArticleFrameModel.h"
#import "ZKArticleModel.h"
#import "UIImageView+WebCache.h"

@interface ZKArticleCell()
/**
 *  标题
 */
@property (nonatomic, weak) UILabel *titleLable;
/**
 *  文章信息，包含时间和作者
 */
@property (nonatomic, weak) UILabel *infoLable;
/**
 *  文章梗概
 */
@property (nonatomic, weak) UILabel *introLable;
/**
 *  索引图
 */
@property (nonatomic, weak) UIImageView *indexImgView;

@end

@implementation ZKArticleCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"Cell";
    ZKArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ZKArticleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
/**
 *  初始化cell内部视图
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.titleLable.backgroundColor = randomColor;
        self.titleLable.font = ZKTitleLableFont;
//        self.infoLable.backgroundColor = randomColor;
        self.infoLable.font = [UIFont systemFontOfSize:12];
        self.infoLable.textColor = RGBColor(180, 180, 180);
        
//        self.introLable.backgroundColor = randomColor;
        self.introLable.font = [UIFont systemFontOfSize:15];
        self.introLable.textColor = RGBColor(90, 90, 90);
        self.indexImgView.backgroundColor = randomColor;
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
}

/**
 *  设置cell内部数据
 */
- (void)setArticleFrameModel:(ZKArticleFrameModel *)articleFrameModel {
    _articleFrameModel = articleFrameModel;
    ZKArticleModel *articleModel = articleFrameModel.articleModel;
    
    self.titleLable.frame = _articleFrameModel.titleLableF;
    self.infoLable.frame = _articleFrameModel.infoLableF;
    self.introLable.frame = _articleFrameModel.introLableF;
    self.indexImgView.frame = _articleFrameModel.indexImgViewF;
    //分隔条
    UIView *cutoffView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_articleFrameModel.indexImgViewF) + 10, screenW, 7)];
    cutoffView.backgroundColor = RGBColor(220, 220, 220);
    [self addSubview:cutoffView];
    
    self.titleLable.text = articleModel.title;
    self.infoLable.text = [NSString stringWithFormat:@"%@ · %@", articleModel.date, articleModel.author];
    self.introLable.text = articleModel.intro;
#warning 图片
    //图片
//    NSLog(@"%@", articleModel.indexImgUrl);
    [self.indexImgView sd_setImageWithURL:[NSURL URLWithString:articleModel.indexImgUrl] placeholderImage:[UIImage imageNamed:@"article_image_placeholder"]];
    
    
}

#pragma mark - private method

#pragma mark - setters and getters
- (UILabel *)titleLable {
    if (_titleLable == nil) {
        UILabel *lable = [[UILabel alloc] init];
        _titleLable = lable;
        _titleLable.numberOfLines = 2;
        [self addSubview:_titleLable];
    }
    return _titleLable;
}

- (UILabel *)infoLable {
    if (_infoLable == nil) {
        UILabel *lable = [[UILabel alloc] init];
        _infoLable = lable;
        [self addSubview:_infoLable];
    }
    return _infoLable;
}

- (UILabel *)introLable {
    if (_introLable == nil) {
        UILabel *lable = [[UILabel alloc] init];
        _introLable = lable;
        _introLable.numberOfLines = 2;
        [self addSubview:_introLable];
    }
    return _introLable;
}

- (UIImageView *)indexImgView {
    if (_indexImgView == nil) {
        UIImageView *imgView = [[UIImageView alloc] init];
        _indexImgView = imgView;
        [self addSubview:_indexImgView];
    }
    return _indexImgView;
}

@end
