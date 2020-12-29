//
//  MiniUserItem.h
//  Final
//
//  Created by itlab on 12/28/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MiniUserItem : NSObject
@property (nonatomic) NSString *userName;
@property (nonatomic) NSString *avatarURL;
@property (nonatomic) int userID;
@property (nonatomic) int followerNum;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
