//
//  ZKStuffInfoFrameModel.m
//  掌上科大
//
//  Created by 樊樊帅 on 7/1/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKStuffInfoFrameModel.h"

@implementation ZKStuffInfoFrameModel

+ (instancetype)stuffInfoFrameModelWith:(ZKStuffInfoModel *)stuffInfoModel {
    ZKStuffInfoFrameModel *frameModel = [[ZKStuffInfoFrameModel alloc] init];
    frameModel.stuffInfoModel = stuffInfoModel;
    return frameModel;
}

- (void)setStuffInfoModel:(ZKStuffInfoModel *)stuffInfoModel {
    _stuffInfoModel = stuffInfoModel;
    
    CGFloat margin = 10;
    
    CGFloat imgViewX = margin;
    CGFloat imgViewY = margin;
    CGFloat imgViewH = 70;
    CGFloat imgViewW = 70;
    _ImgViewF = CGRectMake(imgViewX, imgViewY, imgViewW, imgViewH);
    
    CGFloat nameLabelX = CGRectGetMaxX(_ImgViewF) + margin;
    CGFloat nameLabelY = _ImgViewF.origin.y;
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = ZKNameFont;
    
    CGSize nameLabelSize = [stuffInfoModel.name boundingRectWithSize:CGSizeMake(screenW - nameLabelX - margin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    _nameLabelF = CGRectMake(nameLabelX, nameLabelY, nameLabelSize.width, nameLabelSize.height);
    
    CGFloat timeLabelH = 20;
    CGFloat timeLabelW = 80;
    CGFloat timeLabelX = nameLabelX;
    CGFloat timeLabelY = CGRectGetMaxY(_ImgViewF) - timeLabelH;
    _timeLabelF = CGRectMake(timeLabelX, timeLabelY, timeLabelW, timeLabelH);
    
    CGFloat typeViewH = 20;
    CGFloat typeViewW = 20;
    CGFloat typeViewX = screenW - margin - typeViewW;
    CGFloat typeViewY = CGRectGetMaxY(_ImgViewF) - typeViewH;
    _typeViewF = CGRectMake(typeViewX, typeViewY, typeViewW, typeViewH);
    
    _rowH = CGRectGetMaxY(_ImgViewF) + margin;
}

@end
