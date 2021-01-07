//
//  SubscribingPageViewController.m
//  Final
//
//  Created by itlab on 12/28/20.
//

#import <Masonry/Masonry.h>
#import <MDCButton+MaterialTheming.h>
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/SDWebImage.h>
#import "UserCollectionViewCell.h"
#import "MiniUserItem.h"
#import "SubscribingPageViewController.h"
#import "VideoListTableViewController.h"
#import "UserListTableViewController.h"
#import "ExplorePageViewController.h"
#import "AppConfig.h"
#import "UserInfo.h"

@interface SubscribingPageViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, VideoListSlideDelegate>
@property (nonatomic, strong) UICollectionView *subscribingUsersView;
@property (nonatomic, strong) MDCButton *allSubscribingButton;
@property (nonatomic) bool collectionViewBuild;
@property (nonatomic) bool shoWingUserView;

@property (nonatomic, strong) UILabel *videoListTitleLabel;
@property (nonatomic, strong) VideoListTableViewController *videoListController;
@property (nonatomic, strong) UIButton *modeButton;
@property (nonatomic, strong) UILabel *modeLabel;
@property (nonatomic) VideoSortingMode sortingMode;

// data
@property (nonatomic,strong) NSMutableArray *followingUserItems; //array of UserItem
@end

@implementation SubscribingPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self.view addSubview:self.allSubscribingButton];
    [self addChildViewController:self.videoListController];
    [self.view addSubview:self.videoListController.tableView];
    
    [self.allSubscribingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.view);
        make.left.mas_equalTo(self.view.mas_right).offset(-68);
        make.height.mas_equalTo(120);
    }];
    
    
    [self.videoListController.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.allSubscribingButton.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    _collectionViewBuild = NO;
    _shoWingUserView = YES;
    [self addObserver:self forKeyPath:@"sortingMode" options:NSKeyValueObservingOptionNew context:@"mode"];
    self.sortingMode = VideoSortingModeTimeDesc;
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    // This clears the title of back button
    self.navigationController.navigationBar.topItem.title = @"";
    [self loadData];
    [self.videoListController loadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.videoListController setServiceURL:@"http://159.75.1.231:5009/contents?follow=true"];
    [self.videoListTitleLabel setText:@"Subscribing"];
}

- (UICollectionView *)subscribingUsersView
{
    if(_subscribingUsersView == nil)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(86, 120);
        _subscribingUsersView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        
        [_subscribingUsersView registerClass:[UserCollectionViewCell class] forCellWithReuseIdentifier:@"UserCollectionViewCell"];
        [_subscribingUsersView setBounces:NO];
        [_subscribingUsersView setBackgroundColor:[UIColor whiteColor]];
        _subscribingUsersView.showsHorizontalScrollIndicator = NO;
        _subscribingUsersView.delegate = self;
        _subscribingUsersView.dataSource = self;
    }
    return _subscribingUsersView;
}

- (MDCButton *)allSubscribingButton
{
    if(_allSubscribingButton == nil)
    {
        _allSubscribingButton = [[MDCButton alloc]init];
        [_allSubscribingButton applyTextThemeWithScheme:[MDCContainerScheme new]];
        [_allSubscribingButton setTitleFont:[UIFont boldSystemFontOfSize:15] forState:UIControlStateNormal];
        [_allSubscribingButton setBackgroundColor:[UIColor whiteColor]];
        [_allSubscribingButton.layer setCornerRadius:0];
        [_allSubscribingButton setTitle:@"ALL" forState:UIControlStateNormal];
        [_allSubscribingButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_allSubscribingButton addTarget:self action:@selector(allUserButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allSubscribingButton;
}

- (VideoListTableViewController *)videoListController
{
    if(_videoListController == nil)
    {
        _videoListController = [[VideoListTableViewController alloc]initWithURL:@"http://159.75.1.231:5009/contents?follow=true"];
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
        
        
        [headerView addSubview:self.modeButton];
        [headerView addSubview:self.modeLabel];
        [headerView addSubview:self.videoListTitleLabel];
        
        [self.modeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerView);
            make.right.equalTo(headerView).offset(-10);
        }];
        
        [self.modeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerView);
            make.right.mas_equalTo(self.modeLabel.mas_left).offset(-5);
            make.size.mas_equalTo(CGSizeMake(22, 22));
        }];
        
        [self.videoListTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerView);
            make.left.equalTo(headerView).offset(15);
        }];
        
        _videoListController.customDelegate = self;
        [_videoListController.tableView setBounces:NO];
        [_videoListController.tableView setTableHeaderView:headerView];
    }
    return _videoListController;
}

- (UILabel *)videoListTitleLabel
{
    if(_videoListTitleLabel == nil)
    {
        _videoListTitleLabel = [[UILabel alloc]init];
        [_videoListTitleLabel setText:@"Subscribing"];
        [_videoListTitleLabel setFont:[UIFont boldSystemFontOfSize:24]];
    }
    return _videoListTitleLabel;
}

#pragma mark All button
- (void)allUserButtonClicked
{
    UserListTableViewController *userList =[[UserListTableViewController alloc]initWithUsername:[UserInfo sharedUser].username type:UserListTableTypeFollowing];
    [userList.navigationItem setTitle:@"Subscribing List"];
    [self.navigationController pushViewController:userList animated:YES];
}


#pragma mark 排序
- (UIButton *)modeButton
{
    if(_modeButton == nil)
    {
        _modeButton = [[UIButton alloc]init];
        [_modeButton setTintColor:[UIColor grayColor]];
        [_modeButton addTarget:self action:@selector(changeSortingMode) forControlEvents:UIControlEventTouchUpInside];
    }
    return _modeButton;
}

