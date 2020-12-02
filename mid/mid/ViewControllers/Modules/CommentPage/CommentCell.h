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
@end

NS_ASSUME_NONNULL_END
