//
//  ReplyCell.h
//  mid
//
//  Created by itlab on 12/3/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReplyCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIButton *portraitButton;
@property (nonatomic, strong) IBOutlet UILabel *timeLable;
@property (nonatomic, strong) IBOutlet UILabel *userNameLable;
@property (nonatomic, strong) IBOutlet UILabel *textContentLable;
@property (nonatomic, strong) IBOutlet UIButton *likeButton;
@property (nonatomic, strong) IBOutlet UILabel *likeLabel;
@end

NS_ASSUME_NONNULL_END
