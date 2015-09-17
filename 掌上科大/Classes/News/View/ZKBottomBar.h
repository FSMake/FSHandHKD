//
//  ZKBottomBar.h
//  掌上科大
//
//  Created by 樊樊帅 on 6/29/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZKBottomBar;

@protocol ZKBottomBarDelegate <NSObject>

- (void)bottomBarBack:(ZKBottomBar *)bottomBar;

- (void)bottomBarCollect:(ZKBottomBar *)bottomBar collectionBtn:(UIButton *)collectionBtn;

- (void)bottomBarComment:(ZKBottomBar *)bottomBar;

- (void)bottomBarLike:(ZKBottomBar *)bottomBar likeBtn:(UIButton *)likeBtn;

- (void)bottomBarUnlike:(ZKBottomBar *)bottomBar unlikeBtn:(UIButton *)unlikeBtn;

@end

@interface ZKBottomBar : UIView

/**
 *  返回按钮
 */
@property (nonatomic, weak) UIButton *backBtn;
/**
 *  收藏按钮
 */
@property (nonatomic, weak) UIButton *collectBtn;
/**
 *  评论按钮
 */
@property (nonatomic, weak) UIButton *commentBtn;
/**
 *  顶按钮
 */
@property (nonatomic, weak) UIButton *likeBtn;
/**
 *  踩按钮
 */
@property (nonatomic, weak) UIButton *unlikeBtn;



@property (nonatomic, assign) id<ZKBottomBarDelegate> delegate;

@end
