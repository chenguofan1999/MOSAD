//
//  SettingViewController.m
//  mid
//
//  Created by itlab on 2020/11/23.
//

#import "UserCenterViewController.h"
#import "InfoSettingViewController.h"
#import "MessageViewController.h"
#import "SystemSettingController.h"
#import "UserInfo.h"

@interface UserCenterViewController ()
@property (nonatomic, strong) InfoSettingViewController *ivc;
@property (nonatomic, strong) MessageViewController *mvc;
@property (nonatomic, strong) SystemSettingController *svc;
@end

@implementation UserCenterViewController

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
    
    NSArray *segmentedData = @[@"用户信息",@"通知",@"设置"];
    UISegmentedControl *segmentBar = [[UISegmentedControl alloc] initWithItems:segmentedData];
    [segmentBar addTarget:self action:@selector(choose:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentBar;
    
    _ivc = [InfoSettingViewController new];
    _mvc = [MessageViewController new];
    _svc = [SystemSettingController new];
    
    _ivc.view.frame=self.view.safeAreaLayoutGuide.layoutFrame;
    _mvc.view.frame=self.view.safeAreaLayoutGuide.layoutFrame;
    _svc.view.frame=self.view.safeAreaLayoutGuide.layoutFrame;
    
    [self.view addSubview:_svc.view];
    [self.view addSubview:_mvc.view];
    [self.view addSubview:_ivc.view];
    
    [segmentBar setSelectedSegmentIndex:0];
    
    // 刷新 button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
}

- (void)choose:(UISegmentedControl *)seg
{
    NSInteger Index = seg.selectedSegmentIndex;
    switch (Index) {
        case 0:
            [_ivc.view setHidden:NO];
            [_mvc.view setHidden:YES];
            [_svc.view setHidden:YES];
            break;
        case 1:
            [_ivc.view setHidden:YES];
            [_mvc.view setHidden:NO];
            [_svc.view setHidden:YES];
            break;
        case 2:
            [_ivc.view setHidden:YES];
            [_mvc.view setHidden:YES];
            [_svc.view setHidden:NO];
            break;
    }
}

# pragma mark 刷新
- (void)refresh
{
    [UserInfo updateUserInfo];
    [_ivc.tableView reloadData];
    [_mvc.tableView reloadData];
}

@end

