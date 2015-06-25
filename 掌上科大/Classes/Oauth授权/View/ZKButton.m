//
//  ZKButton.m
//  掌上科大
//
//  Created by 樊樊帅 on 6/24/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKButton.h"

@implementation ZKButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //11 182 0
        [self setTitleColor:RGBColor(11, 182, 0) forState:UIControlStateNormal];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self setBackgroundImage:[UIImage imageNamed:@"roundRectFill"] forState:UIControlStateHighlighted];
        [self setBackgroundImage:[UIImage imageNamed:@"roundRect"] forState:UIControlStateNormal];
    }
    return self;
}

@end
