//
//  CommentItem.m
//  mid
//
//  Created by itlab on 12/2/20.
//

#import "FullCommentItem.h"

@implementation FullCommentItem

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    self.commentItem = [[CommentItem alloc]initWithDict:dict[@"Comment"]];
    self.userItem = [[MiniUserItem alloc]initWithDict:dict[@"User"]];
    self.replies = dict[@"Replies"];
    return self;
}

@end
