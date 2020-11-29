//
//  DiscoverViewController.m
//  mid
//
//  Created by itlab on 2020/11/23.
//

#import "DiscoverViewController.h"
#import "PostViewController.h"

@interface DiscoverViewController ()
@property (nonatomic, strong) PostViewController *pvc;
//@property (nonatomic, strong) 
@end

@implementation DiscoverViewController

- (instancetype)init
{
    self = [super init];
    
    self.tabBarItem.title = @"广场";
    self.tabBarItem.image = [UIImage imageNamed:@"search@2x.png"];
    self.tabBarItem.selectedImage =[UIImage imageNamed:@"search-filled@2x.png"];

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor darkGrayColor]];
    
    // 设置导航栏不透明，一劳永逸解决排布问题
    self.navigationController.navigationBar.translucent = NO;

    _pvc = [[PostViewController alloc]init];
//    [_pvc.navigationController.view setNeedsLayout];
    _pvc.view.frame = self.view.safeAreaLayoutGuide.layoutFrame;
    
    [self.view addSubview:_pvc.view];
    
}



@end
