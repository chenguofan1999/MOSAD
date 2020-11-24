//
//  TabBarController.m
//  mid
//
//  Created by itlab on 2020/11/23.
//

#import "TabBarController.h"
#import "MyPageViewController.h"
#import "DiscoverViewController.h"
#import "SettingViewController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    MyPageViewController *myPage = [[MyPageViewController alloc]init];
    UINavigationController *myPageNav = [[UINavigationController alloc]initWithRootViewController:myPage];
    
    DiscoverViewController *discoverPage = [[DiscoverViewController alloc]init];
    UINavigationController *discoverNav = [[UINavigationController alloc]initWithRootViewController:discoverPage];
    
    SettingViewController *settingPage = [[SettingViewController alloc]init];
    UINavigationController *settingNav = [[UINavigationController alloc]initWithRootViewController:settingPage];
    
    self.viewControllers = @[myPageNav, discoverNav, settingNav];
}


@end
