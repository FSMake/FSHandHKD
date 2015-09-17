//
//  ZKStuffInfoModel.h
//  掌上科大
//
//  Created by 樊樊帅 on 7/1/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>

@interface ZKStuffInfoModel : NSObject

/**
 *  物品名称
 */
@property (nonatomic, copy) NSString *name;
/**
 *  物品信息
 */
@property (nonatomic, copy) NSString *information;
/**
 *  联系方式
 */
@property (nonatomic, copy) NSString *contactWay;
/**
 *  物品图片file
 */
@property (strong, nonatomic) BmobFile *imgFile;
/**
 *  1表示是招领信息，0表示是寻物信息
 */
@property (nonatomic, assign) BOOL found;
/**
 *  发布时间
 */
@property (nonatomic, copy) NSString *creatTime;
/**
 *  发布者id
 */
@property (nonatomic, strong) NSString *announcerId;

@property (nonatomic, strong) BmobObject *stuffInfoObj;


+ (instancetype)stuffInfoModelWithStuffInfoObject:(BmobObject *)object;

@end
