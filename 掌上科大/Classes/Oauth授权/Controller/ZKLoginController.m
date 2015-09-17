//
//  ZKLoginController.m
//  掌上科大
//
//  Created by 樊樊帅 on 6/24/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKLoginController.h"
#import "ZKButton.h"
#import "ZKUserPwdController.h"
#import "ZKRegisterController.h"
#import "WeiboSDK.h"

@interface ZKLoginController ()

@property (nonatomic, weak) ZKButton *loginBtn;

@property (nonatomic, weak) ZKButton *weiboLoginBtn;

@property (nonatomic, weak) ZKButton *registerBtn;

@property (nonatomic, weak) UIImageView *logo;

@property (nonatomic, weak) UILabel *logoTitle;

@end

@implementation ZKLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置背景图片
    UIImageView *bg = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bg.image = [UIImage imageNamed:@"bg"];
    [self.view addSubview:bg];
    
    //设置按钮
    [self setupBtns];
    
    //设置Logo和开场动画
    [self setupLogo];

}
/**
 *  设置状态栏颜色
 */
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method
/**
 *  设置按钮
 */
- (void)setupBtns {
    //按钮离边框距离
    CGFloat border = 35;
    //按钮高度
    CGFloat btnH = 40;
    
    //登录按钮
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    self.loginBtn.width = screenW - 2 * border;
    self.loginBtn.height = btnH;
    self.loginBtn.centerX = self.view.centerX;
    self.loginBtn.centerY = self.view.height * 0.80;
    
    //微博登录按钮
    [self.weiboLoginBtn setTitle:@"微博登陆" forState:UIControlStateNormal];
    [self.weiboLoginBtn addTarget:self action:@selector(weiboLogin) forControlEvents:UIControlEventTouchUpInside];
    self.weiboLoginBtn.width = (_loginBtn.width - 10) / 2;
    self.weiboLoginBtn.height = btnH;
    self.weiboLoginBtn.x = _loginBtn.x;
    self.weiboLoginBtn.y = CGRectGetMaxY(_loginBtn.frame) + 10;
    
    //注册按钮
    [self.registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [self.registerBtn addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    self.registerBtn.width = (_loginBtn.width - 10) / 2;
    self.registerBtn.height = btnH;
    self.registerBtn.x = CGRectGetMaxX(_weiboLoginBtn.frame) + 10;
    self.registerBtn.y = CGRectGetMaxY(_loginBtn.frame) + 10;
}
/**
 *  设置logo和开场动画
 */
- (void)setupLogo {
    //logo距离边框距离
    CGFloat border = 60;
    //logo高度
    CGFloat logoH = 80;
    //logo文字高度
    CGFloat logoTitleH = 20;
    //logo
    UIImageView *logo = [[UIImageView alloc] init];
    logo.width = screenW - 2 * border;
    logo.height = logoH;
    logo.centerY = self.view.height * 0.4;
    logo.centerX = -logo.height;
    logo.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:logo];
    self.logo = logo;
    
    //logo文字
    UILabel *logoTitle = [[UILabel alloc] init];
    logoTitle.width = logo.width + 50;
    logoTitle.height = logoTitleH;
    logoTitle.x = screenW;
    logoTitle.centerY = self.view.height * 0.5;
    self.logoTitle = logoTitle;
    self.logoTitle.textAlignment = NSTextAlignmentCenter;
    self.logoTitle.text = @"做  有  态  度  的  科  大  人";
    [self.view addSubview:_logoTitle];
    _logoTitle = logoTitle;
    
    //开场动画
    [UIView animateWithDuration:1.0 animations:^{
        logo.center = self.view.center;
        logo.centerY = self.view.height * 0.4;
        logoTitle.centerX = self.view.centerX;
        logoTitle.centerY = self.view.height * 0.5;
    }];
}
#pragma mark - event response
- (void)login {
    NSLog(@"登录");
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.layer.transform = CATransform3DMakeRotation(M_PI_2, 0, 1, 0);
    } completion:^(BOOL finished) {
        ZKUserPwdController *nextVc = [[ZKUserPwdController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = nextVc;
    }];
}

#warning 微博登陆
- (void)weiboLogin {
    NSLog(@"微博登陆");
    
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

- (void)registerClick {
    NSLog(@"注册");
    [UIView animateWithDuration:0.3 animations:^{
        self.view.layer.transform = CATransform3DMakeRotation(M_PI_2, 0, 1, 0);
    } completion:^(BOOL finished) {
        ZKRegisterController *nextVc = [[ZKRegisterController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = nextVc;
    }];
}

#pragma mark - setters and getters
- (ZKButton *)loginBtn {
    if (_loginBtn == nil) {
        ZKButton *loginBtn = [[ZKButton alloc] init];
        _loginBtn = loginBtn;
        [self.view addSubview:_loginBtn];
    }
    return _loginBtn;
}

- (ZKButton *)weiboLoginBtn {
    if (_weiboLoginBtn == nil) {
        ZKButton *loginBtn = [[ZKButton alloc] init];
        _weiboLoginBtn = loginBtn;
        [self.view addSubview:_weiboLoginBtn];
    }
    return _weiboLoginBtn;
}

- (ZKButton *)registerBtn {
    if (_registerBtn == nil) {
        ZKButton *loginBtn = [[ZKButton alloc] init];
        _registerBtn = loginBtn;
        [self.view addSubview:_registerBtn];
    }
    return _registerBtn;
}

@end
