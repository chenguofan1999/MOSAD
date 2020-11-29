//
//  PostCell.h
//  mid
//
//  Created by itlab on 2020/11/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell
@property (nonatomic, copy) void (^showImageBlock)(UIImage *image);
@property (nonatomic, copy) void (^showPersonalPageBlock)(NSString *userID);
@property (nonatomic, copy) void (^showCommentsBlock)(NSString *contentID);
- (void)setVal;
- (void)dontShowPicView;
- (void)addPic:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END

