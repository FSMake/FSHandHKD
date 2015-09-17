//
//  ZKCommentModel.m
//  掌上科大
//
//  Created by 樊樊帅 on 7/5/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "ZKCommentModel.h"

@implementation ZKCommentModel

+ (instancetype)commentWithCommentObject:(BmobObject *)commentObject {
    ZKCommentModel *model = [[ZKCommentModel alloc] init];
    model.commentObject = commentObject;
    return model;
}

- (void)setCommentObject:(BmobObject *)commentObject {
    _commentObject = commentObject;
    
    NSString *content = [commentObject objectForKey:@"content"];
    BmobUser *commenter = [commentObject objectForKey:@"commenter"];
    
    self.content = content;
    self.commenter = commenter;
}

@end
