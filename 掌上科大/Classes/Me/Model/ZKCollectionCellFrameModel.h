//
//  ZKCollectionCellFrameModel.h
//  掌上科大
//
//  Created by 樊樊帅 on 6/29/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZKArticleModel.h"

#define ZKTitleLableFont [UIFont systemFontOfSize:18]

@interface ZKCollectionCellFrameModel : NSObject

@property (nonatomic, strong) ZKArticleModel *articleModel;
/**
 *  标题frame
 */
@property (nonatomic, assign) CGRect titleViewF;
/**
 *  信息frame
 */
@property (nonatomic, assign) CGRect infoViewF;
/**
 *  行高
 */
@property (nonatomic, assign) CGFloat rowH;

+ (instancetype)frameModelWithArticleModel:(ZKArticleModel *)articleModel;

@end
