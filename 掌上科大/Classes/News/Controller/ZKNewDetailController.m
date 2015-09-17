//
//  ZKNewDetailController.m
//  掌上科大
//
//  Created by 樊樊帅 on 6/28/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKNewDetailController.h"
#import "ZKTextContentView.h"
#import "ZKBottomBar.h"
#import <BmobSDK/Bmob.h>
#import "MBProgressHUD+MJ.h"
#import "ZKCommentModel.h"
#import "ZKCommentView.h"

#define ZKTextFont [UIFont systemFontOfSize:18]

@interface ZKNewDetailController() <ZKBottomBarDelegate, UIScrollViewDelegate, UITextFieldDelegate>
/**
 *  全部评论
 */
@property (nonatomic, strong) NSMutableArray *comments;

//----------------------内容view---------------------------//
/**
 *  主view,用来显示内容
 */
@property (nonatomic, weak) UIScrollView *mainScrollView;
/**
 *  标题view
 */
@property (nonatomic, weak) UILabel *titlelabel;
/**
 *  信息view
 */
@property (nonatomic, weak) UILabel *infolabel;
/**
 *  评论数按钮
 */
@property (nonatomic, weak) UIButton *commentCountBtn;
/**
 *  正文部分
 */
@property (nonatomic, weak) ZKTextContentView *textView;
/**
 *  底部bar
 */
@property (nonatomic, strong) ZKBottomBar *bottomBar;
/**
 *  评论遮罩
 */
@property (nonatomic, weak) UIView *commentCover;
/**
 *  评论条
 */
@property (nonatomic, weak) UIView *commentBar;
/**
 *  评论框
 */
@property (nonatomic, weak) UITextField *commentField;

@end

@implementation ZKNewDetailController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentTap)];
    
    [self.mainScrollView addGestureRecognizer:tap];
    [self addKeyboardNotificationObserver];
    
    //加载评论
    BmobQuery *query = [BmobQuery queryWithClassName:@"comment"];
    [query includeKey:@"commenter"];
    [query whereKey:@"article" equalTo:self.articleModel.articleObj];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *object in array) {
            ZKCommentModel *comment = [ZKCommentModel commentWithCommentObject:object];
            [self.comments addObject:comment];
            
            ZKCommentView *commentView = [[ZKCommentView alloc] init];
            commentView.commentModel = comment;
            UIView *lastView = [self.mainScrollView.subviews lastObject];
            if ([lastView isKindOfClass:[ZKCommentView class]]) {
                commentView.y = CGRectGetMaxY(lastView.frame);
                [self.mainScrollView addSubview:commentView];
            } else {
                commentView.y = CGRectGetMaxY(self.textView.frame);
                [self.mainScrollView addSubview:commentView];
            }
        }
        
        UIView *lastView = [self.mainScrollView.subviews lastObject];
        if ([lastView isKindOfClass:[ZKCommentView class]]) {
            self.mainScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(lastView.frame) + 50);
        }
    }];
}

- (void)test {
    NSLog(@"%s", __func__);
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - delegate
#pragma mark ZKBottomBarDelegate
/**
 *  返回点击
 */
- (void)bottomBarBack:(ZKBottomBar *)bottomBar {
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  收藏点击
 */
- (void)bottomBarCollect:(ZKBottomBar *)bottomBar collectionBtn:(UIButton *)collectionBtn {
    BmobUser *user = [BmobUser getCurrentUser];
    
    NSMutableArray *collections = [user objectForKey:@"collections"];
    if (collections == nil) {
        collections = [NSMutableArray array];
    }
    
    for (NSString *objId in collections) {
        if ([objId isEqualToString:_articleModel.objectId]) {//如果收藏过
            [MBProgressHUD showError:@"您已收藏过此文章"];
            return;
        }
    }
    //没有收藏过该文章
    [collections addObject:_articleModel.objectId];
    
    [user setObject:collections forKey:@"collections"];
    
    [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"收藏成功");
            [MBProgressHUD showSuccess:@"收藏成功"];
            collectionBtn.selected = YES;
        } else {
            NSLog(@"失败--%@", error);
        }
    }];
}
/**
 *  评论点击
 */
- (void)bottomBarComment:(ZKBottomBar *)bottomBar {
    //遮罩
    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW, screenH)];
    coverView.backgroundColor = RGBAColor(0, 0, 0, 0.5);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverTap)];
    [coverView addGestureRecognizer:tap];
    self.commentCover = coverView;
    
    //评论框
    UIView *commentBar = [[UIView alloc] initWithFrame:CGRectMake(0, screenH, screenW, 44)];
    commentBar.backgroundColor = [UIColor whiteColor];
    self.commentBar = commentBar;
    UITextField *commentField = [[UITextField alloc] initWithFrame:CGRectMake(10, 7, screenW - 20, 30)];
    commentField.borderStyle = UITextBorderStyleRoundedRect;
    commentField.delegate = self;
    commentField.returnKeyType = UIReturnKeyDone;
    self.commentField = commentField;
    [commentBar addSubview:commentField];
    
    [coverView addSubview:commentBar];
    [[UIApplication sharedApplication].keyWindow addSubview:coverView];
    
    [self.commentField becomeFirstResponder];
}
/**
 *  赞点击
 */
