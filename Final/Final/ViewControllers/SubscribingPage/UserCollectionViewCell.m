//
//  UserCollectionViewCell.m
//  Final
//
//  Created by itlab on 1/6/21.
//

#import "UserCollectionViewCell.h"
#import <Masonry/Masonry.h>

@implementation UserCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubview:self.avatarView];
        [self addSubview:self.usernameLabel];
        [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(20);
            make.width.mas_equalTo(self.avatarView.mas_height);
            make.centerX.equalTo(self);
        }];
        [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.avatarView.mas_bottom).offset(5);
            make.height.mas_equalTo(15);
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(-12);
        }];
    }
    
    [self layoutIfNeeded];
    [self.avatarView.layer setCornerRadius:self.avatarView.frame.size.width/2];
    return self;
}



- (UIImageView *)avatarView
{
    if(_avatarView == nil)
    {
        _avatarView = [[UIImageView alloc]init];
        [_avatarView setContentMode:UIViewContentModeScaleAspectFill];
        [_avatarView setClipsToBounds:YES];
        [_avatarView setImage:[UIImage imageNamed:@"dog.jpg"]];
        
        [_avatarView setBackgroundColor:[UIColor grayColor]];
    }
    return _avatarView;
}

- (UILabel *)usernameLabel
{
    if(_usernameLabel == nil)
    {
        _usernameLabel = [[UILabel alloc]init];
        [_usernameLabel setTextColor:[UIColor darkGrayColor]];
        [_usernameLabel setFont:[UIFont systemFontOfSize:14]];
        [_usernameLabel setNumberOfLines:1];
        
        [_usernameLabel setText:@"Placeholder"];
    }
    return _usernameLabel;
}

@end
