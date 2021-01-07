//
//  SceneDelegate.h
//  Final
//
//  Created by itlab on 12/23/20.
//

#import <UIKit/UIKit.h>

@interface SceneDelegate : UIResponder <UIWindowSceneDelegate>

@property (strong, nonatomic) UIWindow * window;
+ (UIWindow *)mainWindow;
+ (bool)isIphoneXSerie;
+ (void)jumpToTabBar;
+ (void)jumpToLoginPage;
@end

