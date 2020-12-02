//
//  PostItem.m
//  mid
//
//  Created by itlab on 12/1/20.
//

#import "ContentItem.h"

@implementation ContentItem

- (id)init
{
  self = [super init];

  _tags = [NSMutableArray new];
  return self;
}

- (NSDictionary *)getDict
{
    NSDictionary *dict = @{
        @"title" : _title,
        @"detail" : _detail,
        @"tags" : _tags,
        @"isPublic" : [NSNumber numberWithBool:_isPublic]
    };
    return dict;
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    self.title = dict[@"Name"];
    self.detail = dict[@"Detail"];
    self.isPublic = [dict[@"Public"] intValue] == 1;
    self.tags = (NSMutableArray *)dict[@"Tag"];
    self.contentID = dict[@"ID"];
    self.ownerID = dict[@"OwnID"];
    self.PublishDate = [dict[@"PublishDate"] longValue];
    self.likeNum = [dict[@"LikeNum"] intValue];
    self.commentNum = [dict[@"CommentNum"] intValue];
    
    return self;
}
@end
