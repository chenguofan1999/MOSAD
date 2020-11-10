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
    _textView = [[UIView alloc] initWithFrame:CGRectMake(60, 120, w - 40, h / 2 - 120)];
    UILabel *info = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, w - 60, h / 2 - 140)];
    info.text = [thisItem getDetailedInfo];
    info.textAlignment = NSTextAlignmentNatural;
    info.numberOfLines = 15;
    [_textView addSubview:info];
    //info.backgroundColor = [UIColor brownColor];
    //_textView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_textView];
    
    _picView = [[UIView alloc]initWithFrame:CGRectMake(40, h / 2 + 10, w - 40, h / 2 - 120)];
    NSArray *picFrames = @[[NSValue valueWithCGRect:CGRectMake(20, 20, 70, 70)],
                   [NSValue valueWithCGRect:CGRectMake(130, 20, 70, 70)],
                   [NSValue valueWithCGRect:CGRectMake(240, 20, 70, 70)],
                   [NSValue valueWithCGRect:CGRectMake(20, 130, 70, 70)],
                   [NSValue valueWithCGRect:CGRectMake(130, 130, 70, 70)],
                   [NSValue valueWithCGRect:CGRectMake(240, 130, 70, 70)]];
    
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
