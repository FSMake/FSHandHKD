//
//  ZKStuffInfoFrameModel.h
//  掌上科大
//
//  Created by 樊樊帅 on 7/1/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZKStuffInfoModel.h"

#define ZKNameFont [UIFont systemFontOfSize:18]

@interface ZKStuffInfoFrameModel : NSObject
/**
 *  物品信息模型
 */
@property (nonatomic, strong) ZKStuffInfoModel *stuffInfoModel;
/**
 *  图片view frame
 */
@property (nonatomic, assign) CGRect ImgViewF;
/**
 *  名称label frame
 */
@property (nonatomic, assign) CGRect nameLabelF;
/**
 *  时间label frame
 */
@property (nonatomic, assign) CGRect timeLabelF;
/**
 *  类型view frame
 */
@property (nonatomic, assign) CGRect typeViewF;
/**
 *  cell行高
 */
@property (nonatomic, assign) CGFloat rowH;

+ (instancetype)stuffInfoFrameModelWith:(ZKStuffInfoModel *)stuffInfoModel;

@end
