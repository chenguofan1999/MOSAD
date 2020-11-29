//
//  DiscoverViewController.m
//  mid
//
//  Created by itlab on 2020/11/23.
//

#import "DiscoverViewController.h"

@interface DiscoverViewController ()
@property (nonatomic, strong) UITableView *postView;
//@property (nonatomic, strong) 
@end

@implementation DiscoverViewController

- (instancetype)init
{
    self = [super init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tabBarItem.title = @"广场";
    self.tabBarItem.image = [UIImage imageNamed:@"search@2x.png"];
    self.tabBarItem.selectedImage =[UIImage imageNamed:@"search-filled@2x.png"];

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
}



@end
