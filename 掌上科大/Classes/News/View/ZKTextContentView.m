//
//  ZKTextContentView.m
//  掌上科大
//
//  Created by 樊樊帅 on 6/29/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKTextContentView.h"
#import "UIImageView+WebCache.h"

#define ZKTextFont [UIFont systemFontOfSize:18]

@implementation ZKTextContentView

- (instancetype)init {
    if (self = [super init]) {
        self.width = screenW - 10 * 2;
    }
    return self;
}

- (void)setTextContent:(NSString *)textContent {
    _textContent = textContent;
    NSString *parsingText = _textContent;
    
    while (1) {
        //第一个p标签的开头'<p>'的range
        NSRange pHeadTagRange = [parsingText rangeOfString:@"<p>"];
        
        //第一个p标签的结尾'</p>'的range
        NSRange pFootTagRang = [parsingText rangeOfString:@"</p>"];
        
        //第一个p标签中的内容range
        NSRange p1Range = NSMakeRange(pHeadTagRange.location + pHeadTagRange.length, pFootTagRang.location - (pHeadTagRange.location + pHeadTagRange.length));
        
        //第一段内容
        NSString *firstSection = [parsingText substringWithRange:p1Range];
        //图片tag的range
        NSRange imgTagRange = [firstSection rangeOfString:@"<img"];
        
        if (imgTagRange.length == 4) {//本段是一张图片
            UIView *lastView = [self.subviews lastObject];
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lastView.frame) + 20, self.width, 200)];
            [self addSubview:imgView];
            
            //第一个双引号位置
            NSRange firstQuoteRange = [firstSection rangeOfString:@"\""];
            //去除第一个双引号之前内容的字符串
            NSString *detailStr = [firstSection substringFromIndex:firstQuoteRange.location + firstQuoteRange.length];
            //第二个双引号位置
            NSRange secondQuoteRange = [detailStr rangeOfString:@"\""];
            //截出urlStr
            NSString *urlStr = [detailStr substringToIndex:secondQuoteRange.location + secondQuoteRange.length - 1];
            
            //加载图片
            
            [imgView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"article_image_placeholder"]];
            
        } else {//本段是文字内容
            UIView *lastView = [self.subviews lastObject];
            UILabel *label = [[UILabel alloc] init];
            label.font = ZKTextFont;
            label.numberOfLines = 0;
            label.text = firstSection;
            
            //设置label的段属性
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:label.text];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            
            [paragraphStyle setLineSpacing:6];//调整行间距
            
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [label.text length])];
            label.attributedText = attributedString;
            [label sizeToFit];
            
            //计算label尺寸
            NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
            attributes[NSFontAttributeName] = ZKTextFont;
            attributes[NSParagraphStyleAttributeName] = paragraphStyle;
            CGSize sectionSize = [label.text boundingRectWithSize:CGSizeMake(self.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            label.width = sectionSize.width;
            label.height = sectionSize.height;
            label.x = 0;
            label.y = CGRectGetMaxY(lastView.frame) + 20;
            
            [self addSubview:label];
        }
        
//        NSLog(@"%@", firstSection);
        //第一段之后的内容,继续解析
        parsingText = [parsingText substringFromIndex:pFootTagRang.location + pFootTagRang.length];
        
        if (parsingText.length == 0) {//解析完毕
            break;
        }
    }
    //设置内容高度
    UIView *lastView = [self.subviews lastObject];
    self.height = CGRectGetMaxY(lastView.frame) + 30;
}

@end
