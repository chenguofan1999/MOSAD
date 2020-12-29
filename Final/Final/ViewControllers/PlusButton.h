//
//  PlusButton.h
//  Final
//
//  Created by itlab on 12/28/20.
//

#import <CYLTabBarController/CYLTabBarController.h>
#import "MainTabBarController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlusButton : CYLPlusButton<CYLPlusButtonSubclassing>
@property (nonatomic, strong) MainTabBarController *tabbarVC;
@end

NS_ASSUME_NONNULL_END
