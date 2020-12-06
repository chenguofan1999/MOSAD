//
//  UserInfo.h
//  mid
//
//  Created by itlab on 11/30/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface UserInfo : NSObject
@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *name;
@property (nonatomic) int classNum;
@property (nonatomic) NSString *bio;
@property (nonatomic) int gender;

@property (nonatomic) long maxSize;
@property (nonatomic) long usedSize;
@property (nonatomic) long singleSize;
@property (nonatomic) UIImage *avatar;

+ (UserInfo *)sharedUser;
+ (void)configUser:(NSDictionary *)dict;
+ (void)updateUserInfo;
@end

NS_ASSUME_NONNULL_END
