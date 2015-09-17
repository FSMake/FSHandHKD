//
//  ZKFeedbackController.m
//  掌上科大
//
//  Created by 樊樊帅 on 7/4/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKFeedbackController.h"
#import "MBProgressHUD+MJ.h"
#import <BmobSDK/Bmob.h>

#define ZKTextViewFont [UIFont systemFontOfSize:17]

@interface ZKFeedbackController ()
/**
 *  输入框
 */
@property (nonatomic, weak) UITextView *TextView;

@end

@implementation ZKFeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"意见反馈";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(commit)];
    
    self.TextView.x = 10;
    self.TextView.y = 74;
    
    self.TextView.height = 100;
    
    self.TextView.layer.borderWidth = 1.0;
    self.TextView.layer.borderColor = RGBColor(200, 200, 200).CGColor;
    self.TextView.layer.cornerRadius = 5.0;
    
    self.TextView.font = ZKTextViewFont;
    self.TextView.width = screenW - 2 * self.TextView.x;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.TextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)commit {
    NSLog(@"提交");
    
    if (self.TextView.text.length < 1) {
        [MBProgressHUD showError:@"请输入内容"];
        return;
    }
    
    BmobObject *feedback = [BmobObject objectWithClassName:@"feedback"];
    
    [feedback setObject:self.TextView.text forKey:@"content"];
    
    BmobUser *user = [BmobUser getCurrentUser];
    
    [feedback setObject:user forKey:@"commiter"];
    
    [feedback saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [MBProgressHUD showSuccess:@"提交成功"];
            [self.navigationController popViewControllerAnimated:YES];
            self.TextView.text = nil;
        } else {
            NSLog(@"error----%@", error);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (UITextView *)TextView {
    if (_TextView == nil) {
        UITextView *view = [[UITextView alloc] init];
        _TextView = view;
        [self.view addSubview:_TextView];
    }
    return _TextView;
}

@end
