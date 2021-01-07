//
//  SceneDelegate.m
//  Final
//
//  Created by itlab on 12/23/20.
//

#import "SceneDelegate.h"
#import "MainTabBarController.h"
#import "PostContentViewController.h"
#import "VideoListTableViewController.h"
#import "LoginPageViewController.h"
#import "UserInfo.h"
@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
    self.window.rootViewController = [[LoginPageViewController alloc] init];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}

+ (UIWindow *)mainWindow
{
    UIWindow* window = nil;
    for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes)
        if (windowScene.activationState == UISceneActivationStateForegroundActive)
        {
            window = windowScene.windows.firstObject;
            break;
        }
    return window;
}

+ (bool)isIphoneXSerie
{
    if (@available(iOS 11.0, *)) {
        UIWindow* window = [SceneDelegate mainWindow];
            if (window.safeAreaInsets.top > 24.0) {
                return YES;
            }
        }
    return NO;
}

+ (void)jumpToTabBar
{
    UIWindow* mainwindow = [SceneDelegate mainWindow];
    mainwindow.rootViewController = [MainTabBarController new];
}

+ (void)jumpToLoginPage
{
    UIWindow* mainwindow = [SceneDelegate mainWindow];
    mainwindow.rootViewController = [[LoginPageViewController alloc]init];
}

- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}





@end
