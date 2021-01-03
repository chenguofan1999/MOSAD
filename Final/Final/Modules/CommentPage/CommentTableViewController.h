//
//  CommentTableViewController.h
//  Final
//
//  Created by itlab on 1/3/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentTableViewController : UITableViewController
@property (nonatomic) int contentID;
@property (nonatomic) NSMutableArray *commentItems;
- (instancetype)initWithContentID:(int)contentID;
@end

NS_ASSUME_NONNULL_END
