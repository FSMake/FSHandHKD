//
//  ZKStuffInfoModel.m
//  掌上科大
//
//  Created by 樊樊帅 on 7/1/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKStuffInfoModel.h"

@implementation ZKStuffInfoModel

+ (instancetype)stuffInfoModelWithStuffInfoObject:(BmobObject *)object {
    ZKStuffInfoModel *stuffInfoModel = [[ZKStuffInfoModel alloc] init];
    
    stuffInfoModel.stuffInfoObj = object;
    
    return stuffInfoModel;
}

- (void)setStuffInfoObj:(BmobObject *)stuffInfoObj {
    NSString *name = [stuffInfoObj objectForKey:@"name"];
    NSString *information = [stuffInfoObj objectForKey:@"information"];
    NSString *contactWay = [stuffInfoObj objectForKey:@"contactWay"];
    BmobFile *imgFile = [stuffInfoObj objectForKey:@"stuffImg"];
    BOOL found = [[stuffInfoObj objectForKey:@"found"] boolValue];
    NSDate *creatTime = stuffInfoObj.createdAt;
    BmobUser *announcer = [stuffInfoObj objectForKey:@"announcer"];
    
    self.name = name;
    self.information = information;
    self.contactWay = contactWay;
    self.imgFile = imgFile;
    self.found = found;
    self.creatTime = creatTime;
    self.announcerId = announcer.objectId;
    
//    NSLog(@"%@", self.name);
//    NSLog(@"%@", self.information);
//    NSLog(@"%@", self.contactWay);
//    NSLog(@"%@", self.imgFile);
//    NSLog(@"%d", self.found);
//    NSLog(@"%@", self.creatTime);
    NSLog(@"%@", self.announcerId);
}

- (void)setCreatTime:(NSDate *)creatTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    BOOL isYesterday = [calendar isDateInYesterday:creatTime];
    BOOL isTody = [calendar isDateInToday:creatTime];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:creatTime];
    
    if (isTody) {//是今天
        _creatTime = [NSString stringWithFormat:@"今天, %ld:%ld", (long)components.hour, (long)components.minute];
    } else if (isYesterday) {//是昨天
        _creatTime = [NSString stringWithFormat:@"昨天, %ld:%ld", (long)components.hour, (long)components.minute];
    } else {//更早
        _creatTime = [NSString stringWithFormat:@"%ld/%ld/%ld, %ld:%ld", components.month, components.day, components.year % 100, (long)components.hour, (long)components.minute];
    }
}

@end
