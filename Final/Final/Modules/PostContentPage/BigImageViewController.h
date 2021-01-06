//
//  BigImageViewController.h
//  Final
//
//  Created by itlab on 1/6/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BigImageViewController : UIViewController
//@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIImage *img;
- (instancetype)initWithImage:(UIImage *)img;
@end

NS_ASSUME_NONNULL_END
