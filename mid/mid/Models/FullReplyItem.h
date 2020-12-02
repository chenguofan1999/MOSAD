//
//  FullReplyItem.h
//  mid
//
//  Created by itlab on 12/2/20.
//

#import <Foundation/Foundation.h>
#import "ReplyItem.h"
#import "MiniUserItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface FullReplyItem : NSObject
@property (nonatomic) ReplyItem *replyItem;
@property (nonatomic) MiniUserItem *userItem;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
