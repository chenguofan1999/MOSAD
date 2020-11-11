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
    UILabel *myDate = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, w - 60, 50)];
    UILabel *myLocation = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, w - 60, 50)];
    UILabel *myThoughts = [[UILabel alloc]initWithFrame:CGRectMake(0, 120, w - 60, h / 2 - 140)];
    myDate.text = [thisItem date];
    myDate.font = [UIFont systemFontOfSize:30];
    myLocation.text = [NSString stringWithFormat:@"%@ of %@",[thisItem spot], [thisItem location]];
    myLocation.font = [UIFont systemFontOfSize:25];
    myThoughts.text = [thisItem thoughts];
    myThoughts.font = [UIFont systemFontOfSize:15];
    myThoughts.numberOfLines = 22;
    [self setLineSpace:8.0f withText:[thisItem thoughts] inLabel:myThoughts];
    [myThoughts sizeToFit];
    
    [_textView addSubview:myDate];
    [_textView addSubview:myLocation];
    [_textView addSubview:myThoughts];
//    _textView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_textView];
    
    // 下半部分，图片view
    int a = 40; // 图片间隔
    int d = (w - 4 * a) / 3; // 图片边长
    _picView = [[UIView alloc]initWithFrame:CGRectMake(a, h / 2 + 90, w - 2 * a, h / 2 - 110)];
    NSArray *picFrames = @[[NSValue valueWithCGRect:CGRectMake(0, 0, d, d)],
                   [NSValue valueWithCGRect:CGRectMake(a + d, 0, d, d)],
                   [NSValue valueWithCGRect:CGRectMake(2*(a+d), 0, d, d)],
                   [NSValue valueWithCGRect:CGRectMake(0, a + d, d, d)],
                   [NSValue valueWithCGRect:CGRectMake(a+d, a + d, d, d)],
                   [NSValue valueWithCGRect:CGRectMake(2*(a+d), a + d, d, d)]];
    
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


/**
 设置固定行间距文本
 @param lineSpace 行间距
 @param text 文本内容
 @param label 要设置的label
 */
-(void)setLineSpace:(CGFloat)lineSpace withText:(NSString *)text inLabel:(UILabel *)label
{
    if (!text || !label) {
        return;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;  //设置行间距
    paragraphStyle.lineBreakMode = label.lineBreakMode;
    paragraphStyle.alignment = label.textAlignment;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    label.attributedText = attributedString;
}

@end
