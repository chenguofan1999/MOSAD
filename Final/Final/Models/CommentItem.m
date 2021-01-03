//
//  CommentItem.m
//  Final
//
//  Created by itlab on 1/3/21.
//

#import "CommentItem.h"

@implementation CommentItem
-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    self.commentID = [dict[@"commentID"] intValue];
    self.contentID = [dict[@"contentID"] intValue];
    self.commentText = dict[@"text"];
    self.createTime = [dict[@"createTime"] longValue];
    self.likeNum = [dict[@"likeNum"] intValue];
    self.replyNum = [dict[@"replyNum"] intValue];
    self.userItem = [[MiniUserItem alloc]initWithDict:dict[@"user"]];
    self.liked = [dict[@"liked"] boolValue];
    return self;
}

@end
