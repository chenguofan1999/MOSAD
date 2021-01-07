//
//  UserVideoListTableCell.h
//  Final
//
//  Created by itlab on 1/7/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderedVideoListTableCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *durationLabel;
@property (nonatomic, strong) IBOutlet UIImageView *coverView;
@property (nonatomic, strong) IBOutlet UILabel *videoTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *videoInfoLabel;
@property (nonatomic, strong) IBOutlet UIButton *moreActionButton;
@end

NS_ASSUME_NONNULL_END
