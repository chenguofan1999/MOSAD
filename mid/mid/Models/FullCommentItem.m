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
    
    self.commentID = dict[@"Comment"][@"ID"];
    self.contentID = dict[@"Comment"][@"ContentID"];
    self.userID = dict[@"Comment"][@"UserID"];
    self.publishDate = [dict[@"Comment"][@"Date"] longValue];
    self.commentContent = dict[@"Comment"][@"Content"];
    self.likeNum = [dict[@"Comment"][@"LikeNum"] intValue];
    
    self.userName = dict[@"User"][@"Name"];
    self.gender = [dict[@"User"][@"Gender"] intValue];
    
    return self;
}

@end
