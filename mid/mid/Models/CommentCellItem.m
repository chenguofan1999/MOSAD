//
//  CommentCellItem.m
//  mid
//
//  Created by itlab on 12/2/20.
//

#import "CommentCellItem.h"
#import "UserInfo.h"

@implementation CommentCellItem
- (instancetype)initWithFullCommentItem:(FullCommentItem *)fullCommentItem
{
    self = [super init];
    self.userName = [[fullCommentItem userItem]userName];
    self.avatar = [[fullCommentItem userItem]avatar];
    self.commentContent = [[fullCommentItem commentItem]commentContent];
    self.publishDate = [self timeStampToTime:[[fullCommentItem commentItem]publishDate]];
    self.likeNum = [[fullCommentItem commentItem]likeNum];
    self.commentID = [[fullCommentItem commentItem]commentID];
    // 判断显示按钮
    if([UserInfo sharedUser].userId == [[fullCommentItem commentItem] userID])
    {
        self.hideReplyButton = YES;
        self.hideDeleteButton = NO;
    }
    else
    {
        self.hideReplyButton = NO;
        self.hideDeleteButton = YES;
    }
    self.isReply = NO;
    return self;
}

- (instancetype)initWithFullReplyItem:(FullReplyItem *)fullReplyItem
                  andCommentOwnerName:(NSString *)commentOwnerName
{
    self = [super init];
    self.userName = [[fullReplyItem userItem]userName];
    self.avatar = [[fullReplyItem userItem]avatar];
    NSString *replyContents = [[fullReplyItem replyItem]replyContent];
    self.commentContent = [NSString stringWithFormat:@"回复 %@: %@", commentOwnerName, replyContents];
    self.publishDate = [self timeStampToTime:[[fullReplyItem replyItem]publishDate]];
    self.likeNum = [[fullReplyItem replyItem]likeNum];
    
    // 判断显示按钮: reply 不提供这两种功能
    self.hideReplyButton = YES;
    self.hideDeleteButton = YES;
    
    self.isReply = YES;
    return self;
}

#pragma mark 时间戳转化日期
- (NSString *)timeStampToTime:(long)time
{
   // 时段转换时间
   NSDate *date=[NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)time];
   // 时间格式
   NSDateFormatter *dataformatter = [[NSDateFormatter alloc] init];
   dataformatter.dateFormat = @"MM-dd HH:mm a";
   // 时间转换字符串
   return [dataformatter stringFromDate:date];
}

@end
