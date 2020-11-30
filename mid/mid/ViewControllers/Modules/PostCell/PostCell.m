//
//  PostCell.m
//  mid
//
//  Created by itlab on 2020/11/24.
//

#import "PostCell.h"
#import "ImageSender.h"
#import "CommentTableViewController.h"

@interface PostCell()
@property (nonatomic, strong) IBOutlet UILabel *timeLable;
@property (nonatomic, strong) IBOutlet UILabel *userNameLable;
@property (nonatomic, strong) IBOutlet UILabel *textContentLable;
@property (nonatomic, strong) IBOutlet UILabel *commentNumberLable;
@property (nonatomic, strong) IBOutlet UILabel *likeNumberLable;
@property (nonatomic, strong) IBOutlet UILabel *favNumberLable;

@property (nonatomic, strong) UIView *insidePicView;
@property (nonatomic, strong) IBOutlet UIScrollView *picView;

@property (nonatomic) int picNum;
@end



@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 仅用于测试
    [self initWithTestData];
    
    // 必调用
    [self initPicView];
    [self initStyle];
    
    _liked = false;
    _faved = false;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


# pragma mark 测试
- (void)initWithTestData
{
    _timeLable.text = @"2020 11 12";
    _userNameLable.text = @"Edward";
    _textContentLable.text = @"Music has always played an important role in my life—and that was especially true during my presidency. In honor of my book hitting shelves tomorrow, I put together this playlist featuring some memorable songs from my administration. Hope you enjoy it.";
    
    [_portraitButton setImage:[UIImage imageNamed:@"testPortrait.jpg"] forState:UIControlStateNormal];
    [_commentButton setImage:[UIImage imageNamed:@"comment.png"] forState:UIControlStateNormal];
    [_likeButton setImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
    [_favButton setImage:[UIImage imageNamed:@"fav.png"] forState:UIControlStateNormal];
    
    
    [_likeNumberLable setText:@"10"];
    [_commentNumberLable setText:@"2"];
    [_favNumberLable setText:@"4"];
}




# pragma mark 设置样式
- (void)initStyle
{
    _portraitButton.layer.cornerRadius = 3;
    _portraitButton.layer.masksToBounds = YES;
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
    [_likeButton setImage:[UIImage imageNamed:@"like-filled.png"] forState:UIControlStateNormal];
    _liked = YES;
}

- (void)cancelLike
{
    [_likeButton setImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
    _liked = NO;
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
    [_favButton setImage:[UIImage imageNamed:@"fav-filled.png"] forState:UIControlStateNormal];
    _faved = YES;
    
}

- (void)cancelFav
{
    [_favButton setImage:[UIImage imageNamed:@"fav.png"] forState:UIControlStateNormal];
    _faved = NO;
    
}

//# pragma mark 头像
//- (IBAction)pressPortrait:(id)sender
//{
//    NSLog(@"for test use");
//    // 进入个人页面
//    if(self.showPersonalPageBlock)
//    {
//        self.showPersonalPageBlock(@"testUserID");
//    }
//}


# pragma mark 图片区域
- (void)dontShowPicView
{
    [_picView removeFromSuperview];
}

- (void)initPicView
{
    int w = _picView.frame.size.width;
    int h = _picView.frame.size.height;
    _insidePicView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    
    [_picView addSubview:_insidePicView];
    [_picView setContentSize:CGSizeMake(110, h)];
    [_picView setClipsToBounds:YES]; // 使内部view不会超出外部view
    
    [_picView.layer setCornerRadius:5];
    [_insidePicView.layer setCornerRadius:5];
    UIColor *backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    [_insidePicView setBackgroundColor:backgroundColor];
    [_picView setBackgroundColor:backgroundColor];
    
    _picNum = 0;
}

- (void)addPic:(UIImage *)img
{
    // 如果添加前已有2张图片，resize
    if(_picNum >= 2)
    {
        [_insidePicView setFrame:CGRectMake(0, 0, 110 * (_picNum + 1) + 10, 120)];
        [_picView setContentSize:_insidePicView.frame.size];
    }
    
    // 添加新的 imageView
    UIImageView *newPicView = [[UIImageView alloc] initWithFrame:[self frameAtIndex:_picNum]];
    [newPicView setImage:img];
    [newPicView.layer setCornerRadius:5];
    [newPicView.layer setMasksToBounds:YES];
    
    // 添加点击放大的功能(继承UITapGestureRecognizer来夹带消息)
    ImageSender *tapGesture = [[ImageSender alloc] initWithTarget:self
                                                                   action:@selector(showFullImage:)];
    tapGesture.image = img;
    [newPicView setUserInteractionEnabled: YES];
    [newPicView addGestureRecognizer:tapGesture];
    
    [_insidePicView addSubview:newPicView];
    _picNum ++;
}

- (void)showFullImage:(ImageSender *)sender
{
    if(self.showImageBlock)
    {
        self.showImageBlock(sender.image);
    }
}

- (CGRect)frameAtIndex:(int)i
{
    return CGRectMake(10 + 110 * i, 10, 100, 100);
}



@end

