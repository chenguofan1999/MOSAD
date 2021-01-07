//
//  UserListTableViewController.h
//  Final
//
//  Created by itlab on 1/7/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, UserListTableType) {
    UserListTableTypeFollowing,
    UserListTableTypeFollowed
};

@interface UserListTableViewController : UITableViewController
- (instancetype)initWithUsername:(NSString *)username type:(UserListTableType)type;
@end

NS_ASSUME_NONNULL_END
