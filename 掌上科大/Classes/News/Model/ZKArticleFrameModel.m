//
//  ZKArticleFrameModel.m
//  掌上科大
//
//  Created by 樊樊帅 on 6/28/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKArticleFrameModel.h"

@implementation ZKArticleFrameModel

+ (instancetype)frameWithArticleModel:(ZKArticleModel *)articleModel {
    ZKArticleFrameModel *frameModel = [[ZKArticleFrameModel alloc] init];
    frameModel.articleModel = articleModel;
    return frameModel;
}

- (void)setArticleModel:(ZKArticleModel *)articleModel {
    _articleModel = articleModel;
    
    CGFloat margin = 10;
    
    //titleLable尺寸
    CGFloat titleLableX = margin;
    CGFloat titleLableY = margin;
    CGFloat titleLableW = screenW - 2 * titleLableX;
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = ZKTitleLableFont;
    
    CGSize titleLableSize = [articleModel.title boundingRectWithSize:CGSizeMake(titleLableW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    _titleLableF = CGRectMake(titleLableX, titleLableY, titleLableSize.width, titleLableSize.height);
    
    
    //infoLable尺寸
    CGFloat infoLableX = margin;
    CGFloat infoLableY = CGRectGetMaxY(_titleLableF);
    CGFloat infoLableW = screenW - 2 *infoLableX;
    CGFloat infoLableH = 20;
    _infoLableF = CGRectMake(infoLableX, infoLableY, infoLableW, infoLableH);
    
    
    //introLable尺寸
    CGFloat introLableX = margin;
    CGFloat introLableY = CGRectGetMaxY(_infoLableF);
    CGFloat introLableW = screenW - 2 * introLableX;
    CGFloat introLableH = 40;
    _introLableF = CGRectMake(introLableX, introLableY, introLableW, introLableH);
    
    //indexImg尺寸
    CGFloat indexImgX = margin;
    CGFloat indexImgY = CGRectGetMaxY(_introLableF);
    CGFloat indexImgW = screenW - 2 * indexImgX;
    CGFloat indexImgH = 150;
    _indexImgViewF = CGRectMake(indexImgX, indexImgY, indexImgW, indexImgH);
    
    //还要加上一个分割条的高度
    _rowH = CGRectGetMaxY(_indexImgViewF) + 17;
}

@end