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
    self.contentData = [[ContentItem alloc]initWithDict:dict[@"Data"]];
    self.userName = dict[@"User"][@"Name"];
    self.gender = [dict[@"User"][@"Gender"] intValue];
    return self;
}
@end
