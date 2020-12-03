//
//  ProfileViewController.h
//  mid
//
//  Created by itlab on 11/26/20.
//

#import <UIKit/UIKit.h>
#import "UserItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface ProfilePageViewController : UIViewController
@property (nonatomic) NSString *userID;
- (instancetype)initWithUserID:(NSString *)userID;
@end

NS_ASSUME_NONNULL_END
