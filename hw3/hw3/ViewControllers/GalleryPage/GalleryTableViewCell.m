//
//  GalleryTableViewCell.m
//  hw3
//
//  Created by itlab on 12/8/20.
//

#import "GalleryTableViewCell.h"


@implementation GalleryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_myImageView.layer setCornerRadius:5];
    [_myImageView setContentMode:UIViewContentModeScaleAspectFill];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
