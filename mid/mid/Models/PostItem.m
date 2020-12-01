//
//  PostItem.m
//  mid
//
//  Created by itlab on 12/1/20.
//

#import "PostItem.h"

@implementation PostItem

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
@end
