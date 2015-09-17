//
//  ZKForgetPwdController.m
//  掌上科大
//
//  Created by 樊樊帅 on 8/2/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKForgetPwdController.h"
#import "ZKUserPwdController.h"
#import <BmobSDK/Bmob.h>
#import "MBProgressHUD+MJ.h"

#define ZKRegFont [UIFont systemFontOfSize:16]

@interface ZKForgetPwdController ()

@property (nonatomic, weak) UITextField *phoneNumField;

@property (nonatomic, weak) UITextField *SMSCodeField;

@property (nonatomic, weak) UITextField *newPwdField;

@property (nonatomic, weak) UIButton *SMSCodeBtn;

@property (nonatomic, weak) UIButton *confimBtn;

/**
 *  倒计时
 */
@property (nonatomic, strong) NSTimer *SMSCodeTimer;

@end

@implementation ZKForgetPwdController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置翻转动画
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.layer.transform = CATransform3DMakeRotation(M_PI_2, 0, 1, 0);
    [UIView animateWithDuration:0.3 animations:^{
        self.view.layer.transform = CATransform3DIdentity;
    }];
    
    [self setupNav];

    [self setupLabels];
    
    [self setupConfimBtn];
    
    //为文本框绑定监听事件
    [self.phoneNumField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.SMSCodeField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.newPwdField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    
    [self textChange];
    [self.phoneNumField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate

#pragma mark - event response
/**
 *  文本框编辑事件
 */
- (void)textChange {
    self.SMSCodeBtn.enabled = self.phoneNumField.text.length == 11;
    self.confimBtn.enabled = self.phoneNumField.text.length && self.SMSCodeField.text.length && self.newPwdField.text.length;
}

/**
 *  获取验证码点击
 */
- (void)getSMSCode {
    NSLog(@"获取验证码");
    //请求验证码
    [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:_phoneNumField.text andTemplate:@"FSSMS" resultBlock:^(int number, NSError *error) {
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
 *  点击了取消
 */
- (void)cancle {
    [UIView animateWithDuration:0.3 animations:^{
        self.view.layer.transform = CATransform3DMakeRotation(M_PI_2, 0, 1, 0);
    } completion:^(BOOL finished) {
        ZKUserPwdController *nextVc = [[ZKUserPwdController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = nextVc;
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
/**
 *  重置密码点击
 */
- (void)resetPwd {
    [BmobUser resetPasswordInbackgroundWithSMSCode:self.SMSCodeField.text andNewPassword:self.newPwdField.text block:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            //成功
            [MBProgressHUD showSuccess:@"密码已重置"];
            [self cancle];
        } else {
            NSLog(@"失败-----%@", error);
            [MBProgressHUD showError:@"操作失败"];
        }
    }];
}

- (void)phoneNumFieldDone {
    [self.phoneNumField resignFirstResponder];
}

- (void)SMSCodeFieldDone {
    [self.SMSCodeField resignFirstResponder];
}

- (void)newPwdFieldDone {
    [self.newPwdField resignFirstResponder];
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
    UINavigationItem *titleItem = [[UINavigationItem alloc] initWithTitle:@"找回密码"];
    titleItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancle)];
    
    //设置导航条主题色为黑色
    [bar setTintColor:[UIColor blackColor]];
    
    //此方法用于将item应用于导航条
    [bar pushNavigationItem:titleItem animated:YES];
    
    [self.view addSubview:bar];
}
/**
 *  设置输入框区域
 */
- (void)setupLabels {
    //    [self setupTextFileds];
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
    self.phoneNumField.x = CGRectGetMaxX(phoneLable.frame) + lable_to_tF;
    self.phoneNumField.y = phoneLable.y;
    self.phoneNumField.height = textFieldH;
    self.phoneNumField.width = screenW - self.phoneNumField.x - screenMargin;
    self.phoneNumField.placeholder = @"只支持中国大陆地区";
    //leftView
    UILabel *leftLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, textFieldH)];
    leftLable.text = @"+86 ";
    self.phoneNumField.leftView = leftLable;
    self.phoneNumField.leftViewMode = UITextFieldViewModeAlways;
    //分隔线
    UIView *cutOffLine1 = [[UIView alloc] initWithFrame:CGRectMake(self.phoneNumField.x, CGRectGetMaxY(self.phoneNumField.frame), screenW, 1)];
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
    self.SMSCodeField.x = CGRectGetMaxX(SMSCodeLable.frame) + lable_to_tF;
    self.SMSCodeField.y = SMSCodeLable.y;
    self.SMSCodeField.height = textFieldH;
    self.SMSCodeField.keyboardType = UIKeyboardTypeNumberPad;
    self.SMSCodeField.width = screenW - self.SMSCodeField.x - screenMargin;
    self.SMSCodeField.placeholder = @"请输入验证码";
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
    self.SMSCodeField.rightView = rightBtn;
    self.SMSCodeField.rightViewMode = UITextFieldViewModeAlways;
    //分隔线
    UIView *cutOffLine2 = [[UIView alloc] initWithFrame:CGRectMake(self.SMSCodeField.x, CGRectGetMaxY(self.SMSCodeField.frame), screenW, 1)];
    cutOffLine2.backgroundColor = RGBColor(220, 220, 220);
    [self.view addSubview:cutOffLine2];
    
    //3.新密码区域
    //lable
    UILabel *pwdLable = [[UILabel alloc] init];
    //    pwdLable.backgroundColor = randomColor;
    [pwdLable setFont:ZKRegFont];
    pwdLable.text = @"新密码";
    pwdLable.textAlignment = NSTextAlignmentCenter;
    pwdLable.width = lableW;
    pwdLable.height = lableH;
    pwdLable.x = screenMargin;
    pwdLable.y = CGRectGetMaxY(SMSCodeLable.frame) + lableMargin;
    [self.view addSubview:pwdLable];
    //textField
    //    self.pwd.backgroundColor = randomColor;
    self.newPwdField.x = CGRectGetMaxX(pwdLable.frame) + lable_to_tF;
    self.newPwdField.y = pwdLable.y;
    self.newPwdField.height = textFieldH;
    self.newPwdField.width = screenW - self.newPwdField.x - screenMargin;
    self.newPwdField.placeholder = @"请输入新密码";
    //分隔线
    UIView *cutOffLine3 = [[UIView alloc] initWithFrame:CGRectMake(self.newPwdField.x, CGRectGetMaxY(self.newPwdField.frame), screenW, 1)];
    cutOffLine3.backgroundColor = RGBColor(220, 220, 220);
    [self.view addSubview:cutOffLine3];
    
}
/**
 *  设置文本输入区
 */
- (void)setupTextFileds {
    //用户名区域
    [self.phoneNumField setPlaceholder:@"请输入手机号"];
    [self.phoneNumField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    
    //分隔线
    UIView *userCutOffLine = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.phoneNumField.frame), self.view.width, 1)];
    userCutOffLine.backgroundColor = RGBColor(220, 220, 220);
    [self.view addSubview:userCutOffLine];
    
    //密码区域
    [self.SMSCodeField setPlaceholder:@"请输入验证码"];
    [self.SMSCodeField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    
    //分隔线
    UIView *userCutOffLine2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.SMSCodeField.frame), self.view.width, 1)];
    userCutOffLine2.backgroundColor = RGBColor(220, 220, 220);
    [self.view addSubview:userCutOffLine2];
}

