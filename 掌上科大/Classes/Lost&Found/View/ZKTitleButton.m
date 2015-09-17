//
//  FWTitleButton.m
//  FS微博
//
//  Created by 樊樊帅 on 6/19/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKTitleButton.h"

@implementation ZKTitleButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
        [self.titleLabel setTextColor:[UIColor whiteColor]];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateSelected];
        self.imageView;
    }
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    [self sizeToFit];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.x = self.imageView.x;
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + 10;
}

@end
