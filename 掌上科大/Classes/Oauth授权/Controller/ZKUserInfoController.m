//
//  ZKUserInfoController.m
//  掌上科大
//
//  Created by 樊樊帅 on 6/25/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKUserInfoController.h"
#import "ZKLoginController.h"
#import <BmobSDK/Bmob.h>
#import "MBProgressHUD+MJ.h"
#import "ZKTabBarController.h"

#define ZKLableFont [UIFont systemFontOfSize:16]

@interface ZKUserInfoController () <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (nonatomic, weak) UITextField *nameField;
@property (nonatomic, weak) UITextField *collegeField;
@property (nonatomic, weak) UITextField *majorField;
@property (nonatomic, weak) UITextField *periodField;
@property (nonatomic, weak) UITextField *mailField;

@property (nonatomic, weak) UIButton *confimBtn;

@end

@implementation ZKUserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置翻转动画
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.layer.transform = CATransform3DMakeRotation(M_PI_2, 0, 1, 0);
    [UIView animateWithDuration:0.3 animations:^{
        self.view.layer.transform = CATransform3DIdentity;
    }];
    
    [self setupNav];
    
    [self setupTextFields];
    
    [self setupConfimBtn];
    
    //为文本框绑定监听事件
    [self.nameField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.collegeField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.majorField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.periodField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    
    //先判断是否可以输入
    [self textChange];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPickerViewDataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView.tag == 1) {//学院键盘
        return 1;
    }
    if (pickerView.tag == 2) {//专业键盘
        return 1;
    }
    if (pickerView.tag == 3) {//年级键盘
        return 1;
    }
    return 0;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView.tag == 1) {//学院键盘
        return 5;
    }
    if (pickerView.tag == 2) {//专业键盘
        return 3;
    }
    if (pickerView.tag == 3) {//年级键盘
        return 7;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView.tag == 1) {//学院键盘
        switch (row) {
            case 0:
                return @"信息工程学院";
            case 1:
                return @"软件学院";
            case 2:
                return @"机电学院";
            case 3:
                return @"土木工程学院";
            case 4:
                return @"人文学院";
            default:
                break;
        }
    }
    
    
    if (pickerView.tag == 2) {//专业键盘
        //根据学院来选择专业键盘
        if ([_collegeField.text isEqualToString:@"信息工程学院"]) {//信工学院专业
            switch (row) {
                case 0:
                    return @"电子信息工程";
                    break;
                case 1:
                    return @"自动化";
                    break;
                case 2:
                    return @"物联网";
                    break;
                default:
                    break;
            }
        }
        if ([_collegeField.text isEqualToString:@"软件学院"]) {//软件学院专业
            switch (row) {
                case 0:
                    return @"移动开发";
                    break;
                case 1:
                    return @"服务器端开发";
                    break;
                case 2:
                    return @"前端开发";
                    break;
                default:
                    break;
            }
        }
        if ([_collegeField.text isEqualToString:@"机电学院"]) {//机电学院专业
            switch (row) {
                case 0:
                    return @"机械制造";
                    break;
                case 1:
                    return @"电气工程";
                    break;
                case 2:
                    return @"车辆工程";
                    break;
                default:
                    break;
            }
        }
        if ([_collegeField.text isEqualToString:@"土木工程学院"]) {//土木工程学院专业
            switch (row) {
                case 0:
                    return @"土木工程";
                    break;
                case 1:
                    return @"建造";
                    break;
                case 2:
                    return @"土建";
                    break;
                default:
                    break;
            }
        }
        if ([_collegeField.text isEqualToString:@"人文学院"]) {//人文学院专业
            switch (row) {
                case 0:
                    return @"旅游";
                    break;
                case 1:
                    return @"社会与法";
                    break;
                case 2:
                    return @"国学";
                    break;
                default:
                    break;
            }
        }
    }
    
    
    if (pickerView.tag == 3) {//年级键盘
        switch (row) {
            case 0:
                return @"2009级";
            case 1:
                return @"2010级";
            case 2:
                return @"2011级";
            case 3:
                return @"2012级";
            case 4:
                return @"2013级";
            case 5:
                return @"2014级";
            case 6:
                return @"2015级";
            default:
                break;
        }
    }
    return nil;
}

