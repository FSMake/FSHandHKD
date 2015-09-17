//
//  ZKCollectionCellFrameModel.m
//  掌上科大
//
//  Created by 樊樊帅 on 6/29/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKCollectionCellFrameModel.h"

@implementation ZKCollectionCellFrameModel

+ (instancetype)frameModelWithArticleModel:(ZKArticleModel *)articleModel {
    ZKCollectionCellFrameModel *frameModel = [[ZKCollectionCellFrameModel alloc] init];
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
    
    CGSize titleLableSize = [_articleModel.title boundingRectWithSize:CGSizeMake(titleLableW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    _titleViewF = CGRectMake(titleLableX, titleLableY, titleLableSize.width, titleLableSize.height);
    
    //infoLabel尺寸
    
    //infoLable尺寸
    CGFloat infoLableX = margin;
    CGFloat infoLableY = CGRectGetMaxY(_titleViewF);
    CGFloat infoLableW = screenW - 2 *infoLableX;
    CGFloat infoLableH = 20;
    _infoViewF = CGRectMake(infoLableX, infoLableY, infoLableW, infoLableH);
    
    //行高
    _rowH = CGRectGetMaxY(_infoViewF) + 10;
}



@end
