//
//  NavedViewController.m
//  Final
//
//  Created by itlab on 1/4/21.
//

#import "NavedViewController.h"
#import "SearchPageViewController.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <FTPopOverMenu/FTPopOverMenu.h>
#import <MaterialDialogs.h>
#import "SceneDelegate.h"
#import "UserInfo.h"
#import "PostContentViewController.h"
@interface NavedViewController ()
@property (nonatomic, strong) UIButton *userButton;
@end

@implementation NavedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [_userButton sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://159.75.1.231:5009%@",[UserInfo sharedUser].avatarURL]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"edvard-munch.png"]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [_userButton sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://159.75.1.231:5009%@",[UserInfo sharedUser].avatarURL]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"edvard-munch.png"]];
}

- (void)setNavBar
{
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    
    // 左侧 logo
    UIImageView *logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [logoImage setImage:[UIImage imageNamed:@"Yourtube3.png"]];
    [logoImage setClipsToBounds:YES];
    [logoImage.widthAnchor constraintEqualToConstant:120].active = YES;
    [logoImage setContentMode:UIViewContentModeScaleAspectFit];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:logoImage]];
    
    // 阴影
    [self.navigationController.navigationBar.layer setShadowOffset:CGSizeMake(0.5, 0.5)];
    [self.navigationController.navigationBar.layer setShadowColor:[UIColor darkGrayColor].CGColor];
    [self.navigationController.navigationBar.layer setShadowRadius:1.5];
    [self.navigationController.navigationBar.layer setShadowOpacity:0.7];
    
    // 滑动隐藏
//    [self.navigationController setHidesBarsOnSwipe:YES];
   
    // 右侧按钮：搜索
    UIBarButtonItem *searchButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(toSearchPage)];
    [searchButtonItem setTintColor:[UIColor grayColor]];
    [searchButtonItem setImageInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    
    // 右侧按钮：用户
    _userButton = [[UIButton alloc]initWithFrame:CGRectZero];
    [_userButton sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://159.75.1.231:5009%@",[UserInfo sharedUser].avatarURL]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"edvard-munch.png"]];
    _userButton.imageView.contentMode = UIViewContentModeScaleAspectFill; // 头像截取而不缩放
    _userButton.layer.masksToBounds = YES;                               // 头像将只显示在圆圈内
    _userButton.clipsToBounds = YES;
    CGFloat d = 30;
    [_userButton.widthAnchor constraintEqualToConstant:d].active = YES;
    [_userButton.heightAnchor constraintEqualToConstant:d].active = YES;
    _userButton.layer.cornerRadius = d/2;
    [_userButton addTarget:self action:@selector(avatarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *userButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_userButton];
    
    // 右侧按钮：发送
    UIBarButtonItem *postButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(toPostPage)];
    [postButtonItem setTintColor:[UIColor grayColor]];
    
    [self.navigationItem setRightBarButtonItems:@[userButtonItem, postButtonItem, searchButtonItem]];
    
}

- (void)toSearchPage
{
    [self.navigationController pushViewController:[SearchPageViewController new] animated:NO];
}

- (void)avatarButtonClicked:(UIButton *)sender
{
    FTPopOverMenuConfiguration *config = [FTPopOverMenuConfiguration defaultConfiguration];
    config.textColor = [UIColor whiteColor];
    config.ignoreImageOriginalColor = YES;
    
    [FTPopOverMenu showForSender:sender
                   withMenuArray:@[@"Log out"]
                      imageArray:@[@"exit"]
                   configuration:config
                       doneBlock:^(NSInteger selectedIndex) {
        switch (selectedIndex) {
            case 0:
                [SceneDelegate jumpToLoginPage];
                break;
        }
    } dismissBlock:nil];
}

- (void)toPostPage
{
    [self.navigationController pushViewController:[PostContentViewController new] animated:YES];
    
}


@end
