//
//  UserInfo.h
//  mid
//
//  Created by itlab on 11/30/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserInfo : NSObject
@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *name;
@property (nonatomic) int classNum;
@property (nonatomic) NSString *bio;
@property (nonatomic) int gender;

@property (nonatomic) NSInteger *maxSize;
@property (nonatomic) NSInteger *usedSize;
@property (nonatomic) NSInteger *singleSize;


+ (UserInfo *)sharedUser;
+ (void)configUser:(NSDictionary *)dict;
+ (void)updateUserInfo;
@end

NS_ASSUME_NONNULL_END
