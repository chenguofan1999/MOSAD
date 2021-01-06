//
//  PreViewController.m
//  Final
//
//  Created by itlab on 1/5/21.
//

#import "PreViewController.h"
#import <Masonry/Masonry.h>
@interface PreViewController ()
@end

@implementation PreViewController

- (instancetype)initWithURL:(NSURL *)URL
{
    self = [super init];
    self.URL = URL;
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:self.player.view];
    [self.player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view);
        make.left.right.offset(0);
        make.height.equalTo(self.player.view.mas_width).multipliedBy(9/16.0);
    }];
    return self;
}

- (instancetype)initWithURL:(NSURL *)URL parentVC:(PostContentViewController *)viewController
{
    self = [super init];
    self.URL = URL;
    self.parentPageVC = viewController;
    
    CGFloat R = (float)0x36/255;
    CGFloat G = (float)0x36/255;
    CGFloat B = (float)0x40/255;
    [self.view setBackgroundColor:[UIColor colorWithRed:R green:G blue:B alpha:1]];
    
    [self.view addSubview:self.player.view];
    [self.view addSubview:self.screenShotButton];
    [self.player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view).offset(-55);
        make.left.offset(0);
        make.right.offset(0);
        make.height.equalTo(self.player.view.mas_width).multipliedBy(9/16.0);
    }];
    
    [self.screenShotButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.player.view.mas_bottom).offset(40);
        make.left.offset(25);
        make.right.offset(-25);
        make.height.mas_equalTo(45);
    }];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}



- (SJVideoPlayer *)player
{
    if(_player == nil)
    {
        _player = SJVideoPlayer.player;
        _player.URLAsset = [[SJVideoPlayerURLAsset alloc]initWithURL:self.URL];
    }
    
    return _player;
}

- (MDCButton *)screenShotButton
{
    if(_screenShotButton == nil)
    {
        _screenShotButton = [MDCButton new];
        [_screenShotButton applyContainedThemeWithScheme:[MDCContainerScheme new]];
        [_screenShotButton setTitle:@"Select Screenshot" forState:UIControlStateNormal];
        
        CGFloat R = (float)0x1E/255;
        CGFloat G = (float)0xB9/255;
        CGFloat B = (float)0x80/255;
        [_screenShotButton setBackgroundColor:[UIColor colorWithRed:R green:G blue:B alpha:1] forState:UIControlStateNormal];
        
        [_screenShotButton addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _screenShotButton;
}

- (void)buttonClicked
{
    NSLog(@"?");
    UIImage *img = [self.player screenshot];
    [self.parentPageVC UpdateCoverImage:img];
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
