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
@property (nonatomic) NSString *userName;
- (instancetype)initWithUserID:(NSString *)userID
                      userName:(NSString *)userName;
@end

NS_ASSUME_NONNULL_END
