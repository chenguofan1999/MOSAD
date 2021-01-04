//
//  CommentTableViewCell.m
//  Final
//
//  Created by itlab on 1/3/21.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    // set style
    [self.avatarButton.imageView.layer setCornerRadius:20];
//    [self.layer setBorderColor:[UIColor grayColor].CGColor];
//    [self.layer setBorderWidth:0.5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"监听到%@的%@属性值改变了 - %@ - %@", object, keyPath, change, context);
    if([(__bridge NSString *)context isEqualToString:@"likeNum"])
    {
        [self.likeLabel setText:[change[@"new"] intValue] > 0 ? [NSString stringWithFormat:@"%d", [change[@"new"] intValue]] : @""];
    }
    if([(__bridge NSString *)context isEqualToString:@"liked"])
    {
        if([change[@"new"] boolValue] == YES)
        {
            [self.likeButton setImage:[UIImage imageNamed:@"thumbs-up-filled.png"] forState:UIControlStateNormal];
        }
        else
        {
            [self.likeButton setImage:[UIImage imageNamed:@"thumbs-up.png"] forState:UIControlStateNormal];
        }
    }
    if([(__bridge NSString *)context isEqualToString:@"replyNum"])
    {
        [self.replyLabel setText:[change[@"new"] intValue] > 0 ? [NSString stringWithFormat:@"%d", [change[@"new"] intValue]] : @""];
    }
    
}

@end
