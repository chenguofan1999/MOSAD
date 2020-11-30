//
//  UserInfo.m
//  mid
//
//  Created by itlab on 11/30/20.
//

#import "UserInfo.h"
static UserInfo *userInfo = nil;

@implementation UserInfo


+ (id)sharedUser
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        userInfo = [[UserInfo alloc]init];
    });
    return userInfo;
}

+ (void)configUser:(NSDictionary *)dict
{
    UserInfo *sharedInfo = [UserInfo sharedUser];
    sharedInfo.name = dict[@"Name"];
    sharedInfo.email = dict[@"Email"];
    sharedInfo.userId = dict[@"ID"];
    sharedInfo.bio = dict[@"Info"][@"Bio"];
    sharedInfo.classNum = [dict[@"Class"] intValue];
    sharedInfo.gender = [dict[@"Info"][@"Gender"] intValue];
}
@end
