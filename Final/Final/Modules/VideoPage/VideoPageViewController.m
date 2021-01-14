//
//  VideoPageViewController.m
//  Final
//
//  Created by itlab on 12/31/20.
//

#import "VideoPageViewController.h"
#import <MaterialComponents/MaterialTabs+TabBarView.h>
#import <MaterialComponents/MDCFilledTextField.h>
#import <MaterialTextControls+OutlinedTextFields.h>
#import <Masonry/Masonry.h>
#import <SJVideoPlayer/SJVideoPlayer.h>
#import <MJRefresh/MJRefresh.h>
#import <MaterialCards+Theming.h>
#import <MaterialDialogs.h>
#import <SDWebImage.h>
#import <AFNetworking/AFNetworking.h>
#import <MaterialComponents/MDCButton+MaterialTheming.h>
#import <FTPopOverMenu/FTPopOverMenu.h>
#import "AppConfig.h"
#import "TimeTool.h"
#import "UserInfo.h"
#import "CommentItem.h"
#import "TagView.h"
#import "CommentTableViewController.h"
#import "VideoListTableViewController.h"
#import "UserPageViewController.h"

@interface VideoPageViewController () <tagBtnDelegate>
@property (nonatomic, strong) SJVideoPlayer *player;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) MDCCard *videoInfoCard;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *videoInfoLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIImageView *expandIndicator;
@property (nonatomic, strong) MASConstraint *likeButtonTop;
@property (nonatomic, strong) MDCButton *likeButton;
@property (nonatomic) bool expanded;

@property (nonatomic, strong) MDCCard *userCard;
@property (nonatomic, strong) UIImageView *userAvatarView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *userFollowerLabel;
@property (nonatomic, strong) MDCButton *followButton;
@property (nonatomic) NSNumber *isFollowing;

@property (nonatomic, strong) MDCCard *commentCard;
@property (nonatomic, strong) UILabel *commentTitleLabel;
@property (nonatomic, strong) UILabel *commentNumLabel;
@property (nonatomic, strong) UIImageView *commenterAvatarView;
@property (nonatomic, strong) UILabel *topCommentLabel;
@property (nonatomic, strong) MDCBaseTextField *commentField;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic) CommentItem *topCommentItem;

@property (nonatomic, strong) TagView *videoTagView;

@property (nonatomic) UIButton *moreActionButton;

@end

@implementation VideoPageViewController
- (instancetype)initWithContentItem:(DetailedContentItem *)contentItem
{
    self = [super init];
    self.contentItem = contentItem;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.player.view];
    [self.view addSubview:self.scrollView];
    
    [self.player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(self.player.view.mas_width).multipliedBy(9.0/16);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.player.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    
    /* VideoInfoCard */
    [self.videoInfoCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
    [self.expandIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.videoInfoCard).offset(13);
        make.right.equalTo(self.videoInfoCard).offset(-10);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.videoInfoCard).offset(10);
        make.left.equalTo(self.videoInfoCard).offset(15);
        make.right.lessThanOrEqualTo(self.videoInfoCard).offset(-40);
    }];
    
 
    [self.videoInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(5);
        make.left.equalTo(self.videoInfoCard).offset(15);
        make.right.equalTo(self.videoInfoCard).offset(-70);
        
    }];
    
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.videoInfoLabel.mas_bottom).offset(8);
        make.left.equalTo(self.videoInfoCard).offset(15);
        make.right.equalTo(self.videoInfoCard).offset(-70);
    }];
    
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.videoInfoLabel.mas_bottom).offset(15);
        make.left.equalTo(self.videoInfoCard).offset(30);
        make.right.equalTo(self.videoInfoCard).offset(-30);
        make.bottom.equalTo(self.videoInfoCard).offset(-10);
        make.height.mas_equalTo(35);
    }];
    
    /* UserCard */
    [self.userCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.videoInfoCard.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    [self.userAvatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userCard);
        make.left.equalTo(self.userCard).offset(15);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.userAvatarView.mas_right).offset(8);
        make.top.equalTo(self.userCard).offset(15);
    }];
    
    [self.userFollowerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.userAvatarView.mas_right).offset(8);
        make.top.mas_equalTo(self.usernameLabel.mas_bottom).offset(3);
        make.bottom.equalTo(self.userCard).offset(-15);
    }];
    
    [self.followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userCard);
        make.right.equalTo(self.userCard).offset(-10);
    }];
    
    
    /* CommentCard */
    [self.commentCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userCard.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    [self.commentTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentCard).offset(10);
        make.left.equalTo(self.commentCard).offset(15);
    }];
    
    [self.commentNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentTitleLabel);
        make.left.mas_equalTo(self.commentTitleLabel.mas_right).offset(5);
    }];
    
    [self.commenterAvatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.commentTitleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.commentCard).offset(15);
        make.bottom.equalTo(self.commentCard).offset(-10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.topCommentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.commenterAvatarView);
        make.left.mas_equalTo(self.commenterAvatarView.mas_right).offset(10);
    }];
    
    [self.commentField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.commenterAvatarView);
        make.left.mas_equalTo(self.commenterAvatarView.mas_right).offset(10);
        make.right.mas_equalTo(self.sendButton.mas_left).offset(5);
        make.height.mas_equalTo(35);
    }];
    
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.commenterAvatarView).offset(2);
        make.right.equalTo(self.commentCard).offset(-30);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    /* tagView */
    [self.videoTagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.commentCard.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    [self setNavBar];
}

