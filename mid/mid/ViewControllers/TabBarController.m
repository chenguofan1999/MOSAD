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
@property (nonatomic, strong) UIButton *fixedButton;
@end

@implementation TabBarController


- (void)viewDidLoad
{
    [super viewDidLoad];
    MainPageViewController *mainPage = [[MainPageViewController alloc]init];
    UINavigationController *mainPageNav = [[UINavigationController alloc]initWithRootViewController:mainPage];
    mainPageNav.navigationBar.translucent = NO;
    
    DiscoverViewController *discoverPage = [[DiscoverViewController alloc]init];
    UINavigationController *discoverNav = [[UINavigationController alloc]initWithRootViewController:discoverPage];
    discoverNav.navigationBar.translucent = NO;
    
    UserCenterViewController *settingPage = [[UserCenterViewController alloc]init];
    UINavigationController *settingNav = [[UINavigationController alloc]initWithRootViewController:settingPage];
    settingNav.navigationBar.translucent = NO;
    
    self.tabBar.translucent = NO;
    self.viewControllers = @[mainPageNav, discoverNav, settingNav];
    
    //[self addButton];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

//#pragma mark 创建新post的按钮
//- (void)addButton
//{
//    _fixedButton = [UIButton new];
//    [_fixedButton setBackgroundColor:[UIColor colorWithRed:(float)52/255 green:(float)152/255 blue:(float)219/255 alpha:0.5]];
//    [_fixedButton.layer setCornerRadius:27.5];
//    [_fixedButton setTitle:@"+" forState:UIControlStateNormal];
//    [self.view addSubview:_fixedButton];
//    [_fixedButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-20);
//        make.bottom.equalTo(self.tabBar.mas_top).offset(-20);
//        make.size.mas_equalTo(CGSizeMake(55, 55));
//    }];
//    [_fixedButton addTarget:self action:@selector(post) forControlEvents:UIControlEventTouchUpInside];
//}



#pragma mark


@end
