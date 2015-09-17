//
//  FWSearchBar.m
//  FS微博
//
//  Created by 樊樊帅 on 6/16/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKSearchBar.h"

@implementation ZKSearchBar

+ (instancetype)searchBar {
    //定义搜索框
    ZKSearchBar *searchBar = [[ZKSearchBar alloc] initWithFrame:CGRectMake(0, 0, screenW - 20, 30)];
    [searchBar setBackground:[UIImage imageNamed:@"searchbar_textfield_background"]];
    //搜索框左边放大镜
    UIImageView *searchBarImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchbar_textfield_search_icon"]];
    searchBarImg.bounds = CGRectMake(0, 0, 30, 30);
    searchBarImg.contentMode = UIViewContentModeCenter;
    searchBar.leftView = searchBarImg;
    searchBar.leftViewMode = UITextFieldViewModeAlways;
    //字体
    searchBar.font = [UIFont systemFontOfSize:15.0];
    //占位
    searchBar.placeholder = @"请输入关键字";
    searchBar.returnKeyType = UIReturnKeySearch;
    
    return searchBar;
}

@end
