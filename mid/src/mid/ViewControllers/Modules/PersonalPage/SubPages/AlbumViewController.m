//
//  PhotoViewController.m
//  mid
//
//  Created by itlab on 11/26/20.
//


#import "AlbumViewController.h"
#import "ImageSender.h"
#import "BigImageViewController.h"


@interface AlbumViewController ()
//@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *innerView;
@property (nonatomic) CGFloat interval;
@property (nonatomic) CGFloat sideLen;
@property (nonatomic) int picNum;
@end

@implementation AlbumViewController

- (void)loadView
{
    // 计算无遮挡页面尺寸
    UIWindow *window = UIApplication.sharedApplication.windows[0];
    CGRect safe = window.safeAreaLayoutGuide.layoutFrame;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:safe];
    self.view = _scrollView;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [_scrollView setBackgroundColor:[UIColor darkGrayColor]];
    
    // childViewController 默认关闭这一自动排布功能
    [self.navigationController.view setNeedsLayout];
    
    CGFloat w = [[UIScreen mainScreen] bounds].size.width;
    _interval = 12.0f;
    _sideLen = (w - _interval * 4) / 3;
    _picNum = 0;
    
    _innerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, w, (2 * _interval + _sideLen))];
    [_innerView setBackgroundColor:[UIColor darkGrayColor]];
    
    [self.view addSubview:_innerView];
    [_scrollView setContentSize:_innerView.frame.size];

    // test
    [self test];
}

- (void)test
{
    for(int i = 0; i < 9; i++)
    {
        NSString *fileName = [NSString stringWithFormat:@"test10%d.jpg", i];
        [self addImage:[UIImage imageNamed:fileName]];
    }
    for(int i = 0; i < 9; i++)
    {
        NSString *fileName = [NSString stringWithFormat:@"test20%d.jpg", i];
        [self addImage:[UIImage imageNamed:fileName]];
    }
    for(int i = 0; i < 9; i++)
    {
        NSString *fileName = [NSString stringWithFormat:@"test10%d.jpg", i];
        [self addImage:[UIImage imageNamed:fileName]];
    }
    for(int i = 0; i < 9; i++)
    {
        NSString *fileName = [NSString stringWithFormat:@"test20%d.jpg", i];
        [self addImage:[UIImage imageNamed:fileName]];
    }for(int i = 0; i < 9; i++)
    {
        NSString *fileName = [NSString stringWithFormat:@"test10%d.jpg", i];
        [self addImage:[UIImage imageNamed:fileName]];
    }
    for(int i = 0; i < 9; i++)
    {
        NSString *fileName = [NSString stringWithFormat:@"test20%d.jpg", i];
        [self addImage:[UIImage imageNamed:fileName]];
    }for(int i = 0; i < 9; i++)
    {
        NSString *fileName = [NSString stringWithFormat:@"test10%d.jpg", i];
        [self addImage:[UIImage imageNamed:fileName]];
    }
    for(int i = 0; i < 9; i++)
    {
        NSString *fileName = [NSString stringWithFormat:@"test20%d.jpg", i];
        [self addImage:[UIImage imageNamed:fileName]];
    }
}


- (CGRect)getFrameAtIndex:(int)i
{
    int row = i / 3;
    int col = i % 3;
    CGFloat x = (1 + col) * _interval + col * _sideLen;
    CGFloat y = (1 + row) * _interval + row * _sideLen;
    return CGRectMake(x, y, _sideLen, _sideLen);
}

- (void)addImage:(UIImage *)img
{
    // 是否resize
    if(_picNum % 3 == 0)
    {
        CGFloat w = [[UIScreen mainScreen] bounds].size.width;
        CGFloat newHeight = _interval + (_picNum / 3 + 1) * (_interval + _sideLen) + 120;
        _innerView.frame = CGRectMake(0, 0, w, newHeight);
        [_scrollView setContentSize:CGSizeMake(w, newHeight)];
    }
    
    // 创建新的 ImageView
    UIImageView *newImageView = [[UIImageView alloc] initWithFrame:[self getFrameAtIndex:_picNum]];
    [newImageView setImage:img];
    [newImageView.layer setCornerRadius:3];
    [newImageView.layer setMasksToBounds:YES];
    [newImageView setContentMode:UIViewContentModeScaleAspectFill]; // 不要拉伸
    
    // 增加点击事件
    [newImageView setUserInteractionEnabled:YES];
    ImageSender *gesture = [[ImageSender alloc]initWithTarget:self action:@selector(showBigImage:)];
    gesture.image = img;
    [newImageView addGestureRecognizer:gesture];
    
    [_innerView addSubview: newImageView];
    _picNum ++;
}

- (void)showBigImage:(ImageSender *)sender
{
    BigImageViewController *bivc = [[BigImageViewController alloc] init];
    bivc.view.backgroundColor = [UIColor blackColor];
    bivc.image = sender.image;
    [self presentViewController:bivc animated:YES completion:nil];
//    [self.navigationController pushViewController:bivc animated:YES];
}

@end
