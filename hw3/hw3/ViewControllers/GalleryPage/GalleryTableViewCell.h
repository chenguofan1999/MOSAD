//
//  GalleryTableViewCell.h
//  hw3
//
//  Created by itlab on 12/8/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GalleryTableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIImageView *myImageView;
@property (nonatomic, strong) IBOutlet UILabel *infoLabel;
@property (nonatomic, strong) IBOutlet UILabel *infoTitleLabel;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, strong) IBOutlet UIProgressView *progressBar;
@end

NS_ASSUME_NONNULL_END
