//
//  ProfileViewController.m
//  mid
//
//  Created by itlab on 11/26/20.
//

#import "ProfilePageViewController.h"
#import "PostViewController.h"
#import "InfoViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface ProfilePageViewController ()
@property (nonatomic, strong) InfoViewController *ivc;
@property (nonatomic, strong) PostViewController *pvc;
@property (nonatomic, strong) PostViewController *avc;
@end

@implementation ProfilePageViewController
- (instancetype)initWithUserID:(NSString *)userID
                      userName:(NSString *)userName
{
    self =[super init];
    _userID = userID;
    _userName = userName;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden=YES;
    
    NSArray *segmentedData = @[@"个人信息",@"已发布",@"相册"];
    UISegmentedControl *segmentBar = [[UISegmentedControl alloc] initWithItems:segmentedData];
    [segmentBar addTarget:self action:@selector(choose:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentBar;
    
    _ivc = [[InfoViewController alloc]initWithUserID:_userID];
    _pvc = [[PostViewController alloc]initWithType:@"Text" UserID:_userID UserName:_userName];
    _avc = [[PostViewController alloc]initWithType:@"Album" UserID:_userID UserName:_userName];
    
    _ivc.view.frame=self.view.safeAreaLayoutGuide.layoutFrame;
    _pvc.view.frame=self.view.safeAreaLayoutGuide.layoutFrame;
    _avc.view.frame=self.view.safeAreaLayoutGuide.layoutFrame;
    
    [self.view addSubview:_pvc.view];
    [self.view addSubview:_avc.view];
    [self.view addSubview:_ivc.view];
    
    [segmentBar setSelectedSegmentIndex:0];
    
    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    // 手动设置返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backTapped:)];
}

- (void)choose:(UISegmentedControl *)seg
{
    NSInteger Index = seg.selectedSegmentIndex;
    switch (Index) {
        case 0:
            [_ivc.view setHidden:NO];
            [_pvc.view setHidden:YES];
            [_avc.view setHidden:YES];
            break;
        case 1:
            [_ivc.view setHidden:YES];
            [_pvc.view setHidden:NO];
            [_avc.view setHidden:YES];
            break;
        case 2:
            [_ivc.view setHidden:YES];
            [_pvc.view setHidden:YES];
            [_avc.view setHidden:NO];
            break;
    }
}

- (void)backTapped:(UIBarButtonItem *)sender
{
    self.tabBarController.tabBar.hidden=NO;
    [self.navigationController popViewControllerAnimated:NO];
}




#pragma mark - Navigation



@end
