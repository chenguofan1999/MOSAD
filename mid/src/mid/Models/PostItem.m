//
//  PostItem.m
//  mid
//
//  Created by itlab on 12/1/20.
//

#import "SendPostItem.h"

@implementation SendPostItem

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
    self.title = dict[@"Title"];
    self.detail = dict[@"Detail"];
    self.isPublic = [dict[@"Public"] intValue] == 1;
    self.tags = (NSMutableArray *)dict[@"Tag"];
    return self;
}
@end
