//
//  VideoPageViewController.m
//  Final
//
//  Created by itlab on 12/31/20.
//

#import "VideoPageViewController.h"
#import <MaterialComponents/MaterialTabs+TabBarView.h>
//#import <WMPlayer/WMPlayer.h>
#import <Masonry/Masonry.h>
#import <SJVideoPlayer/SJVideoPlayer.h>
#import <MaterialCards+Theming.h>
#import <AFNetworking/AFNetworking.h>
#import "AppConfig.h"
#import "TimeTool.h"
#import "UserInfo.h"

@interface VideoPageViewController () <UINavigationControllerDelegate>
@property (nonatomic, strong) SJVideoPlayer *player;
@property (nonatomic, strong) UIViewController *belowVideo;
@property (nonatomic, strong) MDCCard *videoInfoCard;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *videoInfoLabel;
@property (nonatomic, strong) UIImageView *expandIndicator;
@property (nonatomic, strong) MDCCard *likeCard;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UILabel *likeNumLabel;
@property (nonatomic, strong) MDCCard *userCard;
@property (nonatomic, strong) MDCCard *commentCard;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UILabel *commentNumLabel;

@property (atomic, strong) NSURL *url;
@end

@implementation VideoPageViewController
- (instancetype)initWithContentItem:(DetailedContentItem *)contentItem;
{
    self = [super init];
    self.contentItem = contentItem;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.player.view];
    [self.view addSubview:self.belowVideo.view];
    [self.player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(self.player.view.mas_width).multipliedBy(9.0/16);
    }];
    
    [self.belowVideo.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.player.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    
    /* card1 */
    [self.videoInfoCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.belowVideo.view);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
    [self.expandIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.videoInfoCard).offset(8);
        make.right.lessThanOrEqualTo(self.videoInfoCard).offset(-10);
        make.size.mas_equalTo(CGSizeMake(16, 16));
//        make.left.mas_equalTo(self.titleLabel.mas_right).offset(5);
        
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.videoInfoCard).offset(5);
        make.left.equalTo(self.videoInfoCard).offset(10);
        make.right.lessThanOrEqualTo(self.videoInfoCard).offset(-40);
    }];
    
 
    [self.videoInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(4);
        make.left.equalTo(self.videoInfoCard).offset(10);
        make.right.equalTo(self.videoInfoCard).offset(-70);
        make.bottom.equalTo(self.videoInfoCard).offset(-8);
        
    }];
    
    /* card2 */
    [self.likeCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.videoInfoCard.mas_bottom);
        make.left.equalTo(self.view);
        make.right.mas_equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(60);
    }];
    
    
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.centerY.equalTo(self.likeCard);
        make.right.equalTo(self.likeCard.mas_centerX);
    }];

    [self.likeNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.likeButton);
        make.left.equalTo(self.likeCard.mas_centerX).offset(8);
    }];
    
    /* card3 */
    [self.commentCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.videoInfoCard.mas_bottom);
        make.left.mas_equalTo(self.view.mas_centerX);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(60);
    }];
    
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.centerY.equalTo(self.commentCard);
        make.right.equalTo(self.commentCard.mas_centerX);
    }];

    [self.commentNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.commentButton);
        make.left.equalTo(self.commentCard.mas_centerX).offset(8);
    }];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:YES];
}

- (UIViewController *)belowVideo
{
    if(_belowVideo == nil)
    {
        _belowVideo = [[UIViewController alloc]init];
        [_belowVideo.view addSubview:self.videoInfoCard];
        [_belowVideo.view addSubview:self.likeCard];
        [_belowVideo.view addSubview:self.commentCard];
    }
    return _belowVideo;
}

- (SJVideoPlayer *)player
{
    if(_player == nil)
    {
        _player = [SJVideoPlayer player];
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://159.75.1.231:5009%@",self.contentItem.videoURL]];
        _player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:URL];
        [_player setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        // 以下两行使自动旋转被禁用
//        _player.autoManageViewToFitOnScreenOrRotation = NO;
//        _player.useFitOnScreenAndDisableRotation = YES;
        _player.defaultEdgeControlLayer.hiddenBottomProgressIndicator = YES;
        SJVideoPlayer.update(^(SJVideoPlayerSettings * _Nonnull commonSettings) {
//            commonSettings.placeholder = [UIImage imageNamed:@"placeholder"];
            commonSettings.progress_traceColor = [AppConfig getMainColor];
            commonSettings.progress_bufferColor = [UIColor whiteColor];
        });
    }
    return _player;
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
        [_videoInfoCard addTarget:self action:@selector(print1) forControlEvents:UIControlEventTouchUpInside];
        [_videoInfoCard addSubview:self.titleLabel];
        [_videoInfoCard addSubview:self.videoInfoLabel];
        [_videoInfoCard addSubview:self.expandIndicator];
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
//        [_videoInfoLabel setBackgroundColor:[UIColor orangeColor]];
        [_videoInfoLabel setFont:[UIFont systemFontOfSize:16]];
        [_videoInfoLabel setTextColor:[UIColor grayColor]];
        NSString *videoInfo = [NSString stringWithFormat:@"%d views · %@", self.contentItem.viewNum, [TimeTool timeBeforeInfoWithString:self.contentItem.createTime]];
        [_videoInfoLabel setText:videoInfo];
    }
    return _videoInfoLabel;
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

