//
//  PostCell.m
//  mid
//
//  Created by itlab on 2020/11/24.
//

#import "PostCell.h"

@interface PostCell()
@property (nonatomic, strong) IBOutlet UIButton *portraitButton;
@property (nonatomic, strong) IBOutlet UILabel *timeLable;
@property (nonatomic, strong) IBOutlet UILabel *userNameLable;
@property (nonatomic, strong) IBOutlet UILabel *textContentLable;
@property (nonatomic, strong) IBOutlet UIButton *commentButton;
@property (nonatomic, strong) IBOutlet UIButton *likeButton;
@property (nonatomic, strong) IBOutlet UIButton *favButton;
@property (nonatomic, strong) IBOutlet UILabel *commentNumberLable;
@property (nonatomic, strong) IBOutlet UILabel *likeNumberLable;
@property (nonatomic, strong) IBOutlet UILabel *favNumberLable;

@property (nonatomic) bool liked;
@property (nonatomic) bool faved;
@end


@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _timeLable.text = @"2020 11 12";
    _userNameLable.text = @"Edward";
    _textContentLable.text = @"Music has always played an important role in my life—and that was especially true during my presidency. In honor of my book hitting shelves tomorrow, I put together this playlist featuring some memorable songs from my administration. Hope you enjoy it.";
    
    [_portraitButton setImage:[UIImage imageNamed:@"edvard-munch.png"] forState:UIControlStateNormal];
    [_commentButton setImage:[UIImage imageNamed:@"comment.png"] forState:UIControlStateNormal];
    [_likeButton setImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
    [_favButton setImage:[UIImage imageNamed:@"fav.png"] forState:UIControlStateNormal];
    
    [_likeNumberLable setText:@"10"];
    [_commentNumberLable setText:@"2"];
    [_favNumberLable setText:@"4"];
    
    _liked = false;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


# pragma mark 点击 like button
- (IBAction)pressLikeButton:(id)sender
{
    if(_liked)
    {
        [self cancelLike];
    }
    else
    {
        [self like];
    }
}

- (void)like
{
    [_likeButton setBackgroundImage:[UIImage imageNamed:@"like-filled.png"] forState:UIControlStateNormal];
    _liked = YES;
    // HTTP POST and GET
    
}

- (void)cancelLike
{
    [_likeButton setBackgroundImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
    _liked = NO;
    // HTTP POST and GET
    
}

# pragma mark 点击 fav button
- (IBAction)pressFavButton:(id)sender
{
    if(_faved)
    {
        [self cancelFav];
    }
    else
    {
        [self fav];
    }
}

- (void)fav
{
    [_favButton setBackgroundImage:[UIImage imageNamed:@"fav-filled.png"] forState:UIControlStateNormal];
    _faved = YES;
    // HTTP POST and GET
    
}

- (void)cancelFav
{
    [_favButton setBackgroundImage:[UIImage imageNamed:@"fav.png"] forState:UIControlStateNormal];
    _faved = NO;
    // HTTP POST and GET
    
}

# pragma mark 点击 comment button
- (IBAction)pressCommentButton:(id)sender
{
    NSLog(@"comment button pressed");
    // 展开回复框
}

# pragma mark 点击头像
- (IBAction)pressPortrait:(id)sender
{
    NSLog(@"portrait pressed");
    // 进入个人页面
}

- (void)setVal
{
    
}




@end