#pragma mark - Delegate
#pragma mark UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView.tag == 1) {
        _collegeField.text = [self pickerView:pickerView titleForRow:row forComponent:component];
        [self textChange];
    }
    if (pickerView.tag == 2) {
        _majorField.text = [self pickerView:pickerView titleForRow:row forComponent:component];
        [self textChange];
    }
    if (pickerView.tag == 3) {
        _periodField.text = [self pickerView:pickerView titleForRow:row forComponent:component];
        [self textChange];
    }
}

#pragma mark - private method
/**
 *  设置导航条
 */
- (void)setupNav {
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, screenW, 64)];
    
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"完善您的信息"];
    
    item.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancle)];
    
    [bar pushNavigationItem:item animated:YES];
    
    [bar setTintColor:[UIColor blackColor]];
    
    [self.view addSubview:bar];
}
/**
 *  导航栏取消点击
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

- (void)setupTextFields {
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
    
    //1.姓名区域
    //lable
    UILabel *nameLable = [[UILabel alloc] init];
    //    phoneLable.backgroundColor = randomColor;
    [nameLable setFont:ZKLableFont];
    nameLable.text = @"姓 名";
    nameLable.textAlignment = NSTextAlignmentCenter;
    nameLable.width = lableW;
    nameLable.height = lableH;
    nameLable.x = screenMargin;
    nameLable.y = 70;
    [self.view addSubview:nameLable];
    //textField
    //    self.phoneNumber.backgroundColor = randomColor;
    self.nameField.x = CGRectGetMaxX(nameLable.frame) + lable_to_tF;
    self.nameField.y = nameLable.y;
    self.nameField.height = textFieldH;
    self.nameField.width = screenW - self.nameField.x - screenMargin;
    self.nameField.placeholder = @"请输入真实姓名";
    //分隔线
    UIView *cutOffLine1 = [[UIView alloc] initWithFrame:CGRectMake(self.nameField.x, CGRectGetMaxY(self.nameField.frame), screenW, 1)];
    cutOffLine1.backgroundColor = RGBColor(220, 220, 220);
    [self.view addSubview:cutOffLine1];
    
    //2.学院区域
    //lable
    UILabel *collegeLable = [[UILabel alloc] init];
    //    SMSCodeLable.backgroundColor = randomColor;
    [collegeLable setFont:ZKLableFont];
    collegeLable.text = @"学 院";
    collegeLable.textAlignment = NSTextAlignmentCenter;
    collegeLable.width = lableW;
    collegeLable.height = lableH;
    collegeLable.x = screenMargin;
    collegeLable.y = CGRectGetMaxY(nameLable.frame) + lableMargin;
    [self.view addSubview:collegeLable];
    //textField
    //    self.SMSCode.backgroundColor = randomColor;
    self.collegeField.x = CGRectGetMaxX(collegeLable.frame) + lable_to_tF;
    self.collegeField.y = collegeLable.y;
    self.collegeField.height = textFieldH;
    self.collegeField.width = screenW - self.collegeField.x - screenMargin;
    self.collegeField.placeholder = @"请选择学院";
    //分隔线
    UIView *cutOffLine2 = [[UIView alloc] initWithFrame:CGRectMake(self.collegeField.x, CGRectGetMaxY(self.collegeField.frame), screenW, 1)];
    cutOffLine2.backgroundColor = RGBColor(220, 220, 220);
    [self.view addSubview:cutOffLine2];
    
    //3.专业区域
    //lable
    UILabel *majorLable = [[UILabel alloc] init];
    //    pwdLable.backgroundColor = randomColor;
    [majorLable setFont:ZKLableFont];
    majorLable.text = @"专 业";
    majorLable.textAlignment = NSTextAlignmentCenter;
    majorLable.width = lableW;
    majorLable.height = lableH;
    majorLable.x = screenMargin;
    majorLable.y = CGRectGetMaxY(collegeLable.frame) + lableMargin;
    [self.view addSubview:majorLable];
    //textField
    //    self.pwd.backgroundColor = randomColor;
    self.majorField.x = CGRectGetMaxX(majorLable.frame) + lable_to_tF;
    self.majorField.y = majorLable.y;
    self.majorField.height = textFieldH;
    self.majorField.width = screenW - self.majorField.x - screenMargin;
    self.majorField.placeholder = @"请输入您的专业";
    //分隔线
    UIView *cutOffLine3 = [[UIView alloc] initWithFrame:CGRectMake(self.majorField.x, CGRectGetMaxY(self.majorField.frame), screenW, 1)];
    cutOffLine3.backgroundColor = RGBColor(220, 220, 220);
    [self.view addSubview:cutOffLine3];
    
    //4.入学年份区域
    //lable
    UILabel *periodLable = [[UILabel alloc] init];
    //    userNameLable.backgroundColor = randomColor;
    [periodLable setFont:ZKLableFont];
    periodLable.text = @"年 级";
    periodLable.textAlignment = NSTextAlignmentCenter;
    periodLable.width = lableW;
    periodLable.height = lableH;
    periodLable.x = screenMargin;
    periodLable.y = CGRectGetMaxY(majorLable.frame) + lableMargin;
    [self.view addSubview:periodLable];
    //textField
    //    self.userName.backgroundColor = randomColor;
    self.periodField.x = CGRectGetMaxX(periodLable.frame) + lable_to_tF;
    self.periodField.y = periodLable.y;
    self.periodField.height = textFieldH;
    self.periodField.width = screenW - self.periodField.x - screenMargin;
    self.periodField.placeholder = @"请输入您的入学年份";
    //分隔线
    UIView *cutOffLine4 = [[UIView alloc] initWithFrame:CGRectMake(self.periodField.x, CGRectGetMaxY(self.periodField.frame), screenW, 1)];
    cutOffLine4.backgroundColor = RGBColor(220, 220, 220);
    [self.view addSubview:cutOffLine4];
}

- (void)setupConfimBtn {
    //按钮边距
    CGFloat confimBtnMargin = 20;
    //按钮距文本输入区距离
    CGFloat confimTopMargin = 30;
    
    self.confimBtn.height = 40;
    self.confimBtn.width = screenW - 2 * confimBtnMargin;
    self.confimBtn.centerX = self.view.centerX;
    self.confimBtn.y = CGRectGetMaxY(self.periodField.frame) + confimTopMargin;
    //    self.regBtn.backgroundColor = randomColor;
    [self.confimBtn setTitle:@"Start Now" forState:UIControlStateNormal];
    [self.confimBtn setBackgroundImage:[UIImage imageNamed:@"roundRectFill"] forState:UIControlStateNormal];
    [self.confimBtn setBackgroundImage:[UIImage imageNamed:@"roundRect"] forState:UIControlStateHighlighted];
    [self.confimBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.confimBtn setTitleColor:RGBColor(11, 182, 0) forState:UIControlStateHighlighted];
    
    [self.confimBtn addTarget:self action:@selector(confimBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - event response
/**
 *  学院键盘完成按钮点击
 */