- (UILabel *)modeLabel
{
    if(_modeLabel == nil)
    {
        _modeLabel = [[UILabel alloc]init];
        [_modeLabel setTextColor:[UIColor grayColor]];
        [_modeLabel setFont:[UIFont systemFontOfSize:16]];
        [_modeLabel setUserInteractionEnabled:YES];
        [_modeLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeSortingMode)]];
    }
    return _modeLabel;
}

- (void)changeSortingMode
{
    self.sortingMode = (self.sortingMode + 1) % 4;
}

#pragma mark load data
- (void)loadData
{
    NSString *URL = [NSString stringWithFormat:@"http://159.75.1.231:5009/users/%@/following", [UserInfo sharedUser].username];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:URL parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *response = (NSDictionary *)responseObject;
        NSLog(@"response: %@",response);
        if([response[@"status"] isEqualToString:@"success"])
        {
            NSArray *data = response[@"data"];
            NSLog(@"user data:%@",data);
            self.followingUserItems = [NSMutableArray new];
            for(int i = 0; i < [data count]; i++)
            {
                MiniUserItem *newItem = [[MiniUserItem alloc]initWithDict:data[i]];
                [self.followingUserItems addObject:newItem];
            }
            
            if(self.collectionViewBuild == NO)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"item num : %ld",[self.followingUserItems count]);
                    [self.view addSubview:self.subscribingUsersView];
                    [self.subscribingUsersView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.top.equalTo(self.view);
                        make.bottom.equalTo(self.allSubscribingButton);
                        make.right.mas_equalTo(self.allSubscribingButton.mas_left);
                    }];
                });
                self.collectionViewBuild = YES;
            }
            else [self.subscribingUsersView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed to get following");
    }];
}


#pragma mark collection delegate
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    MiniUserItem *itemForThisCell = self.followingUserItems[indexPath.item];
    UserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UserCollectionViewCell" forIndexPath:indexPath];
    
    
    [cell.avatarView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://159.75.1.231:5009%@",itemForThisCell.avatarURL]]
                       placeholderImage:[UIImage imageNamed:@"edvard-munch.png"]];
    [cell.usernameLabel setText:itemForThisCell.userName];
    return cell;

}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.followingUserItems count];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [[collectionView cellForItemAtIndexPath:indexPath] setAlpha:1];
    for(UserCollectionViewCell *cell in [collectionView visibleCells])
    {
        if([collectionView indexPathForCell:cell] != indexPath)
            [cell setAlpha:0.3];
    }
    
    MiniUserItem *itemForThisCell = self.followingUserItems[indexPath.item];
    NSString *URL = [NSString stringWithFormat:@"http://159.75.1.231:5009/contents?user=%@",itemForThisCell.userName];
    self.videoListController.serviceURL = URL;
    [self.videoListTitleLabel setText:[NSString stringWithFormat:@"%@'s",itemForThisCell.userName]];
    
    [self.videoListController loadData];
}

#pragma mark Drag delegate

- (void)hideUserView
{
    if(_shoWingUserView == NO) return;
    NSLog(@"hideUserView");
    [UIView animateWithDuration:0.5 animations:^{
        [self.allSubscribingButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self.view);
            make.left.mas_equalTo(self.view.mas_right).offset(-68);
            make.height.mas_equalTo(0);
        }];
        [self.view layoutIfNeeded];
    }];
    _shoWingUserView = NO;
}

- (void)showUserView
{
    if(_shoWingUserView == YES) return;
    NSLog(@"showUserView");
    [UIView animateWithDuration:0.5 animations:^{
        [self.allSubscribingButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self.view);
            make.left.mas_equalTo(self.view.mas_right).offset(-68);
            make.height.mas_equalTo(120);
        }];
        [self.view layoutIfNeeded];
    }];
    _shoWingUserView = YES;
}

#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"监听到%@的%@属性值改变了 - %@ - %@", object, keyPath, change, context);
    if([(__bridge NSString *)context isEqualToString:@"mode"])
    {
        switch (self.sortingMode) {
            case VideoSortingModeTimeDesc:
                [self.modeButton setImage:[[UIImage imageNamed:@"descending.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
                [_modeLabel setText:@"By Time"];
                [self.videoListController setServiceURL:@"http://159.75.1.231:5009/contents?follow=true"];
                break;
            case VideoSortingModeTimeAsc:
                [self.modeButton setImage:[[UIImage imageNamed:@"ascending.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
                [_modeLabel setText:@"By Time"];
                [self.videoListController setServiceURL:@"http://159.75.1.231:5009/contents?follow=true&order=asc"];
                break;
            case VideoSortingModeViewNumAsc:
                [self.modeButton setImage:[[UIImage imageNamed:@"ascending.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
                [_modeLabel setText:@"By View"];
                [self.videoListController setServiceURL:@"http://159.75.1.231:5009/contents?follow=true&order=asc&orderBy=viewNum"];
                break;
            case VideoSortingModeViewNumDesc:
                [self.modeButton setImage:[[UIImage imageNamed:@"descending.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
                [_modeLabel setText:@"By View"];
                [self.videoListController setServiceURL:@"http://159.75.1.231:5009/contents?follow=true&orderBy=viewNum"];
                break;
            default:
                break;
        }
        [self.videoListController loadData];
    }
}

#pragma mark slide delegate
-(void)slideUp
{
    [self showUserView];
}

-(void)slideDown
{
    [self hideUserView];
}

@end
