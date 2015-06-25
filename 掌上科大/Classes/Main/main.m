//
//  main.m
//  掌上科大
//
//  Created by 樊樊帅 on 6/24/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <BmobSDK/Bmob.h>

int main(int argc, char * argv[]) {
    @autoreleasepool {
        NSString *appid = @"26343cca3cc3bf8a68a4bdfcff63803a";
        [Bmob registerWithAppKey:appid];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
