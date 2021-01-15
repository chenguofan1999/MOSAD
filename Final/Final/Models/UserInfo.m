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

+ (void)updateInfo
{
    NSString *getInfoURL = @"http://159.75.1.231:5009/user";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *header = @{@"Authorization":[UserInfo sharedUser].token};
    [manager GET:getInfoURL parameters:nil headers:header progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *response = (NSDictionary *)responseObject;
        if([response[@"status"] isEqualToString:@"success"])
        {
            [UserInfo configUser:response[@"data"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed to get userinfo");
    }];
}

@end
