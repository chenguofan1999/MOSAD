//
//  ReplyTableViewController.h
//  Final
//
//  Created by itlab on 1/3/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReplyTableViewController : UITableViewController
@property (nonatomic) int commentID;
@property (nonatomic) NSMutableArray *replyItems;
- (instancetype)initWithCommentID:(int)commentID;
@end

NS_ASSUME_NONNULL_END
