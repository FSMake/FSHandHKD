//
//  ZKTableViewCellModel.h
//  Lottery(彩票)
//
//  Created by 樊樊帅 on 5/11/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FSCellModelBlock)();

@interface ZKTableViewCellModel : NSObject

@property (nonatomic, copy) FSCellModelBlock option;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *subTitle;

@property (nonatomic, assign) BOOL showArrow;

@property (nonatomic, strong) UIViewController *destinationVc;

/**
 *  创建并初始化一个cell的model
 *
 *  @param title         cell标题
 *  @param showArrow     是否显示右边箭头
 *  @param destinationVc 是否有要跳转的控制器
 *
 *  @return 初始化好的cell's model
 */
+ (instancetype)tableViewCellModelWith:(NSString *)title showArrow:(BOOL)showArrow destinationVc:(UIViewController *)destinationVc;

/**
 *  创建并初始化一个cell的model
 *
 *  @param title       cell的标题
 *  @param detailTitle 小标题
 *
 *  @return 初始化好的cell's model
 */
+ (instancetype)tableViewCellModelWith:(NSString *)title detailTextLable:(NSString *)detailTitle;

@end
