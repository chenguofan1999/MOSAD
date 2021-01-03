//
//  HomePageViewController.m
//  Final
//
//  Created by itlab on 12/28/20.
//

#import "HomePageViewController.h"
#import "SearchPageViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <SDWebImage/UIButton+WebCache.h>
#import <Masonry/Masonry.h>
#import "UserInfo.h"
@interface HomePageViewController () <tagBtnDelegate>

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavBar];
    [self.view addSubview:self.videoListTableViewController.tableView];
    [self addChildViewController:self.videoListTableViewController];
    self.tagView.tagDelegate = self;
    [self.videoListTableViewController loadData];
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tagView updateTagButtons];
}

- (VideoListTableViewController *)videoListTableViewController
{
    if(_videoListTableViewController == nil)
    {
        _videoListTableViewController = [[VideoListTableViewController alloc] initWithURL:@"http://159.75.1.231:5009/contents"];
        _videoListTableViewController.tableView.frame = self.view.frame;
        _videoListTableViewController.tableView.tableHeaderView = self.tagView;
    }
    return _videoListTableViewController;
}

- (TagView *)tagView
{
    if(_tagView == nil)
    {
        _tagView = [[TagView alloc]initWithTagArray:[UserInfo sharedUser].userTags];
        [[UserInfo sharedUser] addObserver: self
                                forKeyPath:@"userTags"
                                   options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                   context:@"userTags changed"];
    }
    return _tagView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"监听到%@的%@属性值改变了 - %@ - %@", object, keyPath, change, context);
    [self.tagView updateTagButtons];
}

- (void)setNavBar
{
    // 左侧 logo
    UIImageView *logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [logoImage setImage:[UIImage imageNamed:@"Yourtube3.png"]];
    [logoImage setClipsToBounds:YES];
    [logoImage.widthAnchor constraintEqualToConstant:120].active = YES;
    [logoImage setContentMode:UIViewContentModeScaleAspectFit];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:logoImage]];
    
    // 滑动隐藏
//    [self.navigationController setHidesBarsOnSwipe:YES];
   
    // 右侧按钮：搜索
    UIBarButtonItem *searchButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(testChangeTags)];
    [searchButtonItem setTintColor:[UIColor grayColor]];
    
    // 右侧按钮：用户
    UIButton *userButton = [[UIButton alloc]initWithFrame:CGRectZero];
    [userButton sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://159.75.1.231:5009%@",[UserInfo sharedUser].avatarURL]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"edvard-munch.png"]];
    userButton.imageView.contentMode = UIViewContentModeScaleAspectFill; // 头像截取而不缩放
    userButton.layer.masksToBounds = YES;                               // 头像将只显示在圆圈内
    userButton.clipsToBounds = YES;
    CGFloat d = 30;
    [userButton.widthAnchor constraintEqualToConstant:d].active = YES;
    [userButton.heightAnchor constraintEqualToConstant:d].active = YES;
    userButton.layer.cornerRadius = d/2;
    [userButton addTarget:self.tagView action:@selector(updateTagButtons) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *userButtonItem = [[UIBarButtonItem alloc]initWithCustomView:userButton];
    [self.navigationItem setRightBarButtonItems:@[userButtonItem, searchButtonItem]];

}

- (void)toSearchPage
{
    [self.navigationController pushViewController:[SearchPageViewController new] animated:YES];
}

- (void)testChangeTags
{
//    [[UserInfo sharedUser].userTags addObject:@"??"];
    [[[UserInfo sharedUser] mutableArrayValueForKey:@"userTags"] addObject:@"??"];
}

- (void)tagBtnClick:(nonnull UIButton *)btn {
    NSLog(@"clicked: %@",[btn.titleLabel text]);
}


@end
