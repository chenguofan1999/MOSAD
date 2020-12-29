//
//  TestViewController.m
//  Final
//
//  Created by itlab on 12/23/20.
//

#import "TestViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "TagView.h"

@interface TestViewController ()
@property (nonatomic) NSString *videoURL;
@property (nonatomic, strong)AVPlayer *player;
@property (nonatomic, strong)AVPlayerItem *currentPlayerItem;
@end

@implementation TestViewController

- (instancetype)initWithVideoURL:(NSString *)URL
{
    self = [super init];
    self.videoURL = URL;
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.view setBackgroundColor:[UIColor blueColor]];
    
//    [self videoTest];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [self videoTest];
//    CGFloat w = [[UIScreen mainScreen] bounds].size.width;
//    [self.view addSubview:[[TagView alloc]initWithFrame:CGRectMake(0, 200, w, 50) tagArray:@[@"hello",@"world",@"!",@"???",@"epic",@"sacxz",@"cqic",@"asnciuiiueqnfu"]]];
//    [self.view addSubview:[[TagView alloc]initWithTagArray:@[@"hello",@"world",@"!",@"???",@"epic",@"sacxz",@"cqic",@"asnciuiiueqnfu"]]];
}


- (void)videoTest
{
    NSURL *videoURL = [NSURL URLWithString:self.videoURL];
    AVPlayer *avPlayer = [[AVPlayer alloc]initWithURL:videoURL];
    AVPlayerViewController *avpc = [[AVPlayerViewController alloc]init];
    avpc.player = avPlayer;
    
    CGFloat w = [[UIScreen mainScreen] bounds].size.width;
    avpc.view.frame = CGRectMake(10, 100, w-20, 150);
    
    [self addChildViewController:avpc];
    [self.view addSubview:avpc.view];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
