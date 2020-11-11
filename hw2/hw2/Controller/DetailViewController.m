//
//  DetailViewController.m
//  hw2
//
//  Created by itlab on 2020/11/9.
//  Copyright © 2020 itlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import "AppDelegate.h"

@implementation DetailViewController

- (instancetype)initWithIndex:(int)i
{
    self = [super init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    int w = self.view.bounds.size.width;
    int h = self.view.bounds.size.height;
    
    AppDelegate *myDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    Item *thisItem = [myDelegate.items objectAtIndex:i];
    
    // 上半部分，文字view
    _textView = [[UIView alloc] initWithFrame:CGRectMake(40, 120, w - 60, h / 2 - 30)];
    UILabel *info = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, w - 60, h / 2 - 30)];
    info.text = [thisItem getDetailedInfo];
    info.textAlignment = NSTextAlignmentNatural;
    info.numberOfLines = 22;
    [_textView addSubview:info];
//    info.backgroundColor = [UIColor brownColor];
//    _textView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_textView];
    
    int a = 40; // 图片间隔
    int d = (w - 160) / 3; // 图片边长
    _picView = [[UIView alloc]initWithFrame:CGRectMake(a, h / 2 + 105, w - 2 * a, h / 2 - 110)];
    NSArray *picFrames = @[[NSValue valueWithCGRect:CGRectMake(0, 0, d, d)],
                   [NSValue valueWithCGRect:CGRectMake(a + d, 0, d, d)],
                   [NSValue valueWithCGRect:CGRectMake(2*(a+d), 0, d, d)],
                   [NSValue valueWithCGRect:CGRectMake(0, a + d, d, d)],
                   [NSValue valueWithCGRect:CGRectMake(a+d, a + d, d, d)],
                   [NSValue valueWithCGRect:CGRectMake(2*(a+d), a + d, d, d)]];
    
    // 下半部分，图片view
    for(int j = 0; j < [thisItem.pics count]; j++)
    {
        UIImageView *imv = [[UIImageView alloc] initWithFrame:[[picFrames objectAtIndex:j] CGRectValue]];
        imv.image = [thisItem.pics objectAtIndex:j];
        [_picView addSubview:imv];
    }
    //_picView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_picView];
    
    return self;
}

- (void)viewDidLoad
{
    [self.navigationItem setTitle:[NSString stringWithFormat:@"查看打卡"]];
    [super viewDidLoad];
}



@end
