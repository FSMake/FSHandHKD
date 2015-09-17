//
//  ZKBottomBar.m
//  掌上科大
//
//  Created by 樊樊帅 on 6/29/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKBottomBar.h"

@interface ZKBottomBar()


@end

@implementation ZKBottomBar

- (instancetype)init {
    if (self = [super init]) {
        self.width = screenW;
        self.height = 44;
        self.x = 0;
        self.y = screenH - self.height;
        self.backgroundColor = RGBColor(250, 250, 250);
        [self addBtns];
        
        UIView *cutoffLine = [[UIView alloc] initWithFrame:CGRectMake(0, -0.5, screenW, 0.5)];
        cutoffLine.backgroundColor = RGBColor(150, 150, 150);
        [self addSubview:cutoffLine];
    }
    return self;
}

- (void)addBtns {
    CGFloat btnW = self.width / 5;
    CGFloat btnH = self.height;
    
    self.backBtn.x = 0;
    self.backBtn.y = 0;
    self.backBtn.width = btnW;
    self.backBtn.height = btnH;
//    self.backBtn.backgroundColor = [UIColor redColor];
    [self.backBtn setImage:[UIImage imageNamed:@"bottomBar_back"] forState:UIControlStateNormal];
    [self.backBtn setImage:[UIImage imageNamed:@"bottomBar_back_highLight"] forState:UIControlStateHighlighted];
    [self.backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.collectBtn.x = btnW;
    self.collectBtn.y = 0;
    self.collectBtn.width = btnW;
    self.collectBtn.height = btnH;
//    self.collectBtn.backgroundColor = [UIColor blueColor];
    [self.collectBtn setImage:[UIImage imageNamed:@"bottomBar_collect"] forState:UIControlStateNormal];
    [self.collectBtn setImage:[UIImage imageNamed:@"bottomBar_collect_highLight"] forState:UIControlStateSelected];
    [self.collectBtn addTarget:self action:@selector(collectClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.commentBtn.x = btnW * 2;
    self.commentBtn.y = 0;
    self.commentBtn.width = btnW;
    self.commentBtn.height = btnH;
//    self.commentBtn.backgroundColor = [UIColor greenColor];
    [self.commentBtn setImage:[UIImage imageNamed:@"bottomBar_comment"] forState:UIControlStateNormal];
    [self.commentBtn setImage:[UIImage imageNamed:@"bottomBar_comment_highLight"] forState:UIControlStateHighlighted];
    [self.commentBtn addTarget:self action:@selector(commentClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.likeBtn.x = btnW * 3;
    self.likeBtn.y = 0;
    self.likeBtn.width = btnW;
    self.likeBtn.height = btnH;
//    self.likeBtn.backgroundColor = [UIColor grayColor];
    [self.likeBtn setImage:[UIImage imageNamed:@"bottomBar_like"] forState:UIControlStateNormal];
    [self.likeBtn setImage:[UIImage imageNamed:@"bottomBar_like_highLight"] forState:UIControlStateSelected];
    [self.likeBtn addTarget:self action:@selector(likeClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.unlikeBtn.x = btnW * 4;
    self.unlikeBtn.y = 0;
    self.unlikeBtn.width = btnW;
    self.unlikeBtn.height = btnH;
//    self.unlikeBtn.backgroundColor = [UIColor purpleColor];
    [self.unlikeBtn setImage:[UIImage imageNamed:@"bottomBar_unlike"] forState:UIControlStateNormal];
    [self.unlikeBtn setImage:[UIImage imageNamed:@"bottomBar_unlike_highLight"] forState:UIControlStateSelected];
    [self.unlikeBtn addTarget:self action:@selector(unlikeClick) forControlEvents:UIControlEventTouchUpInside];
}
/**
 *  返回点击
 */
- (void)backClick {
    NSLog(@"%s", __func__);
    if ([self.delegate respondsToSelector:@selector(bottomBarBack:)]) {
        [self.delegate bottomBarBack:self];
    }
}
/**
 *  收藏点击
 */
- (void)collectClick {
    NSLog(@"%s", __func__);
    if ([self.delegate respondsToSelector:@selector(bottomBarCollect:collectionBtn:)]) {
        [self.delegate bottomBarCollect:self collectionBtn:self.collectBtn];
    }
}
/**
 *  评论点击
 */
- (void)commentClick {
    NSLog(@"%s", __func__);
    if ([self.delegate respondsToSelector:@selector(bottomBarComment:)]) {
        [self.delegate bottomBarComment:self];
    }
}
/**
 *  赞点击
 */
- (void)likeClick {
    NSLog(@"%s", __func__);
    if ([self.delegate respondsToSelector:@selector(bottomBarLike:likeBtn:)]) {
        [self.delegate bottomBarLike:self likeBtn:self.likeBtn];
    }
}
/**
 *  踩点击
 */
- (void)unlikeClick {
    NSLog(@"%s", __func__);
    if ([self.delegate respondsToSelector:@selector(bottomBarUnlike:unlikeBtn:)]) {
        [self.delegate bottomBarUnlike:self unlikeBtn:self.unlikeBtn];
    }
}

#pragma setters and getters
- (UIButton *)backBtn {
    if (_backBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn = btn;
        [self addSubview:_backBtn];
    }
    return _backBtn;
}

- (UIButton *)collectBtn {
    if (_collectBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _collectBtn = btn;
        [self addSubview:_collectBtn];
    }
    return _collectBtn;
}

- (UIButton *)commentBtn {
    if (_commentBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentBtn = btn;
        [self addSubview:_commentBtn];
    }
    return _commentBtn;
}

- (UIButton *)likeBtn {
    if (_likeBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _likeBtn = btn;
        [self addSubview:_likeBtn];
    }
    return _likeBtn;
}

- (UIButton *)unlikeBtn {
    if (_unlikeBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _unlikeBtn = btn;
        [self addSubview:_unlikeBtn];
    }
    return _unlikeBtn;
}

@end
