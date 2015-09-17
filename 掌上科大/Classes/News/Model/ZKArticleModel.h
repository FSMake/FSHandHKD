//
//  ZKArticleModel.h
//  掌上科大
//
//  Created by 樊樊帅 on 6/28/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>

@interface ZKArticleModel : NSObject
/**
 *  文章标题
 */
@property (copy, nonatomic) NSString *title;
/**
 *  文章发布日期
 */
@property (nonatomic, strong) NSString *date;
/**
 *  作者
 */
@property (copy, nonatomic) NSString *author;
/**
 *  简介
 */
@property (copy, nonatomic) NSString *intro;
/**
 *  索引图片url
 */
@property (nonatomic, copy) NSString *indexImgUrl;
/**
 *  正文
 */
@property (copy, nonatomic) NSString *content;
/**
 *  赞数
 */
@property (nonatomic, assign) int likeCount;
/**
 *  踩数
 */
@property (nonatomic, assign) int unlikeCount;
/**
 *  文章id
 */
@property (copy, nonatomic) NSString *objectId;
/**
 *  索引标号
 */
@property (nonatomic, assign) int index;

//---------------------------------
@property (nonatomic, strong) BmobObject *articleObj;

+ (instancetype)articleWithArticleObj:(BmobObject *)articleObj;

@end
