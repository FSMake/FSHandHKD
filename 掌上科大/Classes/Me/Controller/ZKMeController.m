//
//  ZKMeController.m
//  掌上科大
//
//  Created by 樊樊帅 on 6/26/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKMeController.h"
#import "ZKSettingController.h"
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobProFile.h>
#import "MBProgressHUD+MJ.h"
#import "UIImageView+WebCache.h"
#import "ZKProfileController.h"
#import "ZKScoreController.h"
#import "ZKLevelController.h"
#import "ZKCollectionController.h"
#import "ZKMessageController.h"
#import "ZKRelationshipController.h"

#define ZKCutOffLineColor RGBColor(200, 200, 200)
#define ZKMeBtnFont [UIFont systemFontOfSize:15]

@interface ZKMeController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

//--------------top--------------------
/**
 *  顶部view
 */
@property (nonatomic, weak) UIImageView *topView;
/**
 *  头像
 */
@property (nonatomic, weak) UIImageView *iconView;
/**
 *  昵称
 */
@property (nonatomic, weak) UILabel *nameLbale;
/**
 *  个性签名
 */
@property (nonatomic, weak) UILabel *signLable;
/**
 *  中部Bar
 */
@property (nonatomic, weak) UIView *centerBar;
/**
 *  签到按钮
 */
@property (nonatomic, weak) UIButton *signUpBtn;
/**
 *  积分按钮
 */
@property (nonatomic, weak) UIButton *scoreBtn;
/**
 *  等级按钮
 */
@property (nonatomic, weak) UIButton *levelBtn;
/**
 *  收藏按钮
 */
@property (nonatomic, weak) UIButton *collectBtn;
/**
 *  资料按钮
 */
@property (nonatomic, weak) UIButton *profileBtn;
/**
 *  信息按钮
 */
@property (nonatomic, weak) UIButton *messageBtn;
/**
 *  关系按钮
 */
@property (nonatomic, weak) UIButton *relationshipBtn;

@end

@implementation ZKMeController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //背景色
    self.view.backgroundColor = [UIColor whiteColor];
    
    //注册监听器，监听用户数据修改事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDataUpdate) name:@"userDataUpdate" object:nil];
    
    //设置导航栏
    [self setupNav];
    
    //获取用户
    BmobUser *user = [BmobUser getCurrentUser];
    
    //设置顶部背景颜色
    self.topView.image = [UIImage imageNamed:@"topViewBg"];
    
    //设置头像
    self.iconView.userInteractionEnabled = YES;
    //绑定监听事件，点击换头像
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTap)];
    [self.iconView addGestureRecognizer:tap];
    //如果用户在服务器上有头像，就去下载
    if ([user objectForKey:@"icon"]) {//有头像，下载
        BmobFile *iconFile = [user objectForKey:@"icon"];
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:iconFile.url] placeholderImage:[UIImage imageNamed:@"avatar_default_big"]];
    } else {//没头像，使用占位图
        self.iconView.image = [UIImage imageNamed:@"avatar_default_big"];
    }
    
    //设置昵称
    self.nameLbale.text = user.username;
    [self.nameLbale sizeToFit];
    self.nameLbale.centerX = screenW / 2;
    
    //设置个性签名
    if ([user objectForKey:@"sign"]) {
        self.signLable.text = [user objectForKey:@"sign"];//[NSString stringWithFormat:@"个性签名:%@", [user objectForKey:@"sign"]];
    } else {
        self.signLable.text = @"点击资料编辑个性签名";
    }
    
    //设置中部的bar
    [self setupCenterBar];
    //设置下面的四个按钮
    [self setupBtns];
    //设置分隔线
    [self setupCutOffLine];
    
    //判断是否可以签到
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDate *lastSignUpDate = [userDefaults objectForKey:[BmobUser getCurrentUser].username];
    if (lastSignUpDate == nil) {//是第一次签到
        self.signUpBtn.enabled = YES;
    } else {//不是第一次签到
        NSCalendar *calendar = [NSCalendar currentCalendar];
        [calendar setTimeZone:[NSTimeZone systemTimeZone]];
        BOOL isToday = [calendar isDateInToday:lastSignUpDate];
        if (isToday) {//今天签过到
            self.signUpBtn.enabled = NO;
        } else {//今天没有签过到
            self.signUpBtn.enabled = YES;
        }
    }
    
    self.relationshipBtn.hidden = YES;
    self.messageBtn.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate
