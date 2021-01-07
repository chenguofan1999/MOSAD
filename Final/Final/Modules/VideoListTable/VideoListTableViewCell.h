//
//  VideoListTableViewCell.h
//  Final
//
//  Created by itlab on 12/28/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoListTableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIImageView *coverImage;
@property (nonatomic, strong) IBOutlet UIButton *avatarButton;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *infoLabel;
@property (nonatomic, strong) IBOutlet UILabel *durationLabel;
@end

NS_ASSUME_NONNULL_END
