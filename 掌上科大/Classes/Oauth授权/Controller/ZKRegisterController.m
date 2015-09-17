//
//  ZKRegisterController.m
//  掌上科大
//
//  Created by 樊樊帅 on 6/25/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKRegisterController.h"
#import "ZKLoginController.h"
#import <BmobSDK/Bmob.h>
#import "MBProgressHUD+MJ.h"
#import "ZKUserInfoController.h"

#define ZKRegFont [UIFont systemFontOfSize:16]

@interface ZKRegisterController ()
/**
 *  手机号码输入框
 */
@property (nonatomic, weak) UITextField *phoneNumber;
/**
 *  验证码输入框
 */
@property (nonatomic, weak) UITextField *SMSCode;
/**
 *  密码输入框
 */
@property (nonatomic, weak) UITextField *pwd;
/**
 *  用户名输入框
 */
@property (nonatomic, weak) UITextField *userName;
/**
 *  获取验证码按钮
 */
@property (nonatomic, weak) UIButton *SMSCodeBtn;
/**
 *  登录按钮
 */
@property (nonatomic, weak) UIButton *regBtn;
/**
 *  倒计时
 */
@property (nonatomic, strong) NSTimer *SMSCodeTimer;

@end

@implementation ZKRegisterController

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //跳转到完善信息界面
    [UIView animateWithDuration:0.3 animations:^{
        self.view.layer.transform = CATransform3DMakeRotation(M_PI_2, 0, 1, 0);
    } completion:^(BOOL finished) {
        ZKUserInfoController *nextVc = [[ZKUserInfoController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = nextVc;
    }];
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置翻转动画
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.layer.transform = CATransform3DMakeRotation(M_PI_2, 0, 1, 0);
    [UIView animateWithDuration:0.3 animations:^{
        self.view.layer.transform = CATransform3DIdentity;
    }];
    
    //设置导航条
    [self setupNav];
    
    //设置文本输入区
    [self setupLables];
    
    //设置注册按钮
    [self setupRegBtn];
    
    //为文本框绑定监听事件
    [self.phoneNumber addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.SMSCode addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.pwd addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.userName addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    
    [self textChange];
    [self.phoneNumber becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - event response
/**
 *  取消按钮点击
 */
- (void)cancle {
    NSLog(@"取消");
    [UIView animateWithDuration:0.3 animations:^{
        self.view.layer.transform = CATransform3DMakeRotation(M_PI_2, 0, 1, 0);
    } completion:^(BOOL finished) {
        ZKLoginController *nextVc = [[ZKLoginController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = nextVc;
    }];
}
/**
 *  文本框编辑事件
 */
- (void)textChange {
    self.SMSCodeBtn.enabled = self.phoneNumber.text.length == 11;
    self.regBtn.enabled = self.phoneNumber.text.length && self.SMSCode.text.length && self.pwd.text.length && self.userName.text.length;
}
/**
 *  获取验证码点击
 */
- (void)getSMSCode {
    NSLog(@"获取验证码");
    //请求验证码
    [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:_phoneNumber.text andTemplate:@"FSSMS" resultBlock:^(int number, NSError *error) {
        if (error) {
            NSLog(@"请求失败");
            [MBProgressHUD showError:@"请求失败"];
        } else {
            NSLog(@"请求成功--%d", number);
            [MBProgressHUD showSuccess:@"验证码已发送"];
            _SMSCodeBtn.enabled = NO;
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeCount) userInfo:nil repeats:YES];
            self.SMSCodeTimer = timer;
            [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        }
    }];
}
/**
 *  注册按钮点击
 */
- (void)registerClick {
    NSLog(@"注册:手机号:%@, 验证码:%@, 密码:%@, 用户名:%@", _phoneNumber.text, _SMSCode.text, _pwd.text, _userName.text);
    [BmobUser signOrLoginInbackgroundWithMobilePhoneNumber:_phoneNumber.text andSMSCode:_SMSCode.text block:^(BmobUser *user, NSError *error) {
        if (error) {//注册失败
            [MBProgressHUD showError:@"失败"];
        } else {
            //修改用户的用户名和密码信息
            BmobUser *user = [BmobUser getCurrentUser];
            [user setObject:_pwd.text forKey:@"password"];
            [user setObject:_userName.text forKey:@"username"];
            [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (error) {//修改信息失败
                    NSLog(@"失败");
                } else {//修改信息成功，提示用户注册成功
                    [MBProgressHUD showSuccess:@"注册成功"];
                }
            }];
            //跳转到完善信息界面
            [UIView animateWithDuration:0.3 animations:^{
                self.view.layer.transform = CATransform3DMakeRotation(M_PI_2, 0, 1, 0);
            } completion:^(BOOL finished) {
                ZKUserInfoController *nextVc = [[ZKUserInfoController alloc] init];
                [UIApplication sharedApplication].keyWindow.rootViewController = nextVc;
            }];
        }
    }];
}

/**
 *  请求验证码倒计时
 */
- (void)timeCount {
    static int second = 60;
    second--;
    [_SMSCodeBtn setTitle:[NSString stringWithFormat:@"重新获取(%d)", second] forState:UIControlStateNormal];
    if (second == 0) {
        [self.SMSCodeTimer invalidate];
        [_SMSCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        second = 60;
        [self textChange];
    }
}

- (void)phoneNumberDone {
    [self.phoneNumber resignFirstResponder];
}

- (void)SMSCodeDone {
    [self.SMSCode resignFirstResponder];
}

- (void)pwdDone {
    [self.pwd resignFirstResponder];
}

- (void)userNameDone {
    [self.userName resignFirstResponder];
}

#pragma mark - private method
/**
 *  设置导航条
 */
- (void)setupNav {
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, screenW, 64)];
    
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"注册"];
    
    item.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancle)];
    
    [bar pushNavigationItem:item animated:YES];
    
    [bar setTintColor:[UIColor blackColor]];
    
    [self.view addSubview:bar];
}

