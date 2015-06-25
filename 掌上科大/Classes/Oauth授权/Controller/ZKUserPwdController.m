//
//  ZKUserPwdController.m
//  掌上科大
//
//  Created by 樊樊帅 on 6/24/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKUserPwdController.h"
#import "ZKLoginController.h"
#import <BmobSDK/Bmob.h>
#import "MBProgressHUD+MJ.h"

@interface ZKUserPwdController ()

@property (nonatomic, weak) UITextField *userField;

@property (nonatomic, weak) UITextField *pwdField;

@property (nonatomic, weak) UIButton *loginBtn;

@end

@implementation ZKUserPwdController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置翻转动画
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.layer.transform = CATransform3DMakeRotation(M_PI_2, 0, 1, 0);
    [UIView animateWithDuration:0.3 animations:^{
        self.view.layer.transform = CATransform3DIdentity;
    }];
    //设置导航栏
    [self setupNav];
    //设置输入框
    [self setupTextFileds];
    //设置按钮
    [self setupBtns];

    //判断登录按钮是否可点
    [self textChange];
    
    [self.userField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - event response
/**
 *  点击了取消
 */
- (void)cancle {
    [UIView animateWithDuration:0.3 animations:^{
        self.view.layer.transform = CATransform3DMakeRotation(M_PI_2, 0, 1, 0);
    } completion:^(BOOL finished) {
        ZKLoginController *nextVc = [[ZKLoginController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = nextVc;
    }];
}
/**
 *  输入文字时调用，判断登录按钮是否可点
 */
- (void)textChange {
    _loginBtn.enabled = _userField.text.length && _pwdField.text.length;
}
/**
 *  点击了登录按钮
 */
- (void)loginClick {
    NSString *username = _userField.text;
    NSString *pwd = _pwdField.text;
    //向服务器发送登录请求
    [BmobUser loginInbackgroundWithAccount:username andPassword:pwd block:^(BmobUser *user, NSError *error) {
        if (error) {
            [MBProgressHUD showError:@"用户名或密码错误"];
        } else {
            [MBProgressHUD showSuccess:@"登录成功"];
            NSLog(@"%@", user);
        }
    }];
}

#pragma mark - private method
/**
 *  设置导航栏
 */
- (void)setupNav {
    //加一个导航条
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    [bar setBackgroundColor:[UIColor whiteColor]];
    //给导航条设置一个item
    UINavigationItem *titleItem = [[UINavigationItem alloc] initWithTitle:@"登录"];
    titleItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancle)];
    
    //设置导航条主题色为黑色
    [bar setTintColor:[UIColor blackColor]];
    
    //此方法用于将item应用于导航条
    [bar pushNavigationItem:titleItem animated:YES];
    
    [self.view addSubview:bar];
}

- (void)setupTextFileds {
    //用户名区域
    [self.userField setPlaceholder:@"请输入用户名"];
    [self.userField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    
    //分隔线
    UIView *userCutOffLine = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.userField.frame), self.view.width, 1)];
    userCutOffLine.backgroundColor = RGBColor(220, 220, 220);
    [self.view addSubview:userCutOffLine];
    
    //密码区域
    [self.pwdField setPlaceholder:@"请输入密码"];
    [self.pwdField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    
    //分隔线
    UIView *userCutOffLine2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.pwdField.frame), self.view.width, 1)];
    userCutOffLine2.backgroundColor = RGBColor(220, 220, 220);
    [self.view addSubview:userCutOffLine2];
}
/**
 *  设置按钮
 */
- (void)setupBtns {
    
    //忘记密码按钮
    UIButton *forgetPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetPwdBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetPwdBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [forgetPwdBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [forgetPwdBtn sizeToFit];
    forgetPwdBtn.x = self.view.width - forgetPwdBtn.width - 15;
    forgetPwdBtn.y = CGRectGetMaxY(self.pwdField.frame) + 5;
    [self.view addSubview:forgetPwdBtn];
    
    //登录按钮
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"btnBg"] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"btnHighLight"] forState:UIControlStateHighlighted];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:RGBColor(11, 182, 0) forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    loginBtn.x = 10;
    loginBtn.width = screenW - 2 * loginBtn.x;
    loginBtn.height = 40;
    loginBtn.y = CGRectGetMaxY(forgetPwdBtn.frame) + 10;
    self.loginBtn = loginBtn;
    [self.loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
}
#pragma mark - setters and getters
- (UITextField *)userField {
    if (_userField == nil) {
        UITextField *tF = [[UITextField alloc] initWithFrame:CGRectMake(0, 70, self.view.width, 40)];
        tF.clearButtonMode = UITextFieldViewModeAlways;
        
        [tF setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)]];
        [tF setLeftViewMode:UITextFieldViewModeAlways];
        
        
        tF.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
        tF.rightViewMode = UITextFieldViewModeAlways;
        
        [tF setFont:[UIFont systemFontOfSize:15]];
        [self.view addSubview:tF];
        _userField = tF;
    }
    return _userField;
}

- (UITextField *)pwdField {
    if (_pwdField == nil) {
        UITextField *tF = [[UITextField alloc] initWithFrame:CGRectMake(0, 117, self.view.width, 40)];
        [tF setFont:[UIFont systemFontOfSize:15]];
        tF.clearButtonMode = UITextFieldViewModeAlways;
        tF.secureTextEntry = YES;
        
        tF.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
        tF.rightViewMode = UITextFieldViewModeAlways;
        
        [tF setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)]];
        [tF setLeftViewMode:UITextFieldViewModeAlways];
        
        [self.view addSubview:tF];
        _pwdField = tF;
    }
    return _pwdField;
}

@end
