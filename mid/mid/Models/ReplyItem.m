//
//  ReplyItem.m
//  mid
//
//  Created by itlab on 12/2/20.
//

#import "ReplyItem.h"

@implementation ReplyItem
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    self.replyID = dict[@"ID"];
    self.contentID = dict[@"ContentID"];
    self.fatherID = dict[@"FatherID"];
    self.userID = dict[@"UserID"];
    self.publishDate = [dict[@"Date"] longValue];
    self.replyContent = dict[@"Content"];
    self.likeNum = [dict[@"LikeNum"] intValue];
    
    return self;
}
@end
