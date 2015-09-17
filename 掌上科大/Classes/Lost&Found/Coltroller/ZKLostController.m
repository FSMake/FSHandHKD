//
//  ZKLostController.m
//  掌上科大
//
//  Created by 樊樊帅 on 7/1/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKLostController.h"
#import "MBProgressHUD+MJ.h"
#import <BmobSDK/Bmob.h>

#define ZKLabelFont [UIFont systemFontOfSize:17]

@interface ZKLostController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
/**
 *  物品照片
 */
@property (nonatomic, weak) UIImageView *stuffImgView;
/**
 *  物品名称
 */
@property (nonatomic, weak) UITextField *name;
/**
 *  物品信息
 */
@property (nonatomic, weak) UITextView *information;
/**
 *  联系方式
 */
@property (nonatomic, weak) UITextField *connect;
/**
 *  招领/寻物 选择
 */
@property (nonatomic, weak) UISegmentedControl *typePicker;

@end

@implementation ZKLostController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置导航栏
    [self setupNav];
    
    
    //设置控制器内容
    [self setupContent];
    
    //添加监听器
    [self addKeyboardNotificationObserver];
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
 *  选择照片之后将照片显示到视图上
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *img = info[@"UIImagePickerControllerOriginalImage"];
        self.stuffImgView.image = img;
    }];
}

#pragma mark - event response
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.name resignFirstResponder];
    [self.information resignFirstResponder];
    [self.connect resignFirstResponder];
    
    [UIView animateWithDuration:0.1 animations:^{
        self.view.y = 0;
    }];
}

- (void)commit {
    NSLog(@"提交");
    
    if ([self.stuffImgView.image isEqual:[UIImage imageNamed:@"imgUploadPlaceHolder"]]) {
        [MBProgressHUD showError:@"请上传一张图片"];
        return;
    }
    
    if (self.name.text.length < 1) {
        [MBProgressHUD showError:@"请输入物品名称"];
        return;
    }
    
    if (self.information.text.length < 1) {
        [MBProgressHUD showError:@"请输入物品信息"];
        return;
    }
    
    if (self.connect.text.length < 1) {
        [MBProgressHUD showError:@"请输入联系方式"];
        return;
    }
    
    if (self.typePicker.selectedSegmentIndex == -1) {
        [MBProgressHUD showError:@"请选择您的信息类型"];
        return;
    }
    
    //收起键盘
    [self.name resignFirstResponder];
    [self.information resignFirstResponder];
    [self.connect resignFirstResponder];
    [UIView animateWithDuration:0.1 animations:^{
        self.view.y = 0;
    }];
    
    //构造物品信息对象
    BmobObject *stuffInfo = [BmobObject objectWithClassName:@"stuffInfo"];
    
    [stuffInfo setObject:self.name.text forKey:@"name"];
    
    [stuffInfo setObject:self.information.text forKey:@"information"];
    
    [stuffInfo setObject:self.connect.text forKey:@"contactWay"];
    
    [stuffInfo setObject:[BmobUser getCurrentUser] forKey:@"announcer"];
    
    if (self.typePicker.selectedSegmentIndex == 0) {//表示是招领
        [stuffInfo setObject:@YES forKey:@"found"];
    } else if (self.typePicker.selectedSegmentIndex == 1) {//表示是寻物
        //表示是找到物品
        [stuffInfo setObject:@NO forKey:@"found"];
    }
    
    [MBProgressHUD showMessage:@"正在提交招领信息"];
    
    UIImage *img = self.stuffImgView.image;
    //压缩图片
    UIImage *smallImg = [UIImage newImageWithimage:img newSize:CGSizeMake(200, (img.size.height/(img.size.width/200)))];
    
    NSData *imgData = UIImagePNGRepresentation(smallImg);
    BmobFile *imgFile = [[BmobFile alloc] initWithFileName:[NSString stringWithFormat:@"%@_img.png", self.name.text] withFileData:imgData];
    //先保存图片至服务器保存文件
    [imgFile saveInBackground:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {//图片保存成功，提交招领信息
            NSLog(@"保存成功");
            [stuffInfo setObject:imgFile forKey:@"stuffImg"];
            [stuffInfo saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {//招领信息提交成功
                    NSLog(@"成功");
                    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].windows lastObject]];
                    [MBProgressHUD showSuccess:@"提交成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    NSLog(@"失败---%@", error);
                    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].windows lastObject]];
                    [MBProgressHUD showError:@"提交失败"];
                }
            }];
        } else {
            NSLog(@"图片保存失败---%@", error);
        }
    }];
}

