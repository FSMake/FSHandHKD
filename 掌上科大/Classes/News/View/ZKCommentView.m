//
//  ZKCommentView.m
//  掌上科大
//
//  Created by 樊樊帅 on 7/5/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKCommentView.h"
#import <BmobSDK/Bmob.h>
#import "UIImageView+WebCache.h"

#define ZKUserNameFont [UIFont boldSystemFontOfSize:13]

@interface ZKCommentView()
/**
 *  头像
 */
@property (nonatomic, weak) UIImageView *iconView;
/**
 *  评论者用户名
 */
@property (nonatomic, weak) UILabel *name;
/**
 *  评论内容
 */
@property (nonatomic, weak) UILabel *content;

@end

@implementation ZKCommentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.width = screenW;
        self.height = 80;
        self.x = 0;
        UIView *cutoffLine = [[UIView alloc] initWithFrame:CGRectMake(0, -0.5, screenW, 0.5)];
        cutoffLine.backgroundColor = RGBColor(200, 200, 200);
        [self addSubview:cutoffLine];
    }
    return self;
}

- (void)setCommentModel:(ZKCommentModel *)commentModel {
    _commentModel = commentModel;
    
    CGFloat margin = 10;
    
    self.iconView.x = margin;
    self.iconView.y = margin;
    self.iconView.width = 25;
    self.iconView.height = 25;
//    self.iconView.backgroundColor = [UIColor redColor];
    BmobUser *user = commentModel.commenter;
    BmobFile *iconFile = [user objectForKey:@"icon"];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:iconFile.url] placeholderImage:[UIImage imageNamed:@"avatar_default_big"]];
    
    
    self.name.x = CGRectGetMaxX(self.iconView.frame) + margin;
    self.name.y = self.iconView.y;
    self.name.font = ZKUserNameFont;
    self.name.height = 25;
    self.name.width = 100;
//    self.name.backgroundColor = [UIColor grayColor];
    self.name.text = [user objectForKey:@"username"];
    
    self.content.x = margin;
    self.content.y = CGRectGetMaxY(self.iconView.frame) + margin;
    self.content.width = screenW - 2 * margin;
    self.content.height = 30;
//    self.content.backgroundColor = [UIColor greenColor];
    self.content.font = [UIFont systemFontOfSize:13];
    self.content.text = commentModel.content;
}

- (UIImageView *)iconView {
    if (_iconView == nil) {
        UIImageView *view = [[UIImageView alloc] init];
        _iconView = view;
        [self addSubview:_iconView];
    }
    return _iconView;
}

- (UILabel *)name {
    if (_name == nil) {
        UILabel *label = [[UILabel alloc] init];
        _name = label;
        [self addSubview:_name];
    }
    return _name;
}

- (UILabel *)content {
    if (_content == nil) {
        UILabel *label = [[UILabel alloc] init];
        _content = label;
        [self addSubview:_content];
    }
    return _content;
}

@end