- (void)viewWillAppear:(BOOL)animated
{
//    [self.player play];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
               selector:@selector(requestTopComment)
                   name:@"loadComments"
                 object:nil];
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    [self.player stop];
//}
#pragma mark 导航栏样式
- (void)setNavBar
{
    UIImageView *titleLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Yourtube3.png"]];
    [titleLogo setContentMode:UIViewContentModeScaleAspectFit];
    [titleLogo setClipsToBounds:YES];
    [titleLogo.widthAnchor constraintEqualToConstant:120].active = YES;
    [self.navigationItem setTitleView:titleLogo];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:self.moreActionButton]];
    
    // This clears the title of back button
    self.navigationController.navigationBar.topItem.title = @"";
}

#pragma mark 视频播放器
- (SJVideoPlayer *)player
{
    if(_player == nil)
    {
        _player = [SJVideoPlayer player];
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://159.75.1.231:5009%@",self.contentItem.videoURL]];
        _player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:URL];
//        [_player setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        
        // 以下两行使自动旋转被禁用
//        _player.autoManageViewToFitOnScreenOrRotation = NO;
//        _player.useFitOnScreenAndDisableRotation = YES;
        
//        _player.defaultEdgeControlLayer.hiddenBottomProgressIndicator = YES;
        SJVideoPlayer.update(^(SJVideoPlayerSettings * _Nonnull commonSettings) {
//            commonSettings.placeholder = [UIImage imageNamed:@"placeholder"];
            commonSettings.progress_traceColor = [AppConfig getMainColor];
            commonSettings.progress_bufferColor = [UIColor whiteColor];
        });
    }
    return _player;
}

#pragma mark 视频下方的页面
- (UIScrollView *)scrollView
{
    if(_scrollView == nil)
    {
        _scrollView = [[UIScrollView alloc]init];
        [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 600)];
        [_scrollView setBackgroundColor:[UIColor whiteColor]];
        [_scrollView addSubview:self.videoInfoCard];
        [_scrollView addSubview:self.userCard];
        [_scrollView addSubview:self.commentCard];
        [_scrollView addSubview:self.videoTagView];
        [_scrollView setBounces:NO];
    }
    return _scrollView;
}

#pragma mark info-card

- (MDCCard *)videoInfoCard
{
    if(_videoInfoCard == nil)
    {
        _videoInfoCard = [[MDCCard alloc]init];
        [_videoInfoCard applyThemeWithScheme:[[MDCContainerScheme alloc] init]];
        [_videoInfoCard setBorderWidth:0.3 forState:UIControlStateNormal];
        [_videoInfoCard setBorderColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_videoInfoCard setCornerRadius:0];
//        [_videoCard setBackgroundColor:[UIColor grayColor]];
        [_videoInfoCard addTarget:self action:@selector(infoCardClicked) forControlEvents:UIControlEventTouchUpInside];
        [_videoInfoCard addSubview:self.titleLabel];
        [_videoInfoCard addSubview:self.videoInfoLabel];
        [_videoInfoCard addSubview:self.expandIndicator];
        [_videoInfoCard addSubview:self.descriptionLabel];
        [_videoInfoCard addSubview:self.likeButton];
        [self.descriptionLabel setHidden:YES];
        self.expanded = NO;
    }
    return _videoInfoCard;
}

