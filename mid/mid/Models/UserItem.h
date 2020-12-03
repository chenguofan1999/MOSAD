//
//  UserItem.h
//  mid
//
//  Created by itlab on 12/3/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserItem : NSObject
@property (nonatomic) NSString *userID;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *userName;
@property (nonatomic) int classNum;
@property (nonatomic) UIImage *avatar;
@property (nonatomic) NSString *bio;
@property (nonatomic) int gender;

@property (nonatomic) long maxSize;
@property (nonatomic) long usedSize;
@property (nonatomic) long singleSize;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
