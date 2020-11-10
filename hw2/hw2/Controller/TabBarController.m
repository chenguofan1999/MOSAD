//
//  TarBarController.m
//  hw2
//
//  Created by itlab on 2020/10/27.
//  Copyright © 2020 itlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TabBarController.h"
#import "FirstTestController.h"
#import "SecondTestController.h"
#import "ThirdTestController.h"
#import "FindViewController.h"
#import "InsertViewController.h"
#import "LogInViewController.h"
#import "AppDelegate.h"

@implementation TabBarController : UITabBarController


- (instancetype) init{
    if(self = [super init])
    {
        // Three subviews
        FindViewController *findVC = [[FindViewController alloc] init];
        UINavigationController *FindNav = [[UINavigationController alloc] initWithRootViewController:findVC];
        
        InsertViewController *insertVC =[[InsertViewController alloc] init];
        UINavigationController *InsertNav = [[UINavigationController alloc] initWithRootViewController:insertVC];
        
        LogInViewController *loginVC = [[LogInViewController alloc] init];
        UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        
        self.viewControllers = @[FindNav, InsertNav, loginNav];
    }
    return self;
}



@end
