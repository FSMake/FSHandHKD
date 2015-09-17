//
//  ZKArticleFrameModel.h
//  掌上科大
//
//  Created by 樊樊帅 on 6/28/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZKArticleModel.h"

#define ZKTitleLableFont [UIFont systemFontOfSize:18]

@interface ZKArticleFrameModel : NSObject

@property (nonatomic, strong) ZKArticleModel *articleModel;

/**
 *  标题
 */
@property (nonatomic, assign) CGRect titleLableF;
/**
 *  文章信息，包含时间和作者
 */
@property (nonatomic, assign) CGRect infoLableF;
/**
 *  文章梗概
 */
@property (nonatomic, assign) CGRect introLableF;
/**
 *  索引图
 */
@property (nonatomic, assign) CGRect indexImgViewF;
/**
 *  cell高度
 */
@property (nonatomic, assign) CGFloat rowH;

+ (instancetype)frameWithArticleModel:(ZKArticleModel *)articleModel;

@end
