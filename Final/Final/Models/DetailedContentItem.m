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
    self.videoTags = dict[@"tags"];
    return self;
}
@end