//键盘frame发生改变
- (void)keyboardFrameDidChange:(NSNotification *)notification {
    if ([notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y < [[UIScreen mainScreen] bounds].size.width) {
        //键盘弹出
        NSLog(@"键盘弹出");
        [self adjustTfFrameWithNotification:notification];
    }
}
//调整视图位置
- (void)adjustTfFrameWithNotification:(NSNotification *)notification {
    CGFloat kbEndY = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    NSLog(@"%f", kbEndY);
    
    CGFloat offset = CGRectGetMaxY(self.typePicker.frame) - self.typePicker.height - kbEndY;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.view.y = -offset;
    }];
}
/**
 *  上传图片点击
 */
- (void)uploadImg {
    NSLog(@"上传图片");
    
    //弹出询问框
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择照片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册", @"拍照", nil];
    [actionSheet showInView:self.view];
    
}

#pragma mark - private method
//添加键盘通知监听
- (void)addKeyboardNotificationObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameDidChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
}

- (void)setupContent {
    //边距
    CGFloat screenMargin = 15;
    //Lable宽度
    CGFloat lableW = 70;
    //Lable高度
    CGFloat lableH = 40;
    //文本框高度
    CGFloat textFieldH = lableH;
    //Lable高度差
    CGFloat lableMargin = 5;
    //Lable与文本框间距
    CGFloat lable_to_tF = 5;
    
    //提醒用户上传图片的label
    UILabel *imgUploadLabel = [[UILabel alloc] init];
    //    imgUploadLabel.backgroundColor = [UIColor redColor];
    imgUploadLabel.text = @"点击上传图片:";
    imgUploadLabel.font = ZKLabelFont;
    [imgUploadLabel sizeToFit];
    imgUploadLabel.x = screenMargin;
    imgUploadLabel.y = 80;
    [self.view addSubview:imgUploadLabel];
    
    //图片框
    self.stuffImgView.width = screenW * 0.4;
    self.stuffImgView.height = self.stuffImgView.width;
    self.stuffImgView.centerX = self.view.centerX;
    self.stuffImgView.centerY = self.view.height * 0.3;
    [self.stuffImgView setImage:[UIImage imageNamed:@"imgUploadPlaceHolder"]];
    self.stuffImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadImg)];
    [self.stuffImgView addGestureRecognizer:tap];
    
    //2.物品名称区域
    //lable
    UILabel *nameLabel = [[UILabel alloc] init];
    //    SMSCodeLable.backgroundColor = randomColor;
    [nameLabel setFont:ZKLabelFont];
    nameLabel.text = @"物品名称";
    //    nameLabel.backgroundColor = [UIColor redColor];
    //    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.width = lableW;
    nameLabel.height = lableH;
    nameLabel.x = screenMargin;
    nameLabel.y = CGRectGetMaxY(self.stuffImgView.frame) + lableMargin;
    [self.view addSubview:nameLabel];
    //textField
    //    self.SMSCode.backgroundColor = randomColor;
    self.name.x = CGRectGetMaxX(nameLabel.frame) + lable_to_tF;
    self.name.y = nameLabel.y;
    self.name.height = textFieldH;
    self.name.width = screenW - self.name.x - screenMargin;
    self.name.placeholder = @"请输入物品名称";
    //分隔线
    UIView *cutOffLine2 = [[UIView alloc] initWithFrame:CGRectMake(self.name.x, CGRectGetMaxY(self.name.frame), screenW, 1)];
    cutOffLine2.backgroundColor = RGBColor(220, 220, 220);
    [self.view addSubview:cutOffLine2];
    
    //3.物品信息区域
    //lable
    UILabel *informationLabel = [[UILabel alloc] init];
    //    pwdLable.backgroundColor = randomColor;
    [informationLabel setFont:ZKLabelFont];
    informationLabel.text = @"物品信息";
    informationLabel.width = lableW;
    informationLabel.height = lableH;
    informationLabel.x = screenMargin;
    informationLabel.y = CGRectGetMaxY(nameLabel.frame) + lableMargin;
    [self.view addSubview:informationLabel];
    //textField
    //    self.pwd.backgroundColor = randomColor;
    self.information.x = CGRectGetMaxX(informationLabel.frame) + lable_to_tF;
    self.information.y = informationLabel.y + 5;
    self.information.height = 100;
    self.information.layer.borderColor = RGBColor(220, 220, 220).CGColor;
    
    self.information.layer.borderWidth = 1.0;
    
    self.information.layer.cornerRadius = 5.0;
    self.information.font = ZKLabelFont;
    self.information.width = screenW - self.information.x - screenMargin;
    
    //4.联系方式区域
    UILabel *connectLabel = [[UILabel alloc] init];
    [connectLabel setFont:ZKLabelFont];
    connectLabel.text = @"联系电话";
    connectLabel.width = lableW;
    connectLabel.height = lableH;
    connectLabel.x = screenMargin;
    connectLabel.y = CGRectGetMaxY(self.information.frame) + lableMargin;
    [self.view addSubview:connectLabel];
    //textField
    //    self.SMSCode.backgroundColor = randomColor;
    self.connect.x = CGRectGetMaxX(connectLabel.frame) + lable_to_tF;
    self.connect.y = connectLabel.y;
    self.connect.height = textFieldH;
    self.connect.width = screenW - self.connect.x - screenMargin;
    self.connect.placeholder = @"请输入您的手机号码";
    //分隔线
    UIView *cutOffLine3 = [[UIView alloc] initWithFrame:CGRectMake(self.connect.x, CGRectGetMaxY(self.connect.frame), screenW, 1)];
    cutOffLine3.backgroundColor = RGBColor(220, 220, 220);
    [self.view addSubview:cutOffLine3];
    
    //类型选择区域
    UILabel *typePickerLabel = [[UILabel alloc] init];
    [typePickerLabel setFont:ZKLabelFont];
    typePickerLabel.text = @"类型选择";
    typePickerLabel.width = lableW;
    typePickerLabel.height = lableH;
    typePickerLabel.x = screenMargin;
    typePickerLabel.y = CGRectGetMaxY(self.connect.frame) + lableMargin;
    [self.view addSubview:typePickerLabel];
    
    self.typePicker.width = 200;
    self.typePicker.height = 44;
    self.typePicker.centerX = self.view.centerX;
    self.typePicker.y = CGRectGetMaxY(typePickerLabel.frame) + lableMargin;
}

