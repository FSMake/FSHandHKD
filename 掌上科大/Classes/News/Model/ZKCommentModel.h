//
//  ZKCommentModel.h
//  掌上科大
//
//  Created by 樊樊帅 on 7/5/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>

@interface ZKCommentModel : NSObject
/**
 *  bmob的comment对象
 */
@property (nonatomic, strong) BmobObject *commentObject;
/**
 *  评论者
 */
@property (nonatomic, strong) BmobUser *commenter;
/**
 *  评论内容
 */
@property (copy, nonatomic) NSString *content;

+ (instancetype)commentWithCommentObject:(BmobObject *)commentObject;

@end
