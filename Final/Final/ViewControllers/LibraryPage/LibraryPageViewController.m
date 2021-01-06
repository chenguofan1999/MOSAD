//
//  LibraryPageViewController.m
//  Final
//
//  Created by itlab on 12/28/20.
//  Library page is supposed to contain:
//  1. my videos
//  2. my history
//  3. my likes


#import "LibraryPageViewController.h"

@interface LibraryPageViewController ()

@end

@implementation LibraryPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    // This clears the title of back button
    self.navigationController.navigationBar.topItem.title = @"";
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
