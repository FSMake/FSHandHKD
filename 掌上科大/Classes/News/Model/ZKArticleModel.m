//
//  ZKArticleModel.m
//  掌上科大
//
//  Created by 樊樊帅 on 6/28/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKArticleModel.h"
#import "UIImageView+WebCache.h"


@implementation ZKArticleModel

+ (instancetype)articleWithArticleObj:(BmobObject *)articleObj {
    ZKArticleModel *article = [[ZKArticleModel alloc] init];
    article.articleObj = articleObj;
    return article;
}
/**
 *  根据文章对象设置模型
 */
- (void)setArticleObj:(BmobObject *)articleObj {
    _articleObj = articleObj;
    //取出文章对象中的数据
    NSString *title = [articleObj objectForKey:@"title"];
    NSString *author = [articleObj objectForKey:@"author"];
    NSString *intro = [articleObj objectForKey:@"intro"];
    NSNumber *likeCount = [articleObj objectForKey:@"likeCount"];
    NSNumber *unlikeCount = [articleObj objectForKey:@"unlikeCount"];
    BmobFile *indexImg = [articleObj objectForKey:@"indexImg"];
    NSDate *date = [articleObj objectForKey:@"date"];
    NSString *content = [articleObj objectForKey:@"content"];
    int index = [[articleObj objectForKey:@"index"] intValue];
    
    //使用文章的数据构造模型
    self.title = title;
    self.author = author;
    self.intro = intro;
    self.likeCount = [likeCount intValue];
    self.unlikeCount = [unlikeCount intValue];
    self.indexImgUrl = indexImg.url;
    self.date = date;
    self.content = content;
    self.objectId = articleObj.objectId;
    self.index = index;
//    NSLog(@"objecttId---------%@", self.objectId);
    
//    NSLog(@"title:%@", self.title);
//    NSLog(@"date:%@", self.date);
//    NSLog(@"author:%@", self.author);
//    NSLog(@"intro:%@", self.intro);
//    NSLog(@"indexImg:%@", self.indexImgUrl);
//    NSLog(@"content:%@", self.content);
//    NSLog(@"likeCount:%d", self.likeCount);
//    NSLog(@"unlikeCount:%d", self.unlikeCount);
}
/**
 *  设置日期
 */
- (void)setDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    BOOL isYesterday = [calendar isDateInYesterday:date];
    BOOL isTody = [calendar isDateInToday:date];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    
    if (isTody) {//是今天
        _date = [NSString stringWithFormat:@"Today, %ld:%ld", (long)components.hour, (long)components.minute];
    } else if (isYesterday) {//是昨天
        _date = [NSString stringWithFormat:@"Yesterday, %ld:%ld", (long)components.hour, (long)components.minute];
    } else {//更早
        _date = [NSString stringWithFormat:@"%ld/%ld/%ld, %ld:%ld", components.month, components.day, components.year % 100, (long)components.hour, (long)components.minute];
    }
}

@end
