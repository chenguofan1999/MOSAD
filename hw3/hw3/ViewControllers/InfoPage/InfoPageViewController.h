//
//  InfoPageViewController.h
//  hw3
//
//  Created by itlab on 12/7/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InfoPageViewController : UITableViewController
@property (nonatomic) NSString *userName;

- (instancetype)initWithUserName:(NSString *)username;
@end

NS_ASSUME_NONNULL_END
