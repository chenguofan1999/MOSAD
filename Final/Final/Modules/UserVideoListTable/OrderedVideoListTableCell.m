//
//  UserVideoListTableCell.m
//  Final
//
//  Created by itlab on 1/7/21.
//

#import <Masonry/Masonry.h>
#import "OrderedVideoListTableCell.h"

@implementation OrderedVideoListTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.coverView setContentMode:UIViewContentModeScaleAspectFill];
    [self.coverView setClipsToBounds:YES];
    
    [self.durationLabel.layer setCornerRadius:5];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
