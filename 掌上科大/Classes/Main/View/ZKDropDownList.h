//
//  FWDropDownList.h
//  FS微博
//
//  Created by 樊樊帅 on 6/16/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZKDropDownList;

@protocol ZKDropDownListDelegate <NSObject>

- (void)dropDownListDidDismiss:(ZKDropDownList *)dropDownList;

- (void)dropDownListDidShow:(ZKDropDownList *)dropDownList;

@end

@interface ZKDropDownList : UIView
/**
 *  下拉菜单内容
 */
@property (nonatomic, weak) UIView *contentView;
/**
 *  内容控制器
 */
@property (nonatomic, strong) UITableViewController *tableViewVc;
/**
 *  呼出菜单者
 */
@property (nonatomic, strong) UIView *caller;

@property (nonatomic, weak) id<ZKDropDownListDelegate> delegate;

+ (instancetype)dropDownList;

- (void)show;

- (void)dismiss;

@end