- (void)collegeDoneClick {
    NSLog(@"done");
    [_collegeField resignFirstResponder];
    
    UIPickerView *pickerView = (UIPickerView *)_collegeField.inputView;
    //被选中的行
    NSInteger row = [pickerView selectedRowInComponent:0];
    
    NSString *currentPick = [self pickerView:pickerView titleForRow:row forComponent:0];
    _collegeField.text = currentPick;
    
    [self textChange];
}
/**
 *  年级键盘完成按钮点击
 */
- (void)periodDoneClick {
    NSLog(@"done");
    [_periodField resignFirstResponder];
    
    UIPickerView *pickerView = (UIPickerView *)_periodField.inputView;
    //被选中的行
    NSInteger row = [pickerView selectedRowInComponent:0];
    
    NSString *currentPick = [self pickerView:pickerView titleForRow:row forComponent:0];
    _periodField.text = currentPick;
    
    [self textChange];
}
/**
 *  专业键盘完成按钮点击
 */
- (void)majorDoneClick {
    NSLog(@"done");
    [_majorField resignFirstResponder];
    
    UIPickerView *pickerView = (UIPickerView *)_majorField.inputView;
    //被选中的行
    NSInteger row = [pickerView selectedRowInComponent:0];
    
    NSString *currentPick = [self pickerView:pickerView titleForRow:row forComponent:0];
    _majorField.text = currentPick;
    
    [self textChange];
}
/**
 *  文本输入响应
 */
