//
//  CommentItem.h
//  Final
//
//  Created by itlab on 1/3/21.
//

#import <Foundation/Foundation.h>
#import "MiniUserItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface CommentItem : NSObject
@property (nonatomic) int commentID;
@property (nonatomic) int contentID;
@property (nonatomic) NSString *commentText;
@property (nonatomic) long createTime;
@property (nonatomic) int likeNum;
@property (nonatomic) int replyNum;
@property (nonatomic) MiniUserItem *userItem;
@property (nonatomic) bool liked;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
