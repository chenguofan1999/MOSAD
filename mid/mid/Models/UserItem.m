//
//  UserItem.m
//  mid
//
//  Created by itlab on 12/3/20.
//

#import "UserItem.h"

@implementation UserItem
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    self.userName = dict[@"Name"];
    self.userID = dict[@"ID"];
    self.email = dict[@"Email"];
    self.classNum = [dict[@"Class"] intValue];
    self.avatar = [UIImage imageNamed:@"maleUser.png"];
    self.gender = [dict[@"Info"][@"Gender"] intValue];
    self.bio = dict[@"Info"][@"Bio"];
    self.maxSize = [dict[@"MaxSize"] longValue];
    self.usedSize = [dict[@"UsedSize"] longValue];
    self.singleSize = [dict[@"SingleSize"] longValue];
    return self;
}
@end