- (void)textChange {
    _majorField.enabled = _collegeField.text.length > 0;
    UIPickerView *pickerView = (UIPickerView *)_majorField.inputView;
    [pickerView reloadAllComponents];
    
    self.confimBtn.enabled = self.nameField.text.length && self.collegeField.text.length && self.majorField.text.length && self.periodField.text.length;
}
/**
 *  开始按钮点击
 */
- (void)confimBtnClick {
    NSLog(@"confimBtnClick");
    BmobUser *user = [BmobUser getCurrentUser];
    
    [user setObject:_nameField.text forKey:@"name"];
    [user setObject:_collegeField.text forKey:@"college"];
    [user setObject:_majorField.text forKey:@"major"];
    [user setObject:_periodField.text forKey:@"period"];
    [user setEmail:self.mailField.text];
    [user setObject:@0 forKey:@"score"];
    [user setObject:@0 forKey:@"level"];
    
    [MBProgressHUD showMessage:@"正在登录"];
    [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (error) {
            [MBProgressHUD showError:@"失败"];
        } else {
//            [MBProgressHUD showMessage:@"成功"];
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].windows lastObject]];
            [UIApplication sharedApplication].keyWindow.rootViewController = [[ZKTabBarController alloc] init];
        }
    }];
}

#pragma mark - setters and getters
- (UITextField *)nameField {
    if (_nameField == nil) {
        UITextField *tF = [[UITextField alloc] init];
        [tF setFont:ZKLableFont];
        _nameField = tF;
        [self.view addSubview:_nameField];
    }
    return _nameField;
}

- (UITextField *)collegeField {
    if (_collegeField == nil) {
        UITextField *tF = [[UITextField alloc] init];
        [tF setFont:ZKLableFont];
        
        //设置键盘
        UIPickerView *collegePicker = [[UIPickerView alloc] init];
        collegePicker.tag = 1;
        collegePicker.delegate = self;
        tF.inputView = collegePicker;
        
        //设置键盘工具条
        UIToolbar *keyBoardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screenW, 40)];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(collegeDoneClick)];
        [keyBoardToolBar setItems:@[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], doneBtn] animated:YES];
        tF.inputAccessoryView = keyBoardToolBar;
        
        _collegeField = tF;
        [self.view addSubview:_collegeField];
    }
    return _collegeField;
}

- (UITextField *)majorField {
    if (_majorField == nil) {
        UITextField *tF = [[UITextField alloc] init];
        [tF setFont:ZKLableFont];
        
        //设置键盘
        UIPickerView *collegePicker = [[UIPickerView alloc] init];
        collegePicker.tag = 2;
        collegePicker.delegate = self;
        tF.inputView = collegePicker;
        
        //设置键盘工具条
        UIToolbar *keyBoardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screenW, 40)];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(majorDoneClick)];
        [keyBoardToolBar setItems:@[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], doneBtn] animated:YES];
        tF.inputAccessoryView = keyBoardToolBar;
        
        _majorField = tF;
        [self.view addSubview:_majorField];
    }
    return _majorField;
}

- (UITextField *)periodField {
    if (_periodField == nil) {
        UITextField *tF = [[UITextField alloc] init];
        [tF setFont:ZKLableFont];
        
        //设置键盘
        UIPickerView *collegePicker = [[UIPickerView alloc] init];
        collegePicker.tag = 3;
        collegePicker.delegate = self;
        tF.inputView = collegePicker;
        
        //设置键盘工具条
        UIToolbar *keyBoardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screenW, 40)];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(periodDoneClick)];
        [keyBoardToolBar setItems:@[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], doneBtn] animated:YES];
        tF.inputAccessoryView = keyBoardToolBar;
        
        _periodField = tF;
        [self.view addSubview:_periodField];
    }
    return _periodField;
}

- (UITextField *)mailField {
    if (_mailField == nil) {
        UITextField *tF = [[UITextField alloc] init];
        [tF setFont:ZKLableFont];
        _mailField = tF;
        tF.returnKeyType = UIReturnKeyDone;
        
        [self.view addSubview:_mailField];
    }
    return _mailField;
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
