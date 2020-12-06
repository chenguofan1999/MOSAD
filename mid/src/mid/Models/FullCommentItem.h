//
//  CommentItem.h
//  mid
//
//  Created by itlab on 12/2/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CommentItem.h"
#import "MiniUserItem.h"
#import "ReplyItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface FullCommentItem : NSObject
@property (nonatomic) CommentItem *commentItem;
@property (nonatomic) MiniUserItem *userItem;
@property (nonatomic) NSArray *replies;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
