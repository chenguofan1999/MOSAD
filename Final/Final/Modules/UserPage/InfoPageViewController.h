//
//  InfoPageViewController.h
//  Final
//
//  Created by itlab on 1/7/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InfoPageViewController : UIViewController
@property (nonatomic) NSString *username;
-(instancetype) initWithUsername:(NSString *)username;
@end

NS_ASSUME_NONNULL_END