- (UILabel *)titleLabel
{
    if(_titleLabel == nil)
    {
        _titleLabel = [[UILabel alloc]init];
//        [_titleLabel setBackgroundColor:[UIColor redColor]];
        [_titleLabel setNumberOfLines:2];
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:21]];
        [_titleLabel setText:self.contentItem.videoTitle];
    }
    return _titleLabel;
}

- (UILabel *)videoInfoLabel
{
    if(_videoInfoLabel == nil)
    {
        _videoInfoLabel = [[UILabel alloc]init];
        [_videoInfoLabel setFont:[UIFont systemFontOfSize:16]];
        [_videoInfoLabel setTextColor:[UIColor darkGrayColor]];
        NSString *videoInfo = [NSString stringWithFormat:@"%d views · %d likes · %@", self.contentItem.viewNum, self.contentItem.likeNum, [TimeTool timeBeforeInfoWithString:self.contentItem.createTime]];
        [_videoInfoLabel setText:videoInfo];
        
        // KVO
        [self.contentItem addObserver:self
                           forKeyPath:@"liked"
                              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                              context:@"like status changed"];
        
    }
    return _videoInfoLabel;
}

- (UILabel *)descriptionLabel
{
    if(_descriptionLabel == nil)
    {
        _descriptionLabel = [[UILabel alloc]init];
        [_descriptionLabel setFont:[UIFont systemFontOfSize:15]];
        [_descriptionLabel setNumberOfLines:0];
        [_descriptionLabel setText:self.contentItem.videoDescription];
    }
    return _descriptionLabel;
}

- (UIImageView *)expandIndicator
{
    if(_expandIndicator == nil)
    {
        _expandIndicator = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"more.png"]];
        
        [_expandIndicator setContentMode:UIViewContentModeScaleAspectFit];
        [_expandIndicator setClipsToBounds:YES];
    }
    return _expandIndicator;
}

- (MDCButton *)likeButton
{
    if(_likeButton == nil)
    {
        _likeButton = [[MDCButton alloc]init];
        [_likeButton applyContainedThemeWithScheme:[[MDCContainerScheme alloc] init]];

        [_likeButton.imageView setTintColor:[UIColor whiteColor]];
        [_likeButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_likeButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];

        [_likeButton addTarget:self action:@selector(likeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        // 初始化
        self.contentItem.liked = self.contentItem.liked;
    }
    return _likeButton;
}

- (void)likeButtonClicked
{
    NSString *URL = [NSString stringWithFormat:@"http://159.75.1.231:5009/like/content/%d",self.contentItem.contentID];
    NSDictionary *header = @{
        @"Authorization":[UserInfo sharedUser].token
    };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    if(self.contentItem.liked)
    {
        [manager DELETE:URL parameters:nil headers:header success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            if([responseObject[@"status"] isEqualToString:@"success"])
            {
                self.contentItem.likeNum --;
                self.contentItem.liked = NO;
            }
            else if([responseObject[@"status"] isEqualToString:@"failed"])
            {
                NSLog(@"did not like");
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"cancel like failed");
        }];
    }
    else
    {
        [manager PUT:URL parameters:nil headers:header success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            if([responseObject[@"status"] isEqualToString:@"success"])
            {
                NSLog(@"like success");
                
                self.contentItem.likeNum ++;
                self.contentItem.liked = YES;
            }
            else if([responseObject[@"status"] isEqualToString:@"failed"])
            {
                NSLog(@"did like");
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"like failed");
        }];
    }
    
}

- (void)infoCardClicked
{
    if(self.expanded == NO)
    {
        // should expand
        self.expanded = YES;
        [self.expandIndicator setImage:[UIImage imageNamed:@"fold.png"]];
        
        [self.descriptionLabel setHidden:NO];
        [self.likeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.descriptionLabel.mas_bottom).offset(15);
            make.left.equalTo(self.videoInfoCard).offset(30);
            make.right.equalTo(self.videoInfoCard).offset(-30);
            make.bottom.equalTo(self.videoInfoCard).offset(-10);
            make.height.mas_equalTo(35);
        }];
        [self.videoInfoCard layoutIfNeeded];
        
        
    }
    else
    {
        self.expanded = NO;
        [self.expandIndicator setImage:[UIImage imageNamed:@"more.png"]];
        
        [self.descriptionLabel setHidden:YES];
        [self.likeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.videoInfoLabel.mas_bottom).offset(15);
            make.left.equalTo(self.videoInfoCard).offset(30);
            make.right.equalTo(self.videoInfoCard).offset(-30);
            make.bottom.equalTo(self.videoInfoCard).offset(-10);
            make.height.mas_equalTo(35);
        }];
        [self.videoInfoCard layoutIfNeeded];
    }
}
#pragma mark user-card