- (void)bottomBarLike:(ZKBottomBar *)bottomBar likeBtn:(UIButton *)likeBtn {
    //判断是否赞过
    BmobUser *user = [BmobUser getCurrentUser];
    NSMutableArray *likes = [user objectForKey:@"likes"];
    if (likes == nil) {
        likes = [NSMutableArray array];
    }
    for (NSString *objId in likes) {
        if ([objId isEqualToString:_articleModel.objectId]) {//如果收藏过
            [MBProgressHUD showError:@"您已赞过此文章"];
            return;
        }
    }
    
    //没有赞过该文章
    [likes addObject:_articleModel.objectId];
    
    [user setObject:likes forKey:@"likes"];
    //向用户的赞列表中添加数据
    [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"赞成功");
            [MBProgressHUD showSuccess:@"赞 +1"];
            likeBtn.selected = YES;
            
            //更新文章的数据
            BmobObject *bmobObject = [BmobObject objectWithoutDatatWithClassName:@"article" objectId:_articleModel.objectId];
            //赞数+1
            NSNumber *likeCount = [NSNumber numberWithInt:_articleModel.likeCount + 1];
            [bmobObject setObject:likeCount forKey:@"likeCount"];
            [bmobObject updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    //赞成功
                    //更新本地数据
                    _articleModel.likeCount = [likeCount intValue];
                    //更新当前视图中的赞数
                    self.infolabel.text = [NSString stringWithFormat:@"%@ · %@ · 顶%d·踩%d", _articleModel.author, _articleModel.date, _articleModel.likeCount, _articleModel.unlikeCount];
                } else {
                    NSLog(@"失败---%@", error);
                }
            }];
            
        } else {
            NSLog(@"失败--%@", error);
        }
    }];
}
/**
 *  踩点击
 */
- (void)bottomBarUnlike:(ZKBottomBar *)bottomBar unlikeBtn:(UIButton *)unlikeBtn {
    //判断是否踩过
    BmobUser *user = [BmobUser getCurrentUser];
    NSMutableArray *unlikes = [user objectForKey:@"unlikes"];
    if (unlikes == nil) {
        unlikes = [NSMutableArray array];
    }
    
    for (NSString *objId in unlikes) {
        if ([objId isEqualToString:_articleModel.objectId]) {//如果收藏过
            [MBProgressHUD showError:@"您已踩过此文章"];
            return;
        }
    }
    
    //没有踩过该文章
    [unlikes addObject:_articleModel.objectId];
    
    [user setObject:unlikes forKey:@"unlikes"];
    
    [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"踩成功");
            [MBProgressHUD showSuccess:@"踩 +1"];
            unlikeBtn.selected = YES;
            
            //更新文章的数据
            BmobObject *bmobObject = [BmobObject objectWithoutDatatWithClassName:@"article" objectId:_articleModel.objectId];
            //计算新的踩数
            NSNumber *unlikeCount = [NSNumber numberWithInt:_articleModel.unlikeCount + 1];
            [bmobObject setObject:unlikeCount forKey:@"unlikeCount"];
            
            [bmobObject updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    //踩成功
                    //更新本地数据
                    _articleModel.unlikeCount = [unlikeCount intValue];
                    //更新当前视图中的踩数
                    self.infolabel.text = [NSString stringWithFormat:@"%@ · %@ · 顶%d·踩%d", _articleModel.author, _articleModel.date, _articleModel.likeCount, _articleModel.unlikeCount];
                } else {
                    NSLog(@"失败---%@", error);
                }
            }];
            
        } else {
            NSLog(@"失败--%@", error);
        }
    }];
}

#pragma mark UIScrollViewDelegate
/**
 *  判断scrollview滚动方向
 */
int _lastPosition;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int currentPostion = scrollView.contentOffset.y;
    if (currentPostion - _lastPosition > 25) {
        _lastPosition = currentPostion;
        NSLog(@"ScrollUp now");
        [UIView animateWithDuration:0.2 animations:^{
            self.bottomBar.alpha = 0;
        }];
    }
    else if (_lastPosition - currentPostion > 25)
    {
        _lastPosition = currentPostion;
        NSLog(@"ScrollDown now");
        [UIView animateWithDuration:0.2 animations:^{
            self.bottomBar.alpha = 1;
        }];
    }
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.commentField.text.length < 1) return NO;
    
    NSLog(@"%@", self.commentField.text);
    
    BmobUser *user = [BmobUser getCurrentUser];
    
    BmobObject *comment = [BmobObject objectWithClassName:@"comment"];
    [comment setObject:self.commentField.text forKey:@"content"];
    [comment setObject:user forKey:@"commenter"];
    [comment setObject:self.articleModel.articleObj forKey:@"article"];
    
    [comment saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [MBProgressHUD showSuccess:@"评论发布成功"];
            [self.commentCover removeFromSuperview];
        } else {
            NSLog(@"error---%@", error);
        }
    }];
    
    return YES;
}

