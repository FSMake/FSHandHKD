//
//  FWTitleDropController.m
//  FS微博
//
//  Created by 樊樊帅 on 6/16/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKTitleDropController.h"

@implementation ZKTitleDropController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
//    [self.tableView addGestureRecognizer:tap];
}
//
//- (void)tap {
//    NSLog(@"...");
//}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.tableView.width = 150;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.height = 3 * 30;
    }
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"显示全部";
            break;
        case 1:
            cell.textLabel.text = @"只看招领";
            break;
        case 2:
            cell.textLabel.text = @"只看失物";
            break;
            break;
        default:
            break;
    }
    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18.0]];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {//显示全部
        if ([self.delegate respondsToSelector:@selector(titleDropControllerDidSelectedShowAll:)]) {
            [self.delegate titleDropControllerDidSelectedShowAll:self];
        }
    } else if (indexPath.row == 1) {//只看招领
        if ([self.delegate respondsToSelector:@selector(titleDropControllerDidSelectedShowFound:)]) {
            [self.delegate titleDropControllerDidSelectedShowFound:self];
        }
    }else if (indexPath.row == 2) {//只看失物
        if ([self.delegate respondsToSelector:@selector(titleDropControllerDidSelectedShowLost:)]) {
            [self.delegate titleDropControllerDidSelectedShowLost:self];
        }
    }
}

@end