- (MDCCard *)userCard
{
    if(_userCard == nil)
    {
        _userCard = [MDCCard new];
        [_userCard applyThemeWithScheme:[[MDCContainerScheme alloc] init]];
        [_userCard setBorderWidth:0.3 forState:UIControlStateNormal];
        [_userCard setBorderColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_userCard setCornerRadius:0];
        [_userCard addSubview:self.userAvatarView];
        [_userCard addSubview:self.usernameLabel];
        [_userCard addSubview:self.userFollowerLabel];
        [_userCard addSubview:self.followButton];
    }
    return _userCard;
}

- (UIImageView *)userAvatarView
{
    if(_userAvatarView == nil)
    {
        _userAvatarView = [[UIImageView alloc]init];
        [_userAvatarView setContentMode:UIViewContentModeScaleAspectFill];
        [_userAvatarView setClipsToBounds:YES];
        [_userAvatarView.layer setCornerRadius:20];
        [_userAvatarView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://159.75.1.231:5009%@", self.contentItem.userItem.avatarURL]]];
        [_userAvatarView setUserInteractionEnabled:YES];
        [_userAvatarView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toUserPage)]];
    }
    return  _userAvatarView;
}

- (UILabel *)usernameLabel
{
    if(_usernameLabel == nil)
    {
        _usernameLabel = [UILabel new];
        [_usernameLabel setFont:[UIFont systemFontOfSize:18]];
        [_usernameLabel setText:self.contentItem.userItem.userName];
    }
    return _usernameLabel;
}

- (UILabel *)userFollowerLabel
{
    if(_userFollowerLabel == nil)
    {
        _userFollowerLabel = [[UILabel alloc]init];
        [_userFollowerLabel setTextColor:[UIColor darkGrayColor]];
        [_userFollowerLabel setFont:[UIFont systemFontOfSize:14]];
        [_userFollowerLabel setText:[NSString stringWithFormat:@"%d subscribers", self.contentItem.userItem.followerNum]];
        
        // KVO
        [self.contentItem.userItem addObserver:self
                                    forKeyPath:@"followerNum"
                                       options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                       context:@"following number changed"];
    }
    return _userFollowerLabel;
}

- (MDCButton *)followButton
{
    if(_followButton == nil)
    {
        _followButton = [MDCButton new];
        [_followButton applyTextThemeWithScheme:[MDCContainerScheme new]];
        [_followButton setTitleFont:[UIFont systemFontOfSize:18] forState:UIControlStateNormal];
        [_followButton addTarget:self action:@selector(followButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        // 一开始默认未关注
        self.isFollowing = @(NO);
        [_followButton setTitle:@"SUBSCRIBE" forState:UIControlStateNormal];
        [_followButton setTitleColor:[AppConfig getMainColor] forState:UIControlStateNormal];
        
        // KVO
        [self addObserver:self
               forKeyPath:@"isFollowing"
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                  context:@"following state changed"];
        
        [self requestIfFollowing];
    }
    return _followButton;
}

- (void)followButtonClicked
{
    NSString *URL = [NSString stringWithFormat:@"http://159.75.1.231:5009/user/following/%@",self.contentItem.userItem.userName];
    NSDictionary *header = @{
        @"Authorization":[UserInfo sharedUser].token
    };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    if([self.isFollowing boolValue] == YES)
    {
        [manager DELETE:URL parameters:nil headers:header success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            NSDictionary *response = (NSDictionary *)responseObject;
            if([response[@"status"] isEqualToString:@"success"])
            {
                [self setValue:@(NO) forKey:@"isFollowing"];
                [self.contentItem.userItem setValue:@(self.contentItem.userItem.followerNum - 1) forKey:@"followerNum"];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"unfollow failed");
        }];
    }
    else
    {
        [manager PUT:URL parameters:nil headers:header success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            NSDictionary *response = (NSDictionary *)responseObject;
            if([response[@"status"] isEqualToString:@"success"])
            {
                [self setValue:@(YES) forKey:@"isFollowing"];
                [self.contentItem.userItem setValue:@(self.contentItem.userItem.followerNum + 1) forKey:@"followerNum"];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"follow failed");
        }];
    }
    
}