- (void)setupNav {
    self.navigationItem.title = @"失物信息";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(commit)];
}

#pragma mark - getters and setters
- (UIImageView *)stuffImgView {
    if (_stuffImgView == nil) {
        UIImageView *view = [[UIImageView alloc] init];
        _stuffImgView = view;
        [self.view addSubview:_stuffImgView];
    }
    return _stuffImgView;
}

- (UITextField *)name {
    if (_name == nil) {
        UITextField *tF = [[UITextField alloc] init];
        _name = tF;
        [self.view addSubview:_name];
    }
    return _name;
}

- (UITextView *)information {
    if (_information == nil) {
        UITextView *tF = [[UITextView alloc] init];
        _information = tF;
        [self.view addSubview:_information];
    }
    return _information;
}

- (UITextField *)connect {
    if (_connect == nil) {
        UITextField *tF = [[UITextField alloc] init];
        _connect = tF;
        [self.view addSubview:_connect];
    }
    return _connect;
}

- (UISegmentedControl *)typePicker {
    if (_typePicker == nil) {
        UISegmentedControl *segControl = [[UISegmentedControl alloc] initWithItems:@[@"招领", @"寻物"]];
        _typePicker = segControl;
        [self.view addSubview:_typePicker];
    }
    return _typePicker;
}

@end