#pragma mark - event response
/**
 *  内容界面点击，显示底部工具条
 */
- (void)contentTap {
    NSLog(@"tap");
    [UIView animateWithDuration:0.2 animations:^{
        self.bottomBar.alpha = 1;
    }];
}
/**
 *  点击了评论遮罩
 */
- (void)coverTap {
    [self.commentCover removeFromSuperview];
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
    self.commentBar.y = kbEndY - self.commentBar.height;
}
#pragma mark - private method
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
/**
 *  添加键盘监听
 */
- (void)addKeyboardNotificationObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameDidChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
}
/**
 *  检测文章是否被收藏过，赞过，踩过
 */
- (void)setArticleInfo {
    BmobUser *user = [BmobUser getCurrentUser];
    
    NSMutableArray *collections = [user objectForKey:@"collections"];
    for (NSString *objId in collections) {
        if ([objId isEqualToString:_articleModel.objectId]) {
            self.bottomBar.collectBtn.selected = YES;
        }
    }
    
    NSMutableArray *likes = [user objectForKey:@"likes"];
    for (NSString *objId in likes) {
        if ([objId isEqualToString:_articleModel.objectId]) {
            self.bottomBar.likeBtn.selected = YES;
        }
    }
    
    NSMutableArray *unlikes = [user objectForKey:@"unlikes"];
    for (NSString *objId in unlikes) {
        if ([objId isEqualToString:_articleModel.objectId]) {
            self.bottomBar.unlikeBtn.selected = YES;
        }
    }
}
#pragma mark - getters and setters
- (void)setArticleModel:(ZKArticleModel *)articleModel {
    _articleModel = articleModel;
    
    CGFloat margin = 10;
    
    //设置数据
    //标题
    self.titlelabel.text = articleModel.title;
    self.titlelabel.x = margin;
    self.titlelabel.y = 5;
    self.titlelabel.width = screenW - 2 * _titlelabel.x;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    
    CGSize size = [articleModel.title boundingRectWithSize:CGSizeMake(_titlelabel.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    self.titlelabel.height = size.height;
    
    //信息
    self.infolabel.text = [NSString stringWithFormat:@"%@ · %@ · 顶%d·踩%d", articleModel.author, articleModel.date, articleModel.likeCount, articleModel.unlikeCount];
    self.infolabel.x = margin;
    self.infolabel.y = CGRectGetMaxY(_titlelabel.frame) + 10;
    self.infolabel.height = 20;
    self.infolabel.width = 250;
    
    //评论数
    [self.commentCountBtn setTitle:@"0评论" forState:UIControlStateNormal];
    [self.commentCountBtn sizeToFit];
    self.commentCountBtn.height = self.infolabel.height;
    self.commentCountBtn.y = self.infolabel.y;
    self.commentCountBtn.x = screenW - 2 * margin - self.commentCountBtn.width;
    
    //正文
    self.textView.textContent = articleModel.content;
    self.textView.x = margin;
    self.textView.y = CGRectGetMaxY(self.infolabel.frame) + 10;
//    self.textView.backgroundColor = [UIColor grayColor];
    
    //设置滚动区域
    self.mainScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.textView.frame) + 10);
    
    //设置底部工具条
    ZKBottomBar *bottomBar = [[ZKBottomBar alloc] init];
    _bottomBar = bottomBar;
    _bottomBar.delegate = self;
    [self.view addSubview:_bottomBar];
    
    //检测文章是否被赞过踩过收藏过
    [self setArticleInfo];
}

- (UIScrollView *)mainScrollView {
    if (_mainScrollView == nil) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, screenW, screenH - 20)];
        _mainScrollView = scrollView;
        _mainScrollView.delegate = self;
        [self.view addSubview:_mainScrollView];
    }
    return _mainScrollView;
}

- (UILabel *)titlelabel {
    if (_titlelabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        _titlelabel = label;
        label.font = [UIFont boldSystemFontOfSize:18];
        _titlelabel.numberOfLines = 2;
        [self.mainScrollView addSubview:_titlelabel];
    }
    return _titlelabel;
}

- (UILabel *)infolabel {
    if (_infolabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        _infolabel = label;
        _infolabel.font = [UIFont systemFontOfSize:12];
        _infolabel.textColor = RGBColor(180, 180, 180);
        [self.mainScrollView addSubview:_infolabel];
    }
    return _infolabel;
}

- (UIButton *)commentCountBtn {
    if (_commentCountBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentCountBtn = btn;
        [_commentCountBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_commentCountBtn setTitleColor:RGBColor(238, 33, 71) forState:UIControlStateNormal];
        [self.mainScrollView addSubview:_commentCountBtn];
    }
    return _commentCountBtn;
}

- (ZKTextContentView *)textView {
    if (_textView == nil) {
        ZKTextContentView *view = [[ZKTextContentView alloc] init];
        _textView = view;
        [self.mainScrollView addSubview:_textView];
    }
    return _textView;
}

@end