- (void)requestIfFollowing
{
    NSString *URL = [NSString stringWithFormat:@"http://159.75.1.231:5009/user/following/%@",self.contentItem.userItem.userName];
    NSDictionary *header = @{
        @"Authorization":[UserInfo sharedUser].token
    };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:URL parameters:nil headers:header progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *response = (NSDictionary *)responseObject;
        if([response[@"status"] isEqualToString:@"success"])
        {
            self.isFollowing = response[@"following"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"query following failed");
    }];
}

- (void)toUserPage
{
    NSString *username = self.contentItem.userItem.userName;
    UserPageViewController *userPage = [[UserPageViewController alloc]initWithUsername:username];
    [self.navigationController pushViewController:userPage animated:YES];
}
#pragma mark comment-card

- (MDCCard *)commentCard
{
    if(_commentCard == nil)
    {
        _commentCard = [[MDCCard alloc]init];
        [_commentCard applyThemeWithScheme:[[MDCContainerScheme alloc] init]];
        [_commentCard setBorderWidth:0.3 forState:UIControlStateNormal];
        [_commentCard setBorderColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_commentCard setCornerRadius:0];
        [_commentCard addSubview:self.commentTitleLabel];
        [_commentCard addSubview:self.commentNumLabel];
        [_commentCard addSubview:self.commenterAvatarView];
        [_commentCard addSubview:self.commentField];
        [_commentCard addSubview:self.topCommentLabel];
        [_commentCard addSubview:self.sendButton];
        
        [_commentCard addTarget:self action:@selector(toCommentPage) forControlEvents:UIControlEventTouchUpInside];
        
        [self addObserver:self
               forKeyPath:@"topCommentItem"
                  options:NSKeyValueObservingOptionNew
                  context:@"get top comment"];
    }
    return _commentCard;
}

- (UILabel *)commentTitleLabel
{
    if(_commentTitleLabel == nil)
    {
        _commentTitleLabel = [[UILabel alloc]init];
        [_commentTitleLabel setText:@"Comments"];
        [_commentTitleLabel setFont:[UIFont systemFontOfSize:16]];
    }
    return _commentTitleLabel;
}

- (UILabel *)commentNumLabel
{
    if(_commentNumLabel == nil)
    {
        _commentNumLabel = [[UILabel alloc]init];
//        [_commentNumLabel setBackgroundColor:[UIColor greenColor]];
        [_commentNumLabel setTextColor:[UIColor darkGrayColor]];
        [_commentNumLabel setFont:[UIFont systemFontOfSize:16]];
        [_commentNumLabel setText:[NSString stringWithFormat:@"%d", self.contentItem.commentNum]];
        
        // KVO
        [self.contentItem addObserver:self
                           forKeyPath:@"commentNum"
                              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                              context:@"comment number changed"];
        
        if(self.contentItem.commentNum != 0) [self requestTopComment];
    }
    return _commentNumLabel;
}