#pragma mark like-card
- (MDCCard *)likeCard
{
    if(_likeCard == nil)
    {
        _likeCard = [[MDCCard alloc]init];
        [_likeCard applyThemeWithScheme:[[MDCContainerScheme alloc] init]];
        [_likeCard setBorderWidth:0.3 forState:UIControlStateNormal];
        [_likeCard setBorderColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_likeCard setCornerRadius:0];
        [_likeCard addTarget:self action:@selector(likeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_likeCard addSubview:self.likeButton];
        [_likeCard addSubview:self.likeNumLabel];
    }
    return _likeCard;
}

- (UILabel *)likeNumLabel
{
    if(_likeNumLabel == nil)
    {
        _likeNumLabel = [[UILabel alloc]init];
//        [_likeNumLabel setBackgroundColor:[UIColor greenColor]];
        [_likeNumLabel setTextColor:[UIColor darkGrayColor]];
        [_likeNumLabel setFont:[UIFont systemFontOfSize:21]];
        [_likeNumLabel setTextAlignment:NSTextAlignmentLeft];
        [_likeNumLabel setText:[NSString stringWithFormat:@"%d", self.contentItem.likeNum]];
    }
    return _likeNumLabel;
}

- (UIButton *)likeButton
{
    if(_likeButton == nil)
    {
        _likeButton = [[UIButton alloc]init];
        [_likeButton setImage:[[UIImage imageNamed:@"like-filled.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        if(self.contentItem.liked)
        {
            [_likeButton setTintColor:[AppConfig getMainColor]];
        }
        else
        {
            [_likeButton setTintColor:[UIColor grayColor]];
        }
        [_likeButton sizeToFit];
        [_likeButton setClipsToBounds:YES];
        [_likeButton.layer setMasksToBounds:YES];
        [_likeButton addTarget:self action:@selector(likeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likeButton;
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
        [_commentCard addTarget:self action:@selector(commentButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_commentCard addSubview:self.commentButton];
        [_commentCard addSubview:self.commentNumLabel];
    }
    return _commentCard;
}


- (UILabel *)commentNumLabel
{
    if(_commentNumLabel == nil)
    {
        _commentNumLabel = [[UILabel alloc]init];
//        [_commentNumLabel setBackgroundColor:[UIColor greenColor]];
        [_commentNumLabel setTextColor:[UIColor darkGrayColor]];
        [_commentNumLabel setFont:[UIFont systemFontOfSize:23]];
        [_commentNumLabel setTextAlignment:NSTextAlignmentLeft];
        [_commentNumLabel setText:[NSString stringWithFormat:@"%d", self.contentItem.commentNum]];
    }
    return _commentNumLabel;
}

- (UIButton *)commentButton
{
    if(_commentButton == nil)
    {
        _commentButton = [[UIButton alloc]init];
        [_commentButton setImage:[[UIImage imageNamed:@"comment.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        if(self.contentItem.commentNum > 0)
            [_commentButton setTintColor:[AppConfig getMainColor]];
        else
            [_commentButton setTintColor:[UIColor grayColor]];
        [_commentButton sizeToFit];
        [_commentButton setClipsToBounds:YES];
        [_commentButton.layer setMasksToBounds:YES];
        [_commentButton addTarget:self action:@selector(commentButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentButton;
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
        // do: cancel like
        [_likeButton setTintColor:[UIColor grayColor]];
        self.contentItem.liked = NO;
        self.contentItem.likeNum --;
        [manager DELETE:URL parameters:nil headers:header success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            if([responseObject[@"status"] isEqualToString:@"success"])
            {
                NSLog(@"cancel like success");
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
        // do: like
        [_likeButton setTintColor:[AppConfig getMainColor]];
        self.contentItem.liked = YES;
        self.contentItem.likeNum ++;
        [manager PUT:URL parameters:nil headers:header success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            if([responseObject[@"status"] isEqualToString:@"success"])
            {
                NSLog(@"like success");
            }
            else if([responseObject[@"status"] isEqualToString:@"failed"])
            {
                NSLog(@"did like");
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"like failed");
        }];
    }
    [self.likeNumLabel setText:[NSString stringWithFormat:@"%d", self.contentItem.likeNum]];
    
}

- (void)print1
{
    NSLog(@"1111111");
    UIViewController *testVC = [UIViewController new];
    [testVC.view setBackgroundColor:[UIColor whiteColor]];
    UINavigationController *testNav = [[UINavigationController alloc]initWithRootViewController:testVC];
    testNav.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    testVC.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemClose target:self action:@selector(quitTest)];
    
    [self.belowVideo presentViewController:testNav animated:YES completion:nil];
}




- (void)commentButtonClicked
{
    NSLog(@"222222");
    UIViewController *testVC = [UIViewController new];
    [testVC.view setBackgroundColor:[UIColor grayColor]];
    UINavigationController *testNav = [[UINavigationController alloc]initWithRootViewController:testVC];
    testNav.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    testVC.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemClose target:self action:@selector(quitTest)];
    
    [self.belowVideo presentViewController:testNav animated:YES completion:nil];
}

- (void)quitTest
{
    [self.belowVideo dismissViewControllerAnimated:YES completion:nil];
}
@end
