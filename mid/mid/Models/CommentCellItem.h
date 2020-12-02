//
//  CommentCellItem.h
//  mid
//
//  Created by itlab on 12/2/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FullCommentItem.h"
#import "FullReplyItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommentCellItem : NSObject
@property (nonatomic) NSString *userName;
@property (nonatomic) NSString *commentContent;
@property (nonatomic) NSString *publishDate;
@property (nonatomic) NSString *commentID;
@property (nonatomic) UIImage *avatar;
@property (nonatomic) int likeNum;
@property (nonatomic) bool hideDeleteButton;
@property (nonatomic) bool hideReplyButton;
@property (nonatomic) bool isReply;

- (instancetype)initWithFullCommentItem:(FullCommentItem *)fullCommentItem;
- (instancetype)initWithFullReplyItem:(FullReplyItem *)fullReplyItem
                  andCommentOwnerName:(NSString *)commentOwnerName;
@end

NS_ASSUME_NONNULL_END