- (UIImageView *)commenterAvatarView
{
    if(_commenterAvatarView == nil)
    {
        _commenterAvatarView = [[UIImageView alloc]init];
        [_commenterAvatarView setContentMode:UIViewContentModeScaleAspectFill];
        [_commenterAvatarView setClipsToBounds:YES];
        [_commenterAvatarView.layer setCornerRadius:15];
        
        if(self.contentItem.commentNum == 0)
            [_commenterAvatarView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://159.75.1.231:5009%@", [UserInfo sharedUser].avatarURL]]];
    }
    return  _commenterAvatarView;
}

- (MDCBaseTextField *)commentField
{
    if(_commentField == nil)
    {
        _commentField = [MDCBaseTextField new];
        [_commentField setPlaceholder:@"Make the first comment!"];
        if(self.contentItem.commentNum != 0) [_commentField setHidden:YES];
    }
    return _commentField;
}

- (UILabel *)topCommentLabel
{
    if(_topCommentLabel == nil)
    {
        _topCommentLabel = [[UILabel alloc]init];
        [_topCommentLabel setFont:[UIFont systemFontOfSize:16]];
        if(self.contentItem.commentNum == 0) [_topCommentLabel setHidden:YES];
    }
    return _topCommentLabel;
}

- (UIButton *)sendButton
{
    if(_sendButton == nil)
    {
        _sendButton = [[UIButton alloc]init];
        [_sendButton setImage:[[UIImage imageNamed:@"paper-plane.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_sendButton.imageView setTintColor:[UIColor grayColor]];
        [_sendButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_sendButton addTarget:self action:@selector(commentButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        if(self.contentItem.commentNum != 0) [_sendButton setHidden:YES];
    }
    return _sendButton;
}

- (void)commentButtonClicked
{
    NSString *URL = @"http://159.75.1.231:5009/comments";
    NSDictionary *header = @{
        @"Authorization":[UserInfo sharedUser].token
    };
    NSDictionary *body = @{
        @"text":[self.commentField text],
        @"contentID":@(self.contentItem.contentID)
    };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:URL parameters:body headers:header progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *response = (NSDictionary *)responseObject;
        if([response[@"status"] isEqualToString:@"success"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.commentField setText:@""];
            });
            [self requestTopComment];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed to make a comment");
    }];
}

- (void)requestTopComment
{
    NSString *URL = [NSString stringWithFormat:@"http://159.75.1.231:5009/comments?contentID=%d&orderBy=likeNum",self.contentItem.contentID];
    NSDictionary *header = @{
        @"Authorization":[UserInfo sharedUser].token
    };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:URL parameters:nil headers:header progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *response = (NSDictionary *)responseObject;
        if([response[@"status"] isEqualToString:@"success"])
        {
            NSArray *commentsByDesc = response[@"data"];
            self.contentItem.commentNum = (int)[commentsByDesc count];
            if(self.contentItem.commentNum > 0)
                self.topCommentItem = [[CommentItem alloc]initWithDict:commentsByDesc[0]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"get top comment failed");
    }];
}

- (void)toCommentPage
{
    UINavigationController *commentNav = [[UINavigationController alloc]initWithRootViewController: [[CommentTableViewController alloc]initWithContentID:self.contentItem.contentID]];
    [self presentViewController:commentNav animated:YES completion:nil];
}

#pragma mark moreActionButton
- (UIButton *)moreActionButton
{
    if(_moreActionButton == nil)
    {
        _moreActionButton = [[UIButton alloc]init];
        [_moreActionButton setImage:[UIImage imageNamed:@"menu-lines@2x.png"] forState:UIControlStateNormal];
        [_moreActionButton addTarget:self action:@selector(moreActionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreActionButton;
}

- (void)moreActionButtonClicked:(UIButton *)sender
{
    if(self.contentItem.userItem.userID == [UserInfo sharedUser].userID)
    {
        [FTPopOverMenu showForSender:sender withMenuArray:@[@"DELETE"] doneBlock:^(NSInteger selectedIndex) {
            switch (selectedIndex) {
                case 0:
                    [self deleteContent];
                    break;
                    
            }
        } dismissBlock:^{
    
        }];
    }
    
}

- (void)deleteContent
{
    MDCAlertController *alertController = [MDCAlertController alertControllerWithTitle:@"DELETE" message:@"Are you sure?"];
    MDCAlertAction *cancelAction = [MDCAlertAction actionWithTitle:@"Cancel" handler:nil];
    MDCAlertAction *sureAction = [MDCAlertAction actionWithTitle:@"Yes" handler:^(MDCAlertAction * _Nonnull action) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        NSString *URL = [NSString stringWithFormat:@"http://159.75.1.231:5009/contents/%d",self.contentItem.contentID];
        NSDictionary *header = @{
            @"Authorization":[UserInfo sharedUser].token
        };
        
        [manager DELETE:URL parameters:nil headers:header success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"succeeded to delete");
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"failed to delete");
        }];
    }];
    [alertController addAction:sureAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark TagView
- (TagView *)videoTagView
{
    if(_videoTagView == nil)
    {
        _videoTagView = [[TagView alloc]initWithTagArray:self.contentItem.videoTags viewType:VideoTagView];
        _videoTagView.tagDelegate = self;
        [self.contentItem addObserver:self forKeyPath:@"videoTags" options:NSKeyValueObservingOptionNew context:@"tags changed"];
    }
    return _videoTagView;
}


#pragma mark tag delegate
- (void)addBtnClick:(UIButton *)btn {
    
    if(self.contentItem.userItem.userID == [UserInfo sharedUser].userID)
    {
        MDCAlertController *alertController =
        [MDCAlertController alertControllerWithTitle:@"Add New Tag" message:nil];
        
        MDCFilledTextField *inputField = [[MDCFilledTextField alloc]init];
        [inputField.label setText:@"Tag"];
        [inputField setNormalLabelColor:[UIColor grayColor] forState:MDCTextControlStateNormal];
        [inputField setUnderlineColor:[UIColor lightGrayColor] forState:MDCTextControlStateNormal];
        [inputField setUnderlineColor:[UIColor grayColor] forState:MDCTextControlStateEditing];
        [inputField setFloatingLabelColor:[UIColor grayColor] forState:MDCTextControlStateEditing];
        
        alertController.accessoryView = inputField;
        
        MDCAlertAction *OKAction = [MDCAlertAction actionWithTitle:@"YES" handler:^(MDCAlertAction *action) {
            NSString *newTagString = [inputField text];
            if([newTagString containsString:@" "])
            {
                alertController.message = @"space not allowed";
                [self presentViewController:alertController animated:YES completion:nil];
            }
            [self addNewTag:newTagString forContentID:self.contentItem.contentID];
        }];
        MDCAlertAction *CancelAction = [MDCAlertAction actionWithTitle:@"NO" handler:nil];
        [alertController addAction:OKAction];
        [alertController addAction:CancelAction];
        
        [alertController setTitleColor:[UIColor blackColor]];
        [alertController setButtonTitleColor:[AppConfig getMainColor]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        MDCAlertController *alertController =
        [MDCAlertController alertControllerWithTitle:@"Add New Tag" message:@"Only the author can edit tags"];
        MDCAlertAction *OKAction = [MDCAlertAction actionWithTitle:@"Fine" handler:nil];
        [alertController addAction:OKAction];
        
        [alertController setTitleColor:[UIColor blackColor]];
        [alertController setMessageColor:[UIColor darkGrayColor]];
        [alertController setButtonTitleColor:[AppConfig getMainColor]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    
}

- (void)longPressBtn:(UIButton *)btn {
    if(self.contentItem.userItem.userID == [UserInfo sharedUser].userID)
    {
        MDCAlertController *alertController =
        [MDCAlertController alertControllerWithTitle:@"Delete Tag"
                                             message:[NSString stringWithFormat:@"Sure to delete tag '%@' ?",[btn.titleLabel text]]];
        
        MDCAlertAction *OKAction = [MDCAlertAction actionWithTitle:@"YES" handler:^(MDCAlertAction *action) {
            [self deleteTag:[btn.titleLabel text] forContentID:self.contentItem.contentID];
        }];
        MDCAlertAction *CancelAction = [MDCAlertAction actionWithTitle:@"NO" handler:nil];
        
        [alertController addAction:CancelAction];
        [alertController addAction:OKAction];

        [alertController setMessageColor:[UIColor darkGrayColor]];
        [alertController setButtonTitleColor:[AppConfig getMainColor]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        MDCAlertController *alertController =
        [MDCAlertController alertControllerWithTitle:@"Delete Tag" message:@"Only the author can edit tags"];
        MDCAlertAction *OKAction = [MDCAlertAction actionWithTitle:@"Fine" handler:nil];
        [alertController addAction:OKAction];
        
        [alertController setTitleColor:[UIColor blackColor]];
        [alertController setMessageColor:[UIColor darkGrayColor]];
        [alertController setButtonTitleColor:[AppConfig getMainColor]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)tagBtnClick:(UIButton *)btn {
    NSString *tagString = [btn.titleLabel text];
    NSString *URLString = [NSString stringWithFormat:@"http://159.75.1.231:5009/contents?tag=%@",tagString];
    VideoListTableViewController *videoList = [[VideoListTableViewController alloc]initWithURL:URLString];
    [videoList loadData];
    [videoList.tableView.mj_footer setHidden:YES];
    [videoList.tableView.mj_header setHidden:YES];
    [videoList.tableView setBounces:NO];
    [videoList.navigationItem setTitle:[NSString stringWithFormat:@"Videos With Tag: %@", tagString]];
    [self.navigationController pushViewController:videoList animated:YES];
}

- (void)allBtnClick:(nonnull UIButton *)btn {}



#pragma mark tag operations
- (void)addNewTag:(NSString *)tagName forContentID:(int)contentID
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *URL = @"http://159.75.1.231:5009/content/tags";
    NSDictionary *header = @{
        @"Authorization":[UserInfo sharedUser].token
    };
    NSDictionary *body = @{
        @"contentID":@(contentID),
        @"tag":tagName
    };
    
    [manager POST:URL parameters:body headers:header progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *response = (NSDictionary *)responseObject;
        if([response[@"status"] isEqualToString:@"success"])
        {
            NSLog(@"add tag success");
            self.contentItem.videoTags = response[@"data"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed to add tag");
    }];
}


- (void)deleteTag:(NSString *)tagName forContentID:(int)contentID
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", nil];
    
    NSString *URL = @"http://159.75.1.231:5009/content/tags";
    NSDictionary *header = @{
        @"Authorization":[UserInfo sharedUser].token
    };
    NSDictionary *body = @{
        @"contentID":@(contentID),
        @"tag":tagName
    };
    
    [manager DELETE:URL parameters:body headers:header success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *response = (NSDictionary *)responseObject;
        if([response[@"status"] isEqualToString:@"success"])
        {
            NSLog(@"delete tag success");
            self.contentItem.videoTags = response[@"data"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed to delete tag %@",tagName);
    }];
}

#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"监听到%@的%@属性值改变了 - %@ - %@", object, keyPath, change, context);

    if([(__bridge NSString *)context isEqualToString:@"following state changed"])
    {
        if([self.isFollowing boolValue] == NO)
        {
            [self.followButton setTitle:@"SUBSCRIBE" forState:UIControlStateNormal];
            [self.followButton setTitleColor:[AppConfig getMainColor] forState:UIControlStateNormal];
        }
        else
        {
            [self.followButton setTitle:@"SUBSCRIBED" forState:UIControlStateNormal];
            [self.followButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
    }
    else if([(__bridge NSString *)context isEqualToString:@"following number changed"])
    {
        [self.userFollowerLabel setText:[NSString stringWithFormat:@"%d subscribers", self.contentItem.userItem.followerNum]];
    }
    else if([(__bridge NSString *)context isEqualToString:@"like status changed"])
    {
        if([change[@"new"] isEqualToNumber:@(YES)])
        {
            NSLog(@" doing like !! ");
            // do: like
            [self.likeButton setTitle:@"LIKED" forState:UIControlStateNormal];
            [self.likeButton setBackgroundColor:[UIColor grayColor]];
            [self.likeButton setImage:[[UIImage imageNamed:@"yes@3x.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        }
        else if([change[@"new"] isEqualToNumber:@(NO)])
        {
            NSLog(@" doing unlike !! ");
            // do: cancel like
            [self.likeButton setTitle:@"LIKE" forState:UIControlStateNormal];
            [self.likeButton setBackgroundColor:[AppConfig getMainColor]];
            [self.likeButton setImage:[[UIImage imageNamed:@"fav@3x.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        }
        [self.videoInfoLabel setText:[NSString stringWithFormat:@"%d views · %d likes · %@", self.contentItem.viewNum, self.contentItem.likeNum, [TimeTool timeBeforeInfoWithString:self.contentItem.createTime]]];
    }
    else if([(__bridge NSString *)context isEqualToString:@"comment number changed"])
    {
        [_commentNumLabel setText:[NSString stringWithFormat:@"%d", self.contentItem.commentNum]];
        if(self.contentItem.commentNum == 0)
        {
            [self.commentField setHidden:NO];
            [self.topCommentLabel setHidden:YES];
            [_commenterAvatarView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://159.75.1.231:5009%@", [UserInfo sharedUser].avatarURL]]];
        }
    }
    else if([(__bridge NSString *)context isEqualToString:@"get top comment"])
    {
        if(self.topCommentItem != nil)
        {
            [self.commenterAvatarView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://159.75.1.231:5009%@", self.topCommentItem.userItem.avatarURL]]];
            [self.topCommentLabel setText:self.topCommentItem.commentText];
            [self.topCommentLabel setHidden:NO];
            [self.commentField setHidden:YES];
            [self.sendButton setHidden:YES];
        }
    }
    else if([(__bridge NSString *)context isEqualToString:@"tags changed"])
    {
        self.videoTagView.tagArray = self.contentItem.videoTags;
        [self.videoTagView updateTagButtons];
    }
}

@end
