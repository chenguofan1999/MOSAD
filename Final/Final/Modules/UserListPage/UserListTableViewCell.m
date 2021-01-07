//
//  UserListTableViewCell.m
//  Final
//
//  Created by itlab on 1/7/21.
//

#import "UserListTableViewCell.h"

@interface UserListTableViewCell()
@end


@implementation UserListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.avatarView.layer setCornerRadius:22.5];
    [self.avatarView setClipsToBounds:YES];
    [self.avatarView setContentMode:UIViewContentModeScaleAspectFill];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
