//
//  FullReplyItem.m
//  mid
//
//  Created by itlab on 12/2/20.
//

#import "FullReplyItem.h"

@implementation FullReplyItem
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    
    self.replyItem = [[ReplyItem alloc]initWithDict:dict[@"Reply"]];
    self.userItem = [[MiniUserItem alloc]initWithDict:dict[@"User"]];
    
    return self;
}
@end