#pragma mark UIActionSheetDelegate
/**
 *  换头像
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 2) return;//取消
    
    UIImagePickerController *imgPickerVc = [[UIImagePickerController alloc] init];
    imgPickerVc.delegate = self;
    
    if (buttonIndex == 0) {//相册
        imgPickerVc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else if (buttonIndex == 1) {//拍照
        imgPickerVc.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    [self presentViewController:imgPickerVc animated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate
/**
 *  选择头像之后调用，将头像处理，并上传
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *bigIcon = info[@"UIImagePickerControllerOriginalImage"];
        
        UIImage *newIcon = [UIImage newImageWithimage:bigIcon newSize:CGSizeMake(140, 140)];
        
        BmobUser *user = [BmobUser getCurrentUser];
        
        //将头像上传到服务器
        //2.图片转data
        NSData *iconData = UIImagePNGRepresentation(newIcon);
        
        BmobFile *iconFile = [[BmobFile alloc] initWithFileName:[NSString stringWithFormat:@"%@_icon.png", user.objectId] withFileData:iconData];
        
        //上传头像到服务器
        [MBProgressHUD showMessage:@"正在应用新头像"];
        [iconFile saveInBackground:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {//头像上传成功
                NSLog(@"头像上传成功");
                //将头像文件保存至user的icon字段
                [user setObject:iconFile forKey:@"icon"];
                [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        NSLog(@"头像信息保存成功");
                        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].windows lastObject]];
                        [MBProgressHUD showSuccess:@"修改成功"];
                        self.iconView.image = newIcon;
                    } else {
                        NSLog(@"头像信息保存失败---%@", error);
                        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].windows lastObject]];
                        [MBProgressHUD showError:@"头像信息保存失败"];
                    }
                }];
            } else {
                NSLog(@"头像上传失败");
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].windows lastObject]];
                [MBProgressHUD showError:@"头像上传失败"];
            }
        }];
    }];
}

#pragma mark - event response
/**
 *  设置按钮点击
 */
- (void)setting {
    NSLog(@"设置");
    ZKSettingController *settingVc = [[ZKSettingController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:settingVc animated:YES];
}
/**
 *  收藏按钮点击
 */
- (void)collectionClick {
    ZKCollectionController *collectionVc = [[ZKCollectionController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:collectionVc animated:YES];
}
/**
 *  信息按钮点击
 */
- (void)messageBtnClick {
    ZKMessageController *messageVc = [[ZKMessageController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:messageVc animated:YES];
}

/**
 *  资料按钮点击
 */
- (void)profileClick {
    NSLog(@"资料");
    
    ZKProfileController *profileVc = [[ZKProfileController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:profileVc animated:YES];
}
/**
 *  监听用户信息修改通知的回调
 */
- (void)userDataUpdate {
    NSLog(@"用户信息更新了");
    BmobUser *user = [BmobUser getCurrentUser];
    //设置个性签名
    if ([user objectForKey:@"sign"]) {
        self.signLable.text = [user objectForKey:@"sign"];//[NSString stringWithFormat:@"个性签名:%@", [user objectForKey:@"sign"]];
    } else {
        self.signLable.text = @"点击资料编辑个性签名";
    }
}
/**
 *  积分按钮点击
 */
- (void)scoreBtnClick {
    NSLog(@"查看积分");
    ZKScoreController *scoreController = [[ZKScoreController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:scoreController animated:YES];
}
/**
 *  签到按钮点击
 */
- (void)signUpBtnClick {
    NSLog(@"签到");
    
    //积分+1
    BmobUser *user = [BmobUser getCurrentUser];
    NSNumber *userScore = [user objectForKey:@"score"];
    int score = [userScore intValue] + 1;
    [user setObject:[NSNumber numberWithInt:score] forKey:@"score"];
    [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [MBProgressHUD showSuccess:@"积分 +1"];
            
            //更新最后一次签到的时间
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:[BmobUser getCurrentUser].username];
            self.signUpBtn.enabled = NO;
            
            //判断等级
            NSNumber *userLevel = [NSNumber numberWithInt:0];
            switch ([userScore intValue]) {
                case 0:
                    userLevel = @1;
                    break;
                case 9:
                    userLevel = @2;
                    break;
                case 29:
                    userLevel = @3;
                    break;
                case 59:
                    userLevel = @4;
                    break;
                case 99:
                    userLevel = @5;
                    break;
                    
                default:
                    return;
            }
            //来到这里，说明升级了
            [user setObject:userLevel forKey:@"level"];
            [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    [MBProgressHUD showSuccess:@"升级了"];
                } else {
                    NSLog(@"等级更新失败");
                }
            }];
            
        } else {//签到失败
            NSLog(@"失败");
            [MBProgressHUD showError:@"签到失败"];
        }
    }];
}
/**
 *  等级按钮点击
 */
