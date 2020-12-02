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
//@property (nonatomic, copy) void (^showPersonalPageBlock)(NSString *userID);
@property (nonatomic, strong) IBOutlet UIButton *likeButton;
@property (nonatomic, strong) IBOutlet UIButton *favButton;
@property (nonatomic, strong) IBOutlet UIButton *commentButton;
@property (nonatomic, strong) IBOutlet UIButton *deleteButton;
@property (nonatomic, strong) IBOutlet UIButton *portraitButton;
@property (nonatomic, strong) IBOutlet UILabel *timeLable;
@property (nonatomic, strong) IBOutlet UILabel *userNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *textContentLable;
@property (nonatomic, strong) IBOutlet UILabel *commentNumberLable;
@property (nonatomic, strong) IBOutlet UILabel *likeNumberLable;
@property (nonatomic, strong) IBOutlet UILabel *favNumberLable;
@property (nonatomic) int picNum;
@property (nonatomic) bool liked;
@property (nonatomic) bool faved;
- (void)dontShowPicView;
- (void)addPic:(UIImage *)image;
@end
NS_ASSUME_NONNULL_END

