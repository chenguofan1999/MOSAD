//
//  SubscribingPageViewController.m
//  Final
//
//  Created by itlab on 12/28/20.
//

#import "SubscribingPageViewController.h"

@interface SubscribingPageViewController ()
@property (nonatomic,strong) UIScrollView *subscribingUsersView;
@property (nonatomic,strong) NSMutableArray *followingUsers; //array of UserItem
@end

@implementation SubscribingPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    // This clears the title of back button
    self.navigationController.navigationBar.topItem.title = @"";
}



@end