- (void)setupLables {
    //边距
    CGFloat screenMargin = 15;
    //Lable宽度
    CGFloat lableW = 50;
    //Lable高度
    CGFloat lableH = 40;
    //文本框高度
    CGFloat textFieldH = lableH;
    //Lable高度差
    CGFloat lableMargin = 5;
    //Lable与文本框间距
    CGFloat lable_to_tF = 5;
    
    //1.手机号区域
    //lable
    UILabel *phoneLable = [[UILabel alloc] init];
//    phoneLable.backgroundColor = randomColor;
    [phoneLable setFont:ZKRegFont];
    phoneLable.text = @"手机号";
    phoneLable.textAlignment = NSTextAlignmentCenter;
    phoneLable.width = lableW;
    phoneLable.height = lableH;
    phoneLable.x = screenMargin;
    phoneLable.y = 70;
    [self.view addSubview:phoneLable];
    //textField
//    self.phoneNumber.backgroundColor = randomColor;
    self.phoneNumber.x = CGRectGetMaxX(phoneLable.frame) + lable_to_tF;
    self.phoneNumber.y = phoneLable.y;
    self.phoneNumber.height = textFieldH;
    self.phoneNumber.width = screenW - self.phoneNumber.x - screenMargin;
    self.phoneNumber.placeholder = @"只支持中国大陆地区";
    //leftView
    UILabel *leftLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, textFieldH)];
    leftLable.text = @"+86 ";
    self.phoneNumber.leftView = leftLable;
    self.phoneNumber.leftViewMode = UITextFieldViewModeAlways;
    //分隔线
    UIView *cutOffLine1 = [[UIView alloc] initWithFrame:CGRectMake(self.phoneNumber.x, CGRectGetMaxY(self.phoneNumber.frame), screenW, 1)];
    cutOffLine1.backgroundColor = RGBColor(220, 220, 220);
    [self.view addSubview:cutOffLine1];
    
    //2.验证码区域
    //lable
    UILabel *SMSCodeLable = [[UILabel alloc] init];
