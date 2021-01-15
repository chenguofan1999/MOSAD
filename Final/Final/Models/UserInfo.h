//
//  UserInfo.h
//  Final
//
//  Created by itlab on 12/29/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserInfo : NSObject
@property (nonatomic) NSString *username;
@property (nonatomic) NSString *avatarURL;
@property (nonatomic) NSString *token;
@property (nonatomic) NSString *bio;
@property (nonatomic) int userID;
@property (nonatomic) int followerNum;
@property (nonatomic) int followingNum;
@property (nonatomic) int likeNum;
@property (nonatomic) NSMutableArray *userTags;

+ (UserInfo *)sharedUser;
+ (void)configUser:(NSDictionary *)dict;
+ (void)updateInfo;
@end

NS_ASSUME_NONNULL_END
