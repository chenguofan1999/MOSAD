//
//  MiniUserItem.m
//  Final
//
//  Created by itlab on 12/28/20.
//

#import "MiniUserItem.h"
/*
 "user": {
     "userID": 10,
     "username": "Dooog",
     "avatar": "/static/avatars/user10_avatar.jpg",
     "followerNum": 0
 }
 
 */

@implementation MiniUserItem
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    self.userID = [dict[@"userID"] intValue];
    self.userName = dict[@"username"];
    self.avatarURL = dict[@"avatar"];
    self.followerNum = [dict[@"followerNum"] intValue];
    return self;
}
@end
