//
//  CommentCell.h
//  mid
//
//  Created by itlab on 11/28/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIButton *portraitButton;
@property (nonatomic, strong) IBOutlet UILabel *timeLable;
@property (nonatomic, strong) IBOutlet UILabel *userNameLable;
@property (nonatomic, strong) IBOutlet UILabel *textContentLable;
@property (nonatomic, strong) IBOutlet UIButton *replyButton;
@property (nonatomic, strong) IBOutlet UIButton *likeButton;
@property (nonatomic, strong) IBOutlet UIButton *deleteButton;
@property (nonatomic, strong) IBOutlet UILabel *replyLabel;
@property (nonatomic, strong) IBOutlet UILabel *likeLabel;
@end

NS_ASSUME_NONNULL_END
