//
//  ProfileViewController.m
//  mid
//
//  Created by itlab on 11/26/20.
//

#import "ProfilePageViewController.h"

@interface ProfilePageViewController ()

@end

@implementation ProfilePageViewController

- (void)loadView
{
    self.tabBarController.tabBar.hidden=YES;
    UIWindow *window = UIApplication.sharedApplication.windows[0];
    self.view = [[UIScrollView alloc]initWithFrame:window.safeAreaLayoutGuide.layoutFrame];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor darkGrayColor]];
    // Do any additional setup after loading the view.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
