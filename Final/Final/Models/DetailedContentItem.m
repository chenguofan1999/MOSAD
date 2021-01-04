//
//  DetailedContentItem.m
//  Final
//
//  Created by itlab on 12/31/20.
//

#import "DetailedContentItem.h"

@implementation DetailedContentItem
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    self.contentID = [dict[@"contentID"] intValue];
    self.videoTitle = dict[@"title"];
    self.videoDescription = dict[@"description"];
    self.createTime = [dict[@"createTime"] longValue];
    self.videoURL = dict[@"video"];
    self.userItem = [[MiniUserItem alloc] initWithDict:dict[@"user"]];
    self.liked = [dict[@"liked"] boolValue];
    self.viewNum = [dict[@"viewNum"] intValue];
    self.commentNum = [dict[@"commentNum"] intValue];
    self.likeNum = [dict[@"likeNum"] intValue];
    
//    self.videoTags = [NSMutableArray new];
//    NSArray *tags = dict[@"tags"];
//    for(int i = 0; i < [tags count]; i ++)
//        [[self mutableArrayValueForKey:@"videoTags"] addObject:tags[i]];
    self.videoTags = [[NSMutableArray alloc]initWithArray: dict[@"tags"]];
    return self;
}
@end




