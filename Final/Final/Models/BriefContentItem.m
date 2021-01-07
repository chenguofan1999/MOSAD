//
//  BriefContentItem.m
//  Final
//
//  Created by itlab on 12/28/20.
//

#import "BriefContentItem.h"

@implementation BriefContentItem
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    self.contentID = [dict[@"contentID"] intValue];
    self.title = dict[@"title"];
    self.duration = [dict[@"duration"] intValue];
    self.coverURL = dict[@"cover"];
    self.createTime = [dict[@"createTime"] longValue];
    self.viewNum = [dict[@"viewNum"] intValue];
    self.userItem = [[MiniUserItem alloc]initWithDict:dict[@"user"]];
    return self;
}
@end
