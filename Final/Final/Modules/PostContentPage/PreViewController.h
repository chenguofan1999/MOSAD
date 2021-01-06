//
//  PreViewController.h
//  Final
//
//  Created by itlab on 1/5/21.
//

#import <UIKit/UIKit.h>
#import <SJVideoPlayer/SJVideoPlayer.h>
#import <MaterialComponents/MDCButton+MaterialTheming.h>
#import "PostContentViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface PreViewController : UIViewController
@property (nonatomic, strong) SJVideoPlayer *player;
@property (nonatomic, strong) MDCButton *screenShotButton;
@property (nonatomic, strong) PostContentViewController *parentPageVC;
@property (nonatomic) NSURL *URL;
- (instancetype)initWithURL:(NSURL *)URL;
- (instancetype)initWithURL:(NSURL *)URL parentVC:(PostContentViewController *)viewController;
@end

NS_ASSUME_NONNULL_END
