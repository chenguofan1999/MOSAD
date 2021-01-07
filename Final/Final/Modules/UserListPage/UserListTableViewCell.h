//
//  UserListTableViewCell.h
//  Final
//
//  Created by itlab on 1/7/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserListTableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIImageView *avatarView;
@property (nonatomic, strong) IBOutlet UILabel *usernameLabel;
@property (nonatomic, strong) IBOutlet UILabel *subscriberLabel;
@end

NS_ASSUME_NONNULL_END
