//
//  ContentItem.m
//  mid
//
//  Created by itlab on 12/1/20.
//

#import "FullDataItem.h"

@implementation FullDataItem
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    self.contentItem = [[ContentItem alloc]initWithDict:dict[@"Data"]];
    self.userItem = [[MiniUserItem alloc]initWithDict:dict[@"User"]];
    return self;
}
@end
