//
//  MainTabBarController.m
//  Final
//
//  Created by itlab on 12/28/20.
//

#import <MaterialComponents/MDCFloatingButton.h>
#import "MainTabBarController.h"
#import "LibraryPageViewController.h"
#import "SubscribingPageViewController.h"
#import "ExplorePageViewController.h"
#import "HomePageViewController.h"
#import "PostContentViewController.h"
#import "VideoListTableViewController.h"
#import "UserInfo.h"
#import "AppConfig.h"
#import "UserPageViewController.h"
@interface MainTabBarController ()

@end

@implementation MainTabBarController
- (instancetype)init {
    if (!(self = [super init])) {
       return nil;
    }
    self.tabBarController.delegate = self;
    
    UIEdgeInsets imageInsets = UIEdgeInsetsZero;//UIEdgeInsetsMake(4.5, 0, -4.5, 0);
    UIOffset titlePositionAdjustment = UIOffsetMake(0, -3.5);
    CYLTabBarController *tabBarController = [CYLTabBarController tabBarControllerWithViewControllers:self.viewControllers
                                                                              tabBarItemsAttributes:self.tabBarItemsAttributesForController
                                                                                        imageInsets:imageInsets
                                                                            titlePositionAdjustment:titlePositionAdjustment
                                                                                            context:nil];
    
    
    [self customizeTabBarAppearance:tabBarController];
    return (self = (MainTabBarController *)tabBarController);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [PlusButton registerPlusButton];
    
}


- (void)customizeTabBarAppearance:(CYLTabBarController *)tabBarController
{
    [tabBarController.tabBar setTintColor:[AppConfig getMainColor]];
    [tabBarController.tabBar setUnselectedItemTintColor:[UIColor darkGrayColor]];
    [tabBarController.tabBar setTranslucent:NO];
    
    [UINavigationBar.appearance setTranslucent:NO];
}

- (NSArray *)viewControllers {
    // Home Page
    HomePageViewController *homePageViewController = [[HomePageViewController alloc] init];
    UIViewController *homePageNavigationController = [[CYLBaseNavigationController alloc]
                                                  initWithRootViewController:homePageViewController];
    [homePageViewController cyl_setHideNavigationBarSeparator:YES];
    
    // Explore Page
    ExplorePageViewController *explorePageViewController = [[ExplorePageViewController alloc] init];
    UIViewController *explorePageNavigationController = [[CYLBaseNavigationController alloc]
                                                   initWithRootViewController:explorePageViewController];
    [explorePageViewController cyl_setHideNavigationBarSeparator:YES];
    
//    PostContentViewController *postContentViewController = [[PostContentViewController alloc] init];
//    UIViewController *postContentNavigationController = [[CYLBaseNavigationController alloc]
//                                                   initWithRootViewController:postContentViewController];
//    [postContentViewController cyl_setHideNavigationBarSeparator:YES];

    // Subscription Page
    SubscribingPageViewController *subscribingPageViewController = [[SubscribingPageViewController alloc] init];
    UIViewController *subscribingPageNavigationController = [[CYLBaseNavigationController alloc]
                                                  initWithRootViewController:subscribingPageViewController];
    [subscribingPageNavigationController cyl_setHideNavigationBarSeparator:YES];
    
    // Library Page
//    LibraryPageViewController *libraryPageViewController = [[LibraryPageViewController alloc] init];
    UserPageViewController *libraryPageViewController = [[UserPageViewController alloc] initWithUsername:[UserInfo sharedUser].username];
    UIViewController *libraryPageNavigationController = [[CYLBaseNavigationController alloc]
                                                   initWithRootViewController:libraryPageViewController];
    [libraryPageViewController cyl_setHideNavigationBarSeparator:YES];
    
    NSArray *viewControllers = @[homePageNavigationController,
                                 subscribingPageNavigationController,
                                 explorePageNavigationController,
                                 libraryPageNavigationController
    ];
   return viewControllers;
}

- (NSArray *)tabBarItemsAttributesForController {
    NSDictionary *homeTabBarItemsAttributes = @{
                                                CYLTabBarItemTitle : @"Home",
                                                CYLTabBarItemImage : [UIImage imageNamed:@"home-filled@2x.png"],
                                                CYLTabBarItemSelectedImage : [UIImage imageNamed:@"home-filled@2x.png"],
                                                };
    NSDictionary *subscriptionTabBarItemsAttributes = @{
                                                CYLTabBarItemTitle : @"Subscriptions",
                                                CYLTabBarItemImage : [UIImage imageNamed:@"playlist-filled@2x.png"],
                                                CYLTabBarItemSelectedImage : [UIImage imageNamed:@"playlist-filled@2x.png"],
                                                };
//    NSDictionary *plusTabBarItemsAttributes = @{
//                                                CYLTabBarItemImage : [UIImage imageNamed:@"plus@3x.png"],
//                                                CYLTabBarItemSelectedImage : [UIImage imageNamed:@"plus@3x.png"],
//                                                };
    NSDictionary *exploreTabBarItemsAttributes = @{
                                                CYLTabBarItemTitle : @"Explore",
                                                CYLTabBarItemImage : [UIImage imageNamed:@"compass-filled@2x.png"],
                                                CYLTabBarItemSelectedImage : [UIImage imageNamed:@"compass-filled@2x.png"],
                                                };
    NSDictionary *libraryTabBarItemsAttributes = @{
                                                CYLTabBarItemTitle : @"My",
                                                CYLTabBarItemImage : [UIImage imageNamed:@"user-filled@2x.png"],
                                                CYLTabBarItemSelectedImage : [UIImage imageNamed:@"user-filled@2x.png"],
                                                };
   

    NSArray *tabBarItemsAttributes = @[
                                      homeTabBarItemsAttributes,
                                      subscriptionTabBarItemsAttributes,
                                      exploreTabBarItemsAttributes,
                                      libraryTabBarItemsAttributes
                                      ];
    return tabBarItemsAttributes;
}

//- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
//   [[self cyl_tabBarController] updateSelectionStatusIfNeededForTabBarController:tabBarController shouldSelectViewController:viewController];
//   return YES;
//}




//- (void)tabBarController:(UITabBarController *)tabBarController didSelectControl:(UIControl *)control {
//
//}


@end
