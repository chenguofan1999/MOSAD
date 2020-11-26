//
//  PostCell.h
//  mid
//
//  Created by itlab on 2020/11/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell
@property (nonatomic, copy) void (^actionBlock)(UIImage *image);
- (void)setVal;
- (void)dontShowPicView;
- (void)addPic:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END

