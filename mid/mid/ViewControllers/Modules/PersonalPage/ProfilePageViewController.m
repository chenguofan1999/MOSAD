//
//  ProfileViewController.m
//  mid
//
//  Created by itlab on 11/26/20.
//

#import "ProfilePageViewController.h"
#import "PostViewController.h"
#import "AlbumViewController.h"
#import "InfoViewController.h"

@interface ProfilePageViewController ()
@property (nonatomic, strong) InfoViewController *ivc;
@property (nonatomic, strong) PostViewController *pvc;
@property (nonatomic, strong) AlbumViewController *avc;
@end

@implementation ProfilePageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden=YES;
    
    NSArray *segmentedData = @[@"个人信息",@"已发布",@"相册"];
    UISegmentedControl *segmentBar = [[UISegmentedControl alloc] initWithItems:segmentedData];
    [segmentBar addTarget:self action:@selector(choose:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentBar;
    
    _ivc = [[InfoViewController alloc]init];
    _pvc = [[PostViewController alloc]init];
    _avc = [[AlbumViewController alloc]init];
    
    _ivc.view.frame=self.view.safeAreaLayoutGuide.layoutFrame;
    _pvc.view.frame=self.view.safeAreaLayoutGuide.layoutFrame;
    _avc.view.frame=self.view.safeAreaLayoutGuide.layoutFrame;
    
    [self.view addSubview:_pvc.view];
    [self.view addSubview:_avc.view];
    [self.view addSubview:_ivc.view];
    
    [segmentBar setSelectedSegmentIndex:0];
    
    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //test
//    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:@"add" style:UIBarButtonItemStylePlain target:self action:@selector(testAddPic)]];
    
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

- (void)testAddPic
{
    [_avc addImage:[UIImage imageNamed:@"testPic.jpg"]];
}


#pragma mark - Navigation



@end