- (void)levelBtnClick {
    NSLog(@"查看等级");
    ZKLevelController *levelController = [[ZKLevelController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:levelController animated:YES];
}
/**
 *  头像点击
 */
- (void)iconTap {
    NSLog(@"更换头像");
    //弹出询问框
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择头像来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册", @"拍照", nil];
    [actionSheet showInView:self.view];
}
/**
 *  关系按钮点击
 */
- (void)relationshipClick {
    ZKRelationshipController *relationshipVc = [[ZKRelationshipController alloc] init];
    [self.navigationController pushViewController:relationshipVc animated:YES];
}
#pragma mark - private method
/**
 *  设置底部4个按钮
 */
- (void)setupBtns {
    CGFloat btnH = (CGRectGetMinY(self.tabBarController.tabBar.frame) - CGRectGetMaxY(_centerBar.frame)) / 2;
    CGFloat btnW = screenW / 2;
    NSLog(@"%f", btnH);
    
    //收藏按钮
    self.collectBtn.width = btnW;
    [self.collectBtn setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
    [self.collectBtn setImage:[UIImage imageNamed:@"collection_highLight"] forState:UIControlStateHighlighted];
    [self.collectBtn setBackgroundImage:[UIImage imageNamed:@"navBgBlue"] forState:UIControlStateHighlighted];
    [self.collectBtn addTarget:self action:@selector(collectionClick) forControlEvents:UIControlEventTouchUpInside];
    [self.collectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.collectBtn.height = btnH * 2;
    self.collectBtn.x = 0;
    self.collectBtn.y = CGRectGetMaxY(_centerBar.frame);
    
    //资料按钮
    self.profileBtn.backgroundColor = randomColor;
    [self.profileBtn setImage:[UIImage imageNamed:@"profile"] forState:UIControlStateNormal];
    [self.profileBtn setImage:[UIImage imageNamed:@"profile_highLight"] forState:UIControlStateHighlighted];
    [self.profileBtn setBackgroundImage:[UIImage imageNamed:@"navBgBlue"] forState:UIControlStateHighlighted];
    self.profileBtn.width = btnW;
    self.profileBtn.height = btnH * 2;
    self.profileBtn.x = btnW;
    self.profileBtn.y = CGRectGetMaxY(_centerBar.frame);
    
    //信息按钮
    self.messageBtn.backgroundColor = randomColor;
    [self.messageBtn setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
    [self.messageBtn setImage:[UIImage imageNamed:@"message_highLight"] forState:UIControlStateHighlighted];
    [self.messageBtn setBackgroundImage:[UIImage imageNamed:@"navBgBlue"] forState:UIControlStateHighlighted];
    [self.messageBtn addTarget:self action:@selector(messageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.messageBtn.width = btnW;
    self.messageBtn.height = btnH;
    self.messageBtn.x = 0;
    self.messageBtn.y = CGRectGetMaxY(_collectBtn.frame);
    
    //关系按钮
    self.relationshipBtn.backgroundColor = randomColor;
    [self.relationshipBtn setImage:[UIImage imageNamed:@"relationship"] forState:UIControlStateNormal];
    [self.relationshipBtn setImage:[UIImage imageNamed:@"relationship_highLight"] forState:UIControlStateHighlighted];
    [self.relationshipBtn setBackgroundImage:[UIImage imageNamed:@"navBgBlue"] forState:UIControlStateHighlighted];
    [self.relationshipBtn addTarget:self action:@selector(relationshipClick) forControlEvents:UIControlEventTouchUpInside];
    self.relationshipBtn.width = btnW;
    self.relationshipBtn.height = btnH;
    self.relationshipBtn.x = btnW;
    self.relationshipBtn.y = CGRectGetMaxY(_collectBtn.frame);
}
/**
 *  设置分隔线
 */
- (void)setupCutOffLine {
    
    
    UIView *cutOffLine1 = [[UIView alloc] init];
    cutOffLine1.width = screenW;
    cutOffLine1.height = 0.5;
    cutOffLine1.x = 0;
    cutOffLine1.y = CGRectGetMaxY(_centerBar.frame);
    cutOffLine1.backgroundColor = ZKCutOffLineColor;
    [self.view addSubview:cutOffLine1];
    
    UIView *cutOffLine2 = [[UIView alloc] init];
    cutOffLine2.width = screenW;
    cutOffLine2.height = 0.5;
    cutOffLine2.x = 0;
    cutOffLine2.y = CGRectGetMaxY(_collectBtn.frame);
    cutOffLine2.backgroundColor = ZKCutOffLineColor;
    [self.view addSubview:cutOffLine2];
    
    UIView *cutOffLine3 = [[UIView alloc] init];
    cutOffLine3.width = 0.5;
    cutOffLine3.height = 2 * _collectBtn.height;
    cutOffLine3.centerX = screenW / 2;
    cutOffLine3.y = CGRectGetMaxY(_centerBar.frame);
    cutOffLine3.backgroundColor = ZKCutOffLineColor;
    [self.view addSubview:cutOffLine3];
    
    UIView *cutOffLine4 = [[UIView alloc] init];
    cutOffLine4.width = 1;
    cutOffLine4.height = _centerBar.height;
    cutOffLine4.x = CGRectGetMaxX(_signUpBtn.frame);
    cutOffLine4.y = 0;
    cutOffLine4.backgroundColor = ZKCutOffLineColor;
    [self.centerBar addSubview:cutOffLine4];
    
    UIView *cutOffLine5 = [[UIView alloc] init];
    cutOffLine5.width = 1;
    cutOffLine5.height = _centerBar.height;
    cutOffLine5.x = CGRectGetMaxX(_scoreBtn.frame);
    cutOffLine5.y = 0;
    cutOffLine5.backgroundColor = ZKCutOffLineColor;
    [self.centerBar addSubview:cutOffLine5];
}
/**
 *  设置中间的bar
 */
- (void)setupCenterBar {
    CGFloat btnW = self.centerBar.width / 3;
    CGFloat btnH = self.centerBar.height;
    
    self.signUpBtn.width = btnW;
    self.signUpBtn.height = btnH;
    self.signUpBtn.backgroundColor = randomColor;
    [self.signUpBtn setImage:[UIImage imageNamed:@"signup"] forState:UIControlStateNormal];
    [self.signUpBtn addTarget:self action:@selector(signUpBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.signUpBtn.x = 0;
    self.signUpBtn.y = 0;
    
    self.scoreBtn.width = btnW;
    self.scoreBtn.height = btnH;
    self.scoreBtn.backgroundColor = randomColor;
    [self.scoreBtn setImage:[UIImage imageNamed:@"score"] forState:UIControlStateNormal];
    [self.scoreBtn addTarget:self action:@selector(scoreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.scoreBtn.x = btnW;
    self.scoreBtn.y = 0;
    
    self.levelBtn.width = btnW;
    self.levelBtn.height = btnH;
    self.levelBtn.backgroundColor = randomColor;
    [self.levelBtn addTarget:self action:@selector(levelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.levelBtn setImage:[UIImage imageNamed:@"level"] forState:UIControlStateNormal];
    self.levelBtn.x = 2 * btnW;
    self.levelBtn.y = 0;
}
/**
 *  设置导航栏
 */
- (void)setupNav {
    //导航栏设置
    self.navigationItem.title = @"我";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(setting)];
}

#pragma mark - getters and setters

- (UIImageView *)topView {
    if (_topView == nil) {
        UIImageView *view = [[UIImageView alloc] init];
        view.width = screenW;
        view.height = screenW * 0.6;
        view.x = 0;
        view.y = 64;
        _topView = view;
        _topView.userInteractionEnabled = YES;
        
        [self.view addSubview:_topView];
    }
    return _topView;
}

- (UIImageView *)iconView {
    if (_iconView == nil) {
        UIImageView *view = [[UIImageView alloc] init];
        view.backgroundColor = randomColor;
        view.width = 70;
        view.height = 70;
        view.centerX = screenW * 0.5;
        view.centerY = _topView.height * 0.35;
        view.layer.cornerRadius = view.width / 2;
        [view clipsToBounds];
        view.layer.masksToBounds = YES;
        _iconView = view;
        [_topView addSubview:_iconView];
    }
    return _iconView;
}

- (UILabel *)nameLbale {
    if (_nameLbale == nil) {
        UILabel *lable = [[UILabel alloc] init];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = [UIColor whiteColor];
        lable.width = 80;
        lable.height = 20;
        lable.centerX = screenW * 0.5;
        lable.centerY = _topView.height * 0.67;
        _nameLbale = lable;
        [_topView addSubview:_nameLbale];
    }
    return _nameLbale;
}

- (UILabel *)signLable {
    if (_signLable == nil) {
        UILabel *lable = [[UILabel alloc] init];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.numberOfLines = 2;
        lable.font = [UIFont systemFontOfSize:13];
        //        lable.backgroundColor = randomColor;
        lable.textColor = [UIColor whiteColor];
        lable.width = 200;
        lable.height = 35;
        lable.centerX = screenW * 0.5;
        lable.centerY = _topView.height * 0.85;
        _signLable = lable;
        [_topView addSubview:_signLable];
    }
    return _signLable;
}

- (UIView *)centerBar {
    if (_centerBar == nil) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = randomColor;
        view.width = screenW;
        view.height = 40;
        view.x = 0;
        view.y = CGRectGetMaxY(_topView.frame);
        _centerBar = view;
        [self.view addSubview:_centerBar];
    }
    return _centerBar;
}

- (UIButton *)signUpBtn {
    if (_signUpBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _signUpBtn = btn;
        btn.backgroundColor = randomColor;
        [self.centerBar addSubview:_signUpBtn];
    }
    return _signUpBtn;
}

- (UIButton *)scoreBtn {
    if (_scoreBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _scoreBtn = btn;
        [self.centerBar addSubview:_scoreBtn];
    }
    return _scoreBtn;
}

- (UIButton *)levelBtn {
    if (_levelBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _levelBtn = btn;
        [self.centerBar addSubview:_levelBtn];
    }
    return _levelBtn;
}

- (UIButton *)collectBtn {
    if (_collectBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _collectBtn = btn;
        [self.view addSubview:_collectBtn];
    }
    return _collectBtn;
}

- (UIButton *)profileBtn {
    if (_profileBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _profileBtn = btn;
        [_profileBtn addTarget:self action:@selector(profileClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_profileBtn];
    }
    return _profileBtn;
}

- (UIButton *)messageBtn {
    if (_messageBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _messageBtn = btn;
        [self.view addSubview:_messageBtn];
    }
    return _messageBtn;
}

- (UIButton *)relationshipBtn {
    if (_relationshipBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _relationshipBtn = btn;
        [self.view addSubview:_relationshipBtn];
    }
    return _relationshipBtn;
}

@end