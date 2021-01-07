//
//  UserItem.m
//  Final
//
//  Created by itlab on 1/7/21.
//

#import "UserItem.h"

@implementation UserItem

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    self.userID = [dict[@"userID"] intValue];
    self.bio = dict[@"bio"];
    self.userName = dict[@"username"];
    self.avatarURL = dict[@"avatar"];
    self.followerNum = [dict[@"followerNum"] intValue];
    self.followingNum = [dict[@"followingNum"] intValue];
    self.likeNum = [dict[@"likeNum"] intValue];
    self.followedByMe = [dict[@"followedByMe"] boolValue];
    return self;
}
@end
