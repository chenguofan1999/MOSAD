//
//  ExplorePageViewController.m
//  Final
//
//  Created by itlab on 12/28/20.
//

#import <Masonry/Masonry.h>
#import <FTPopOverMenu/FTPopOverMenu.h>
#import "ExplorePageViewController.h"
#import "VideoListTableViewController.h"


@interface ExplorePageViewController ()
@property (nonatomic, strong) VideoListTableViewController *videoListTableViewController;
@property (nonatomic, strong) UIButton *modeButton;
@property (nonatomic, strong) UILabel *modeLabel;
@property (nonatomic) VideoSortingMode sortingMode;
@end

@implementation ExplorePageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.videoListTableViewController.tableView];
    [self addChildViewController:self.videoListTableViewController];
    self.sortingMode = VideoSortingModeTimeDesc;
    [self.videoListTableViewController loadData];
    
    [self addObserver:self forKeyPath:@"sortingMode" options:NSKeyValueObservingOptionNew context:@"mode"];
    
    self.sortingMode = VideoSortingModeTimeDesc;
}


- (void)viewWillAppear:(BOOL)animated
{
    // This clears the title of back button
    self.navigationController.navigationBar.topItem.title = @"";
}

- (VideoListTableViewController *)videoListTableViewController
{
    if(_videoListTableViewController == nil)
    {
        _videoListTableViewController = [[VideoListTableViewController alloc] initWithURL:@"http://159.75.1.231:5009/contents"];
        _videoListTableViewController.tableView.frame = self.view.frame;
        
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
        
        [headerView addSubview:self.modeButton];
        [headerView addSubview:self.modeLabel];
        
        
        [self.modeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerView);
            make.left.equalTo(headerView).offset(15);
        }];
        
        [self.modeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerView);
            make.right.equalTo(headerView).offset(-18);
            make.size.mas_equalTo(CGSizeMake(32, 32));
        }];
        
        [_videoListTableViewController.tableView setTableHeaderView:headerView];
    }
    return _videoListTableViewController;
}

- (UIButton *)modeButton
{
    if(_modeButton == nil)
    {
        _modeButton = [[UIButton alloc]init];
        [_modeButton setTintColor:[UIColor darkGrayColor]];
        [_modeButton addTarget:self action:@selector(changeSortingMode) forControlEvents:UIControlEventTouchUpInside];
    }
    return _modeButton;
}

- (UILabel *)modeLabel
{
    if(_modeLabel == nil)
    {
        _modeLabel = [[UILabel alloc]init];
        [_modeLabel setFont:[UIFont boldSystemFontOfSize:24]];
    }
    return _modeLabel;
}

- (void)changeSortingMode
{
    self.sortingMode = (self.sortingMode + 1) % 4;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"监听到%@的%@属性值改变了 - %@ - %@", object, keyPath, change, context);
    switch (self.sortingMode) {
        case VideoSortingModeTimeDesc:
            [self.modeButton setImage:[[UIImage imageNamed:@"descending.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            [_modeLabel setText:@"Most Recent"];
            [self.videoListTableViewController setServiceURL:@"http://159.75.1.231:5009/contents"];
            break;
        case VideoSortingModeTimeAsc:
            [self.modeButton setImage:[[UIImage imageNamed:@"ascending.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            [_modeLabel setText:@"Most Ancient"];
            [self.videoListTableViewController setServiceURL:@"http://159.75.1.231:5009/contents?order=asc"];
            break;
        case VideoSortingModeViewNumAsc:
            [self.modeButton setImage:[[UIImage imageNamed:@"ascending.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            [_modeLabel setText:@"Nobody Cares"];
            [self.videoListTableViewController setServiceURL:@"http://159.75.1.231:5009/contents?order=asc&orderBy=viewNum"];
            break;
        case VideoSortingModeViewNumDesc:
            [self.modeButton setImage:[[UIImage imageNamed:@"descending.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            [_modeLabel setText:@"Most Watched"];
            [self.videoListTableViewController setServiceURL:@"http://159.75.1.231:5009/contents?orderBy=viewNum"];
            break;
        default:
            break;
    }
    [self.videoListTableViewController loadData];
}

@end
