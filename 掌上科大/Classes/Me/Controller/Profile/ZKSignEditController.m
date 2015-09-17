//
//  ZKSignEditController.m
//  掌上科大
//
//  Created by 樊樊帅 on 6/27/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKSignEditController.h"
#import <BmobSDK/Bmob.h>
#import "MBProgressHUD+MJ.h"

@interface ZKSignEditController()

@property (nonatomic, weak) UITextField *signField;

@end

@implementation ZKSignEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"编辑个性签名";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(doneClick)];
    
    UITextField *signField = [[UITextField alloc] init];
//    signField.backgroundColor = [UIColor redColor];
    
    CGFloat margin = 10;
    signField.width = screenW - 2 * margin;
    signField.height = screenH * 0.15;
    signField.x = margin;
    signField.y = 70;
    signField.borderStyle = UITextBorderStyleRoundedRect;
    signField.placeholder = @"最多15个字";
    //设置靠上对齐
    [signField setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    
    BmobUser *user = [BmobUser getCurrentUser];
    
    signField.text = [user objectForKey:@"sign"];
    
    [self.view addSubview:signField];
    
    [signField becomeFirstResponder];
    
    self.signField = signField;
}

- (void)doneClick {
    BmobUser *user = [BmobUser getCurrentUser];
    [user setObject:self.signField.text forKey:@"sign"];
    [MBProgressHUD showMessage:@"正在修改"];
    [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"成功");
            //发出个人信息更新通知
            NSNotification *noti = [NSNotification notificationWithName:@"userDataUpdate" object:self];
            [[NSNotificationCenter defaultCenter] postNotification:noti];
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].windows lastObject]];
            [MBProgressHUD showSuccess:@"修改成功"];
        } else {
            NSLog(@"失败---%@", error);
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].windows lastObject]];
            [MBProgressHUD showError:@"修改失败"];
        }
    }];
    [self.navigationController popViewControllerAnimated:YES];
    

}

@end