- (void)setupConfimBtn {
    //按钮边距
    CGFloat regBtnMargin = 20;
    //按钮距文本输入区距离
    CGFloat regBtnTopMargin = 30;
    
    self.confimBtn.height = 40;
    self.confimBtn.width = screenW - 2 * regBtnMargin;
    self.confimBtn.centerX = self.view.centerX;
    self.confimBtn.y = CGRectGetMaxY(self.newPwdField.frame) + regBtnTopMargin;
    //    self.regBtn.backgroundColor = randomColor;
    [self.confimBtn setTitle:@"重置密码" forState:UIControlStateNormal];
    [self.confimBtn setBackgroundImage:[UIImage imageNamed:@"roundRectFill"] forState:UIControlStateNormal];
    [self.confimBtn setBackgroundImage:[UIImage imageNamed:@"roundRect"] forState:UIControlStateHighlighted];
    [self.confimBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.confimBtn setTitleColor:RGBColor(11, 182, 0) forState:UIControlStateHighlighted];
    
    [self.confimBtn addTarget:self action:@selector(resetPwd) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - getters and setters
- (UITextField *)phoneNumField {
    if (_phoneNumField == nil) {
        UITextField *tF = [[UITextField alloc] initWithFrame:CGRectMake(0, 70, self.view.width, 40)];
        tF.clearButtonMode = UITextFieldViewModeAlways;
        [tF setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)]];
        [tF setLeftViewMode:UITextFieldViewModeAlways];
        tF.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
        tF.rightViewMode = UITextFieldViewModeAlways;
        
        //设置键盘工具条
        UIToolbar *keyBoardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screenW, 40)];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(phoneNumFieldDone)];
        [keyBoardToolBar setItems:@[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], doneBtn] animated:YES];
        tF.inputAccessoryView = keyBoardToolBar;
        tF.keyboardType = UIKeyboardTypePhonePad;
        [tF setFont:[UIFont systemFontOfSize:15]];
        [self.view addSubview:tF];
        
        _phoneNumField = tF;
    }
    return _phoneNumField;
}

- (UITextField *)SMSCodeField {
    if (_SMSCodeField == nil) {
        UITextField *tF = [[UITextField alloc] initWithFrame:CGRectMake(0, 117, self.view.width, 40)];
        [tF setFont:[UIFont systemFontOfSize:15]];
        tF.clearButtonMode = UITextFieldViewModeAlways;
        tF.secureTextEntry = YES;
        
        tF.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
        tF.rightViewMode = UITextFieldViewModeAlways;
        
        [tF setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)]];
        [tF setLeftViewMode:UITextFieldViewModeAlways];
        //设置键盘工具条
        UIToolbar *keyBoardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screenW, 40)];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(SMSCodeFieldDone)];
        [keyBoardToolBar setItems:@[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], doneBtn] animated:YES];
        tF.inputAccessoryView = keyBoardToolBar;
        [self.view addSubview:tF];
        _SMSCodeField = tF;
    }
    return _SMSCodeField;
}

- (UITextField *)newPwdField {
    if (_newPwdField == nil) {
        UITextField *tF = [[UITextField alloc] init];
        [tF setFont:ZKRegFont];
        //设置键盘工具条
        UIToolbar *keyBoardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screenW, 40)];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(newPwdFieldDone)];
        [keyBoardToolBar setItems:@[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], doneBtn] animated:YES];
        tF.inputAccessoryView = keyBoardToolBar;
        _newPwdField = tF;
        _newPwdField.secureTextEntry = YES;
        [self.view addSubview:_newPwdField];
    }
    return _newPwdField;
}

- (UIButton *)confimBtn {
    if (_confimBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _confimBtn = btn;
        [self.view addSubview:_confimBtn];
    }
    return _confimBtn;
}

@end
