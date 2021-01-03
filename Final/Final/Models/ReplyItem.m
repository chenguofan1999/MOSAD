//
//  ReplyItem.m
//  Final
//
//  Created by itlab on 1/3/21.
//

#import "ReplyItem.h"

@implementation ReplyItem
-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    self.replyID = [dict[@"replyID"] intValue];
    self.commentID = [dict[@"commentID"] intValue];
    self.replyText = dict[@"text"];
    self.createTime = [dict[@"createTime"] longValue];
    self.likeNum = [dict[@"likeNum"] intValue];
    self.userItem = [[MiniUserItem alloc]initWithDict:dict[@"user"]];
    self.liked = [dict[@"liked"] boolValue];
    return self;
}

@end
