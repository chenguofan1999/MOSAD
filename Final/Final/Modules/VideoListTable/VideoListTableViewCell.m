//
//  VideoListTableViewCell.m
//  Final
//
//  Created by itlab on 12/28/20.
//

#import "VideoListTableViewCell.h"

@implementation VideoListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    // 头像样式
    [_avatarButton setClipsToBounds:YES];
    [_avatarButton.imageView setClipsToBounds:YES];
    [_avatarButton.imageView setContentMode:UIViewContentModeScaleAspectFill];
    _avatarButton.layer.cornerRadius = 25;
    [_avatarButton setBackgroundImage:nil forState:UIControlStateNormal];
    
    
    // 封面图片样式
    _coverImage.layer.masksToBounds = YES;
    _coverImage.clipsToBounds = YES;
    [_coverImage setContentMode:UIViewContentModeScaleAspectFill];
    
    // duration
    _durationLabel.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
