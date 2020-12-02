//
//  CommentItem.m
//  mid
//
//  Created by itlab on 12/2/20.
//

#import "CommentItem.h"

@implementation CommentItem
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    self.commentID = dict[@"ID"];
    self.contentID = dict[@"ContentID"];
    self.fatherID = dict[@"FatherID"];
    self.userID = dict[@"UserID"];
    self.publishDate = [dict[@"Date"] longValue];
    self.commentContent = dict[@"Content"];
    self.likeNum = [dict[@"LikeNum"] intValue];
    
    return self;
}
@end
