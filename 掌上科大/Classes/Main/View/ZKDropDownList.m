//
//  FWDropDownList.m
//  FS微博
//
//  Created by 樊樊帅 on 6/16/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKDropDownList.h"

@interface ZKDropDownList()
/**
 *  下拉菜单的背景图片，即内容容器
 */
@property (nonatomic, weak) UIImageView *container;

@end

@implementation ZKDropDownList

#pragma mark - LifeCycle
+ (instancetype)dropDownList {
    //创建蒙版
    ZKDropDownList *mask = [[ZKDropDownList alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    mask.backgroundColor = [UIColor clearColor];
    return mask;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //添加下拉菜单气泡
        UIImageView *contanier = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popover_background"]];
        contanier.frame = CGRectMake(0, 100, 200, 200);
        self.container = contanier;
        self.container.userInteractionEnabled = YES;
        [self addSubview:contanier];
    }
    return self;
}

#pragma mark - event response
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self dismiss];
}

#pragma mark - private methods
/**
 *  显示菜单
 */
- (void)show {
    [[[UIApplication sharedApplication].windows lastObject] addSubview:self];
    //通知代理，菜单已显示
    if ([self.delegate respondsToSelector:@selector(dropDownListDidShow:)]) {
        [self.delegate dropDownListDidShow:self];
    }
}

/**
 *  销毁菜单
 */
- (void)dismiss {
    [self removeFromSuperview];
    //通知代理，菜单以消失
    if ([self.delegate respondsToSelector:@selector(dropDownListDidDismiss:)]) {
        [self.delegate dropDownListDidDismiss:self];
    }
}

#pragma mark - getters and setters
/**
 *  设置下拉菜单的内容位置
 */
- (void)setContentView:(UIView *)contentView {
    _contentView = contentView;
    self.container.height = contentView.height + 22;
    self.container.width = contentView.width + 16;
    _contentView.x = 8;
    _contentView.y = 13;
    [self.container addSubview:contentView];
}
/**
 *  传入控制器，将控制器的view作为contentView
 */
- (void)setTableViewVc:(UITableViewController *)tableViewVc {
#warning
    _tableViewVc = tableViewVc;
    self.contentView = tableViewVc.view;
}
/**
 *  设置呼出者
 */
- (void)setCaller:(UIView *)caller {
    CGRect newFrame = [caller convertRect:caller.bounds toView:[UIApplication sharedApplication].keyWindow];
//    NSLog(@"%@", NSStringFromCGRect(newFrame));
    self.container.centerX = CGRectGetMidX(newFrame);
    self.container.y = CGRectGetMaxY(newFrame) + 1;
}

@end
