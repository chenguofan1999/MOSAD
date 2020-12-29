//
//  PlusButton.m
//  Final
//
//  Created by itlab on 12/28/20.
//

#import "PlusButton.h"
#import "PostContentViewController.h"
#import "SceneDelegate.h"
#define is_iPhoneXSerious @available(iOS 11.0, *) && UIApplication.sharedApplication.keyWindow.safeAreaInsets.bottom > 0.0

@implementation PlusButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

//+ (CGFloat)multiplierOfTabBarHeight:(CGFloat)tabBarHeight {
//    return  0.3;
//}

+ (CGFloat)constantOfPlusButtonCenterYOffsetForTabBarHeight:(CGFloat)tabBarHeight {
    if([SceneDelegate isIphoneXSerie])
        return  -18;
    
    NSLog(@"不是");
    return 0;
}


+ (id)plusButton
{
    PlusButton *button = [[PlusButton alloc] init];
    ///中间按钮图片
    UIImage *buttonImage = [UIImage imageNamed:@"plus@3x.png"];
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button setImage:buttonImage forState:UIControlStateSelected];
    button.frame = CGRectMake(0.0, 0.0, 70, 40);
    
//    [button addTarget:self action:@selector(toPostPage) forControlEvents:UIControlEventTouchUpInside];
    return button;
}



//+ (NSUInteger)indexOfPlusButtonInTabBar
//{
//   return 2;
//}
//
//+ (UIViewController *)plusChildViewController
//{
//    return [PostContentViewController new];
//}

@end
