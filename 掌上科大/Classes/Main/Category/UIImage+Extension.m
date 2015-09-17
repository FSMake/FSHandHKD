//
//  UIImage+Extension.m
//  掌上科大
//
//  Created by 樊樊帅 on 6/26/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)
/**
 *  图片压缩
 *
 *  @param image   要压缩的图片
 *  @param newSize 新尺寸
 *
 *  @return 压缩好的图片
 */
+ (UIImage *)newImageWithimage:(UIImage *)image newSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
