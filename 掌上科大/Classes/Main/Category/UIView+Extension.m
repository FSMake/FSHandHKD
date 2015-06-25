//
//  UIView+Extension.m
//  FS微博
//
//  Created by 樊樊帅 on 6/15/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)
#pragma mark - getters
- (CGFloat)x {
    return self.frame.origin.x;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (CGSize)size {
    return self.frame.size;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (CGFloat)centerY {
    return self.center.y;
}

#pragma mark - setters
- (void)setX:(CGFloat)x {
    CGRect tempRect = self.frame;
    tempRect.origin.x = x;
    self.frame = tempRect;
}

- (void)setY:(CGFloat)y {
    CGRect tempRect = self.frame;
    tempRect.origin.y = y;
    self.frame = tempRect;
}

- (void)setHeight:(CGFloat)height {
    CGRect tempRect = self.frame;
    tempRect.size.height = height;
    self.frame = tempRect;
}

- (void)setWidth:(CGFloat)width {
    CGRect tempRect = self.frame;
    tempRect.size.width = width;
    self.frame = tempRect;
}

- (void)setSize:(CGSize)size {
    CGRect tempRect = self.frame;
    tempRect.size = size;
    self.frame = tempRect;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect tempRect = self.frame;
    tempRect.origin = origin;
    self.frame = tempRect;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

@end
