//
//  ReplyItem.h
//  Final
//
//  Created by itlab on 1/3/21.
//

#import <Foundation/Foundation.h>
#import "MiniUserItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface ReplyItem : NSObject
@property (nonatomic) int replyID;
@property (nonatomic) int commentID;
@property (nonatomic) NSString *replyText;
@property (nonatomic) long createTime;
@property (nonatomic) int likeNum;
@property (nonatomic) MiniUserItem *userItem;
@property (nonatomic) bool liked;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
