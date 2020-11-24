//
//  SettingViewController.m
//  mid
//
//  Created by itlab on 2020/11/23.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (instancetype)init
{
    self = [super init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tabBarItem.title = @"个人中心";
    self.tabBarItem.image = [UIImage imageNamed:@"user@2x.png"];
    self.tabBarItem.selectedImage =[UIImage imageNamed:@"user-filled@2x.png"];

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


@end
