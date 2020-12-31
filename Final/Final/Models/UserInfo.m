//
//  UserInfo.m
//  Final
//
//  Created by itlab on 12/29/20.
//

#import "UserInfo.h"
#import <AFNetworking/AFNetworking.h>
static UserInfo *userInfo = nil;

@implementation UserInfo
+ (UserInfo *)sharedUser
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        userInfo = [[UserInfo alloc]init];
        userInfo.username = @"";
    });
    return userInfo;
}

+ (void)configUser:(NSDictionary *)dict
{
    UserInfo *sharedInfo = [UserInfo sharedUser];
    sharedInfo.username = dict[@"username"];
    sharedInfo.bio = dict[@"bio"];
    sharedInfo.userID = [dict[@"userID"] intValue];
    sharedInfo.avatarURL = dict[@"avatar"];
    sharedInfo.followerNum = [dict[@"followerNum"] intValue];
    sharedInfo.followingNum = [dict[@"followingNum"] intValue];
    sharedInfo.likeNum = [dict[@"likeNum"] intValue];
}

@end
