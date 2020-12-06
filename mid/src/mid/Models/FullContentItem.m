//
//  FullContentItem.m
//  mid
//
//  Created by itlab on 12/3/20.
//

#import "FullContentItem.h"

@implementation FullContentItem
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    self.contentItem = [[ContentItem alloc]initWithDict:dict[@"Data"]];
    self.userItem = [[MiniUserItem alloc]initWithDict:dict[@"User"]];
    return self;
}
@end
