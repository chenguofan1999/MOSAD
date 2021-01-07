//
//  UserPageViewController.h
//  Final
//
//  Created by itlab on 1/7/21.
//

#import <UIKit/UIKit.h>
#import "NavedViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface UserPageViewController : UIViewController
@property (nonatomic) NSString *username;
- (instancetype)initWithUsername:(NSString *)username;
@end

NS_ASSUME_NONNULL_END
