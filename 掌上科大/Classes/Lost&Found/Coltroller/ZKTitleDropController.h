//
//  FWTitleDropController.h
//  FS微博
//
//  Created by 樊樊帅 on 6/16/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZKTitleDropController;

@protocol ZKTitleDropControllerDelegate <NSObject>

- (void)titleDropControllerDidSelectedShowAll:(ZKTitleDropController *)titleDropController;

- (void)titleDropControllerDidSelectedShowFound:(ZKTitleDropController *)titleDropController;

- (void)titleDropControllerDidSelectedShowLost:(ZKTitleDropController *)titleDropController;

@end

@interface ZKTitleDropController : UITableViewController

@property (nonatomic, assign) id<ZKTitleDropControllerDelegate> delegate;

@end
