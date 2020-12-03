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


@property (nonatomic, strong) UIView *insidePicView;
@property (nonatomic, strong) IBOutlet UIScrollView *picView;


@end



@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 仅用于测试
    [self initWithTestData];
    
    // 必调用
    [self initPicView];
    [self initStyle];
    
    _liked = NO;
    _faved = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


# pragma mark 测试
- (void)initWithTestData
{
    _timeLable.text = @"2020 11 12";
    _userNameLabel.text = @"Edward";
    _textContentLable.text = @"Music has always played an important role in my life—and that was especially true during my presidency. In honor of my book hitting shelves tomorrow, I put together this playlist featuring some memorable songs from my administration. Hope you enjoy it.";
    
    [_portraitButton setBackgroundImage:nil forState:UIControlStateNormal];
    [_commentButton setBackgroundImage:nil forState:UIControlStateNormal];
    [_likeButton setBackgroundImage:nil forState:UIControlStateNormal];
    [_favButton setBackgroundImage:nil forState:UIControlStateNormal];
    [_deleteButton setBackgroundImage:nil forState:UIControlStateNormal];
    
//    [_portraitButton setImage:[UIImage imageNamed:@"testPortrait.jpg"] forState:UIControlStateNormal];
    [_commentButton setImage:[UIImage imageNamed:@"comments.png"] forState:UIControlStateNormal];
    [_likeButton setImage:[UIImage imageNamed:@"like-color.png"] forState:UIControlStateNormal];
    [_favButton setImage:[UIImage imageNamed:@"bookmark-color.png"] forState:UIControlStateNormal];
    [_deleteButton setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
    
    
    [_likeNumberLable setText:@"10"];
    [_commentNumberLable setText:@"2"];
    [_favNumberLable setText:@""];
}




# pragma mark 设置样式
- (void)initStyle
{
    _portraitButton.layer.cornerRadius = 3;
    _portraitButton.layer.masksToBounds = YES;
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
    [newPicView setClipsToBounds:YES];
    
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

