//
//  BigImageViewController.m
//  Final
//
//  Created by itlab on 1/6/21.
//

#import "BigImageViewController.h"
#import <Masonry/Masonry.h>
@interface BigImageViewController ()

@end

@implementation BigImageViewController

- (instancetype)initWithImage:(UIImage *)img
{
    self = [super init];
    self.img = img;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imgView = [[UIImageView alloc]initWithImage:self.img];
    [self.view addSubview:imgView];
    
    CGFloat R = (float)0x36/255;
    CGFloat G = (float)0x36/255;
    CGFloat B = (float)0x40/255;
    [self.view setBackgroundColor:[UIColor colorWithRed:R green:G blue:B alpha:1]];
    
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    [imgView setFrame:self.view.frame];
    
//    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.centerY.equalTo(self.view);
//        make.left.right.width.equalTo(self.view);
//
//    }];
}


@end