//    SMSCodeLable.backgroundColor = randomColor;
    [SMSCodeLable setFont:ZKRegFont];
    SMSCodeLable.text = @"验证码";
    SMSCodeLable.textAlignment = NSTextAlignmentCenter;
    SMSCodeLable.width = lableW;
    SMSCodeLable.height = lableH;
    SMSCodeLable.x = screenMargin;
    SMSCodeLable.y = CGRectGetMaxY(phoneLable.frame) + lableMargin;
    [self.view addSubview:SMSCodeLable];
    //textField
//    self.SMSCode.backgroundColor = randomColor;
    self.SMSCode.x = CGRectGetMaxX(SMSCodeLable.frame) + lable_to_tF;
    self.SMSCode.y = SMSCodeLable.y;
    self.SMSCode.height = textFieldH;
    self.SMSCode.width = screenW - self.SMSCode.x - screenMargin;
    self.SMSCode.placeholder = @"请输入验证码";
    //rightBtn
    UIButton *rightBtn = [[UIButton alloc] init];
    rightBtn.width = 80;
    rightBtn.height = 30;
    rightBtn.x = 0;
    rightBtn.centerY = SMSCodeLable.height * 0.5;
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"roundRect"] forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"roundRectFill"] forState:UIControlStateHighlighted];
    [rightBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [rightBtn setTitleColor:RGBColor(11, 128, 0) forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(getSMSCode) forControlEvents:UIControlEventTouchUpInside];
    self.SMSCodeBtn = rightBtn;
    self.SMSCode.rightView = rightBtn;
    self.SMSCode.rightViewMode = UITextFieldViewModeAlways;
    //分隔线
    UIView *cutOffLine2 = [[UIView alloc] initWithFrame:CGRectMake(self.SMSCode.x, CGRectGetMaxY(self.SMSCode.frame), screenW, 1)];
    cutOffLine2.backgroundColor = RGBColor(220, 220, 220);
    [self.view addSubview:cutOffLine2];
    
    //3.密码区域
    //lable
    UILabel *pwdLable = [[UILabel alloc] init];
//    pwdLable.backgroundColor = randomColor;
    [pwdLable setFont:ZKRegFont];
    pwdLable.text = @"密 码";
    pwdLable.textAlignment = NSTextAlignmentCenter;
    pwdLable.width = lableW;
    pwdLable.height = lableH;
    pwdLable.x = screenMargin;
    pwdLable.y = CGRectGetMaxY(SMSCodeLable.frame) + lableMargin;
    [self.view addSubview:pwdLable];
    //textField
//    self.pwd.backgroundColor = randomColor;
    self.pwd.x = CGRectGetMaxX(pwdLable.frame) + lable_to_tF;
    self.pwd.y = pwdLable.y;
    self.pwd.height = textFieldH;
    self.pwd.width = screenW - self.pwd.x - screenMargin;
    self.pwd.placeholder = @"请输入您的密码";
    //分隔线
    UIView *cutOffLine3 = [[UIView alloc] initWithFrame:CGRectMake(self.pwd.x, CGRectGetMaxY(self.pwd.frame), screenW, 1)];
    cutOffLine3.backgroundColor = RGBColor(220, 220, 220);
    [self.view addSubview:cutOffLine3];
    
    //4.用户名区域
    //lable
    UILabel *userNameLable = [[UILabel alloc] init];
//    userNameLable.backgroundColor = randomColor;
    [userNameLable setFont:ZKRegFont];
    userNameLable.text = @"用户名";
    userNameLable.textAlignment = NSTextAlignmentCenter;
    userNameLable.width = lableW;
    userNameLable.height = lableH;
    userNameLable.x = screenMargin;
    userNameLable.y = CGRectGetMaxY(pwdLable.frame) + lableMargin;
    [self.view addSubview:userNameLable];
    //textField
//    self.userName.backgroundColor = randomColor;
    self.userName.x = CGRectGetMaxX(userNameLable.frame) + lable_to_tF;
    self.userName.y = userNameLable.y;
    self.userName.height = textFieldH;
    self.userName.width = screenW - self.userName.x - screenMargin;
    self.userName.placeholder = @"请输入您的用户名";
    //分隔线
    UIView *cutOffLine4 = [[UIView alloc] initWithFrame:CGRectMake(self.userName.x, CGRectGetMaxY(self.userName.frame), screenW, 1)];
    cutOffLine4.backgroundColor = RGBColor(220, 220, 220);
    [self.view addSubview:cutOffLine4];
}

