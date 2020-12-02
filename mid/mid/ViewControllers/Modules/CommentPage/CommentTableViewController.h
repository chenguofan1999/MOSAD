//
//  CommentTableViewController.h
//  mid
//
//  Created by itlab on 11/28/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentTableViewController : UITableViewController
@property (nonatomic) NSString *contentID;
@property (nonatomic) NSMutableArray *commentItems;
- (instancetype)initWithContentID:(NSString *)contentID;
@end

NS_ASSUME_NONNULL_END
