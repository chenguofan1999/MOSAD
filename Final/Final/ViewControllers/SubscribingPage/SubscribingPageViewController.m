//
//  SubscribingPageViewController.m
//  Final
//
//  Created by itlab on 12/28/20.
//

#import "SubscribingPageViewController.h"

@interface SubscribingPageViewController ()

@end

@implementation SubscribingPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBar];
}

- (void)setNavBar
{
    // 左侧 logo
    UIImageView *logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [logoImage setImage:[UIImage imageNamed:@"Yourtube3.png"]];
    [logoImage setClipsToBounds:YES];
    [logoImage.widthAnchor constraintEqualToConstant:120].active = YES;
    [logoImage setContentMode:UIViewContentModeScaleAspectFit];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:logoImage]];
    
    // 滑动隐藏
    [self.navigationController setHidesBarsOnSwipe:YES];
}


@end
