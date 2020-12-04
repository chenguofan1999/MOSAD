//
//  TabBarController.m
//  mid
//
//  Created by itlab on 2020/11/23.
//

#import "TabBarController.h"
#import "MainPageViewController.h"
#import "DiscoverViewController.h"
#import "UserCenterViewController.h"
#import "WritingPostViewController.h"
#import <Masonry/Masonry.h>

@interface TabBarController ()
@property (nonatomic) UIButton *fixedButton;
@end

@implementation TabBarController


- (void)viewDidLoad
{
    [super viewDidLoad];
    MainPageViewController *mainPage = [[MainPageViewController alloc]init];
    UINavigationController *mainPageNav = [[UINavigationController alloc]initWithRootViewController:mainPage];
    mainPageNav.navigationBar.translucent = NO;
    
    DiscoverViewController *discoverPage = [[DiscoverViewController alloc]init];
    [discoverPage loadData];
    UINavigationController *discoverNav = [[UINavigationController alloc]initWithRootViewController:discoverPage];
    discoverNav.navigationBar.translucent = NO;
    
    UserCenterViewController *settingPage = [[UserCenterViewController alloc]init];
    UINavigationController *settingNav = [[UINavigationController alloc]initWithRootViewController:settingPage];
    settingNav.navigationBar.translucent = NO;
    
    self.tabBar.translucent = NO;
    self.viewControllers = @[mainPageNav, discoverNav, settingNav];
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}





#pragma mark


@end
