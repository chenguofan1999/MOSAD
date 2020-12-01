//
//  UserInfo.m
//  mid
//
//  Created by itlab on 11/30/20.
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

+ (void)updateUserInfo
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *selfURL = @"http://172.18.178.56/api/user/info/self";
    [manager GET:selfURL parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"\nSelf Info: %@", responseObject);
        NSDictionary *selfInfo = (NSDictionary *)responseObject;
        [UserInfo configUser:selfInfo];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Update failed");
    }];
}
@end
