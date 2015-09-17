//
//  ZKStuffViewController.m
//  掌上科大
//
//  Created by 樊樊帅 on 7/4/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKStuffViewController.h"
#import "ZKStuffInfoModel.h"
#import "UIImageView+WebCache.h"
#import <BmobSDK/Bmob.h>

#define ZKNameFont [UIFont boldSystemFontOfSize:16]
#define ZKTimeFont [UIFont systemFontOfSize:13]
#define ZKUserNameFont [UIFont systemFontOfSize:13]
#define ZKInfoFont [UIFont systemFontOfSize:14]
#define ZKConnectFont [UIFont systemFontOfSize:14]

@interface ZKStuffViewController ()
/**
 *  物品图片
 */
@property (nonatomic, weak) UIImageView *imgView;
/**
 *  物品名称
 */
@property (nonatomic, weak) UILabel *name;
/**
 *  发布时间
 */
@property (nonatomic, weak) UILabel *timeLabel;
/**
 *  头像
 */
@property (nonatomic, weak) UIImageView *iconView;
/**
 *  昵称
 */
@property (nonatomic, weak) UILabel *userName;
/**
 *  物品信息
 */
@property (nonatomic, weak) UILabel *infoLabel;
/**
 *  联系方式
 */
@property (nonatomic, weak) UIButton *connectBtn;

@end

@implementation ZKStuffViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor blueColor];
    NSLog(@"...viewdidload");
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.infoLabel.numberOfLines = 0;
    
    BmobFile *imgFile = self.stuffModel.imgFile;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:imgFile.url] placeholderImage:[UIImage imageNamed:@"article_image_placeholder"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - delegate

#pragma mark - event response
- (void)connectClick {
    NSLog(@"%@", self.stuffModel.contactWay);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", self.stuffModel.contactWay]];
    [[UIApplication sharedApplication] openURL:url];
    
}

#pragma mark - private method
- (void)setupContent {
    CGFloat margin = 10;
    
    //图片
    self.imgView.width = screenW;
    self.imgView.height = screenW;
    self.imgView.centerX = self.view.centerX;
    self.imgView.y = 64;
    
    //物品名称
    self.name.height = 40;
    self.name.width = 150;
    self.name.y = CGRectGetMaxY(self.imgView.frame);
    self.name.x = margin;
    self.name.font = ZKNameFont;
    
    //分隔线
    UIView *cutOffLine = [[UIView alloc] init];
    cutOffLine.backgroundColor = RGBColor(220, 220, 220);
    cutOffLine.height = 0.5;
    cutOffLine.width = screenW;
    cutOffLine.x = 0;
    cutOffLine.y = CGRectGetMaxY(self.name.frame);
    [self.view addSubview:cutOffLine];
    
    //时间
    self.timeLabel.font = ZKTimeFont;
    self.timeLabel.text = _stuffModel.creatTime;
    [self.timeLabel sizeToFit];
    self.timeLabel.height = 40;
    self.timeLabel.y = self.name.y;
    self.timeLabel.x = screenW - margin - self.timeLabel.width;
    self.timeLabel.textColor = RGBColor(128, 128, 128);
    
    //头像
    self.iconView.x = margin;
    self.iconView.y = CGRectGetMaxY(self.name.frame) + margin;
    self.iconView.width = 25;
    self.iconView.height = 25;
    
    //昵称
    self.userName.x = CGRectGetMaxX(self.iconView.frame) + margin;
    self.userName.y = self.iconView.y;
//    BmobUser *user = self.stuffModel.announcer;
//    self.userName.text = user.username;
    self.userName.font = ZKUserNameFont;
    self.userName.height = 25;
    self.userName.width = 100;
    
    //信息
    self.infoLabel.y = CGRectGetMaxY(self.iconView.frame) + margin;
    self.infoLabel.x = margin;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = ZKInfoFont;
    CGSize infoSize = [self.stuffModel.information boundingRectWithSize:CGSizeMake(screenW - 2 * margin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    self.infoLabel.size = infoSize;
    self.infoLabel.font = ZKInfoFont;
    
    //联系方式
    self.connectBtn.width = 250;
    self.connectBtn.height = 30;
    self.connectBtn.x = (screenW - self.connectBtn.width) / 2;
    self.connectBtn.y = self.view.height * 0.93;
    [self.connectBtn setBackgroundImage:[UIImage imageNamed:@"connectBtn"] forState:UIControlStateNormal];
    [self.connectBtn setBackgroundImage:[UIImage imageNamed:@"connectBtn_highLight"] forState:UIControlStateHighlighted];
    [self.connectBtn addTarget:self action:@selector(connectClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - getters and setters
- (void)setStuffModel:(ZKStuffInfoModel *)stuffModel {
    _stuffModel = stuffModel;
    
    if (_stuffModel.found) {
        self.navigationItem.title = @"招领";
    } else {
        self.navigationItem.title = @"寻物";
    }
    
    [self setupContent];
    self.name.text = _stuffModel.name;
    self.infoLabel.text = _stuffModel.information;
    
    //设置发布用户信息
    NSString *userId = self.stuffModel.announcerId;
    BmobQuery *query = [BmobQuery queryWithClassName:@"_User"];
    [query getObjectInBackgroundWithId:userId block:^(BmobObject *object, NSError *error) {
        BmobUser *user = (BmobUser *)object;
        BmobFile *iconFile = [user objectForKey:@"icon"];
        NSString *username = [user objectForKey:@"username"];
        self.userName.text = username;
        [self.userName sizeToFit];
        self.userName.height = self.iconView.height;
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:iconFile.url] placeholderImage:[UIImage imageNamed:@"avatar_default_big"]];
    }];
}

- (UIImageView *)imgView {
    if (_imgView == nil) {
        UIImageView *view = [[UIImageView alloc] init];
        _imgView = view;
        [self.view addSubview:_imgView];
    }
    return _imgView;
}

- (UILabel *)name {
    if (_name == nil) {
        UILabel *label = [[UILabel alloc] init];
        _name = label;
        [self.view addSubview:_name];
    }
    return _name;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        _timeLabel = label;
        [self.view addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UIImageView *)iconView {
    if (_iconView == nil) {
        UIImageView *view = [[UIImageView alloc] init];
        _iconView = view;
        [self.view addSubview:_iconView];
    }
    return _iconView;
}

- (UILabel *)userName {
    if (_userName == nil) {
        UILabel *label = [[UILabel alloc] init];
        _userName = label;
        [self.view addSubview:_userName];
    }
    return _userName;
}

- (UILabel *)infoLabel {
    if (_infoLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        _infoLabel = label;
        [self.view addSubview:_infoLabel];
    }
    return _infoLabel;
}

- (UIButton *)connectBtn {
    if (_connectBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _connectBtn = btn;
        [self.view addSubview:_connectBtn];
    }
    return _connectBtn;
}

@end
