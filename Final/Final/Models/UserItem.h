//
//  UserItem.h
//  Final
//
//  Created by itlab on 1/7/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserItem : NSObject
@property (nonatomic) NSString *userName;
@property (nonatomic) NSString *avatarURL;
@property (nonatomic) NSString *bio;
@property (nonatomic) int userID;

@property (nonatomic) int followerNum;
@property (nonatomic) int followingNum;
@property (nonatomic) int likeNum;

@property (nonatomic) bool followedByMe;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