- (void)setupRegBtn {
    //按钮边距
    CGFloat regBtnMargin = 20;
    //按钮距文本输入区距离
    CGFloat regBtnTopMargin = 30;
    
    self.regBtn.height = 40;
    self.regBtn.width = screenW - 2 * regBtnMargin;
    self.regBtn.centerX = self.view.centerX;
    self.regBtn.y = CGRectGetMaxY(self.userName.frame) + regBtnTopMargin;
//    self.regBtn.backgroundColor = randomColor;
    [self.regBtn setTitle:@"确认并注册" forState:UIControlStateNormal];
    [self.regBtn setBackgroundImage:[UIImage imageNamed:@"roundRectFill"] forState:UIControlStateNormal];
    [self.regBtn setBackgroundImage:[UIImage imageNamed:@"roundRect"] forState:UIControlStateHighlighted];
    [self.regBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.regBtn setTitleColor:RGBColor(11, 182, 0) forState:UIControlStateHighlighted];
    
    [self.regBtn addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - setters and getters
- (UITextField *)phoneNumber {
    if (_phoneNumber == nil) {
        UITextField *tF = [[UITextField alloc] init];
        tF.keyboardType = UIKeyboardTypePhonePad;
        [tF setFont:ZKRegFont];
        //设置键盘工具条
        UIToolbar *keyBoardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screenW, 40)];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(phoneNumberDone)];
        [keyBoardToolBar setItems:@[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], doneBtn] animated:YES];
        tF.inputAccessoryView = keyBoardToolBar;
        _phoneNumber = tF;
        [self.view addSubview:_phoneNumber];
    }
    return _phoneNumber;
}

- (UITextField *)SMSCode {
    if (_SMSCode == nil) {
        UITextField *tF = [[UITextField alloc] init];
        [tF setFont:ZKRegFont];
        //设置键盘工具条
        UIToolbar *keyBoardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screenW, 40)];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(SMSCodeDone)];
        [keyBoardToolBar setItems:@[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], doneBtn] animated:YES];
        tF.inputAccessoryView = keyBoardToolBar;
        _SMSCode = tF;
        [self.view addSubview:_SMSCode];
    }
    return _SMSCode;
}

- (UITextField *)pwd {
    if (_pwd == nil) {
        UITextField *tF = [[UITextField alloc] init];
        [tF setFont:ZKRegFont];
        //设置键盘工具条
        UIToolbar *keyBoardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screenW, 40)];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(pwdDone)];
        [keyBoardToolBar setItems:@[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], doneBtn] animated:YES];
        tF.inputAccessoryView = keyBoardToolBar;
        _pwd = tF;
        _pwd.secureTextEntry = YES;
        [self.view addSubview:_pwd];
    }
    return _pwd;
}

- (UITextField *)userName {
    if (_userName == nil) {
        UITextField *tF = [[UITextField alloc] init];
        [tF setFont:ZKRegFont];
        //设置键盘工具条
        UIToolbar *keyBoardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screenW, 40)];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(userNameDone)];
        [keyBoardToolBar setItems:@[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], doneBtn] animated:YES];
        tF.inputAccessoryView = keyBoardToolBar;
        _userName = tF;
        [self.view addSubview:_userName];
    }
    return _userName;
}

- (UIButton *)regBtn {
    if (_regBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _regBtn = btn;
        [self.view addSubview:_regBtn];
    }
    return _regBtn;
}

@end
