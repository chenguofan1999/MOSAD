//
//  UserPageViewController.m
//  Final
//
//  Created by itlab on 1/7/21.
//

#import <MXSegmentedPager/MXSegmentedPager.h>
#import <MXParallaxHeader/MXParallaxHeader.h>
#import "UserPageViewController.h"
#import "OrderedVideoListTable.h"
#import "InfoPageViewController.h"
#import "AppConfig.h"
#import "UserInfo.h"
@interface UserPageViewController ()<MXSegmentedPagerDelegate, MXSegmentedPagerDataSource>
@property (nonatomic, strong) MXSegmentedPager  *segmentedPager;
@property (nonatomic, strong) InfoPageViewController *infoPage;
@property (nonatomic, strong) OrderedVideoListTable *videoPage;
@property (nonatomic, strong) OrderedVideoListTable *likesPage;
@property (nonatomic, strong) OrderedVideoListTable *historyPage;
@end

@implementation UserPageViewController
- (instancetype)initWithUsername:(NSString *)username
{
    self = [super init];
    self.username = username;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self.view addSubview:self.segmentedPager];
    
    
    [self addChildViewController:self.infoPage];
    [self addChildViewController:self.videoPage];
    [self addChildViewController:self.likesPage];
    [self addChildViewController:self.historyPage];
    
    
    // 阴影
    [self.navigationController.navigationBar.layer setShadowOffset:CGSizeMake(0.5, 0.5)];
    [self.navigationController.navigationBar.layer setShadowColor:[UIColor darkGrayColor].CGColor];
    [self.navigationController.navigationBar.layer setShadowRadius:1.5];
    [self.navigationController.navigationBar.layer setShadowOpacity:0.7];
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationItem setTitle:self.username];
}


- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    self.segmentedPager.parallaxHeader.minimumHeight = self.view.safeAreaInsets.top;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.segmentedPager.frame = self.view.bounds;
}

- (MXSegmentedPager *)segmentedPager
{
    if (!_segmentedPager)
    {
        _segmentedPager = [[MXSegmentedPager alloc] initWithFrame:self.view.bounds];
        _segmentedPager.delegate    = self;
        _segmentedPager.dataSource  = self;
        _segmentedPager.segmentedControl.textColor = [UIColor grayColor];
//        [_segmentedPager.segmentedControl setBackgroundColor:[AppConfig getMainColor]];
        _segmentedPager.segmentedControl.selectedTextColor = [AppConfig getMainColor];
        [_segmentedPager.segmentedControl.indicator setLineHeight:2];
        _segmentedPager.segmentedControl.indicator.lineView.backgroundColor = [AppConfig getMainColor];
//        _segmentedPager.pager.gutterWidth = 40;
        
    }
    return _segmentedPager;
}

- (InfoPageViewController *)infoPage
{
    if(_infoPage == nil)
    {
        _infoPage = [[InfoPageViewController alloc]initWithUsername:self.username];
    }
    return _infoPage;
}

- (OrderedVideoListTable *)videoPage
{
    if(_videoPage == nil)
    {
        _videoPage = [[OrderedVideoListTable alloc]initWithUserName:self.username];
    }
    return _videoPage;
}

- (OrderedVideoListTable *)likesPage
{
    if(_likesPage == nil)
    {
        _likesPage = [[OrderedVideoListTable alloc]initWithTypeLikeByUsername:self.username];
    }
    return _likesPage;
}

- (OrderedVideoListTable *)historyPage
{
    if(_historyPage == nil)
    {
        _historyPage = [[OrderedVideoListTable alloc]initWithTypeHistory];
    }
    return _historyPage;
}


#pragma mark delegate
- (NSInteger)numberOfPagesInSegmentedPager:(nonnull MXSegmentedPager *)segmentedPager {
    if(self.username == [UserInfo sharedUser].username) return 4;
    return 3;
}

- (nonnull __kindof UIView *)segmentedPager:(nonnull MXSegmentedPager *)segmentedPager viewForPageAtIndex:(NSInteger)index {
    NSArray *pages = @[self.infoPage.view, self.videoPage.view, self.likesPage.view, self.historyPage.view];
    return pages[index];
}

- (NSString *)segmentedPager:(MXSegmentedPager *)segmentedPager titleForSectionAtIndex:(NSInteger)index {
    NSArray *names = @[@"Info", @"Videos", @"Likes", @"History"];
    return names[index];
}

- (CGFloat)heightForSegmentedControlInSegmentedPager:(MXSegmentedPager *)segmentedPager {
    return 45.f;
}





@end
