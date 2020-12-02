//
//  CommentTableViewController.m
//  mid
//
//  Created by itlab on 11/28/20.
//

#import "CommentTableViewController.h"
#import "CommentCell.h"
#import "ReplyCell.h"
#import "CommentCellItem.h"
#import <AFNetworking/AFNetworking.h>
#import "FullCommentItem.h"
#import "UserInfo.h"

@interface CommentTableViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UILabel *header;
@property (nonatomic, strong) UITextField *commentField;
@property (nonatomic, strong) UIButton *commentButton;
@end

@implementation CommentTableViewController

- (instancetype)initWithContentID:(NSString *)contentID
                       andOwnerID:(NSString *)ownerID
{
    self = [super init];
    _contentID = contentID;
    _ownerID = ownerID;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    // 头部的标签
    CGFloat w = [[UIScreen mainScreen] bounds].size.width;
    _header = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, w, 80)];
    _header.text = @"  评论";
    _header.font = [UIFont boldSystemFontOfSize:30];
    self.tableView.tableHeaderView = _header;
    
    // 尾部的评论框
    _commentField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, w, 45)];
    UIColor *veryLightGrayColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    [_commentField setBackgroundColor:veryLightGrayColor];
    [_commentField setPlaceholder:@" 写一条新的评论"];
    _commentButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 45)];
    [_commentButton setTitle:@"发布 " forState:UIControlStateNormal];
    UIColor *lightBlueColor = [UIColor colorWithRed:(float)29/255 green:(float)161/255 blue:(float)242/255 alpha:1];
    [_commentButton setTitleColor:lightBlueColor forState:UIControlStateNormal];
    [_commentField setRightViewMode:UITextFieldViewModeWhileEditing];
    [_commentField setRightView:_commentButton];
    self.tableView.tableFooterView = _commentField;
    
    // 注册
    UINib *nib = [UINib nibWithNibName:@"CommentCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"CommentCell"];
    
    nib = [UINib nibWithNibName:@"ReplyCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"ReplyCell"];
    
    // 样式
    [self.tableView setBounces:NO];
    [self.view setBackgroundColor:veryLightGrayColor];
    
    // 发布button的事件
    [_commentButton addTarget:self action:@selector(publishComment) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self loadData];
}

#pragma mark 发布按钮
- (void)publishComment
{
    NSString *URL = [NSString stringWithFormat:@"http://172.18.178.56/api/comment"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary *body = @{
        @"contentID" : _contentID,
        @"fatherID"  : _ownerID,
        @"content"   : [_commentField text],
        @"isReply"   : @NO
    };
    
    NSLog(@"params: %@", body);
    
    [manager POST:URL parameters:body headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"Comment Succeeded: %@", responseObject);
        [self loadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Comment Failed");
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return [_commentItems count];
}

// 点击变灰后立即恢复
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger i = indexPath.row;
    CommentCellItem *cellItem = _commentItems[i];
    
    UITableViewCell *cell = nil;
    
    if(cellItem.isReply)
    {
        ReplyCell *replyCell = [tableView dequeueReusableCellWithIdentifier:@"ReplyCell" forIndexPath:indexPath];
        replyCell.userNameLable.text = cellItem.userName;
        replyCell.portraitButton.imageView.image = cellItem.avatar;
        replyCell.textContentLable.text = cellItem.commentContent;
        replyCell.timeLable.text = cellItem.publishDate;
        replyCell.likeLabel.text = [NSString stringWithFormat:@"%d",cellItem.likeNum];
        cell = replyCell;
    }
    else
    {
        CommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
        commentCell.userNameLable.text = cellItem.userName;
        commentCell.portraitButton.imageView.image = cellItem.avatar;
        commentCell.textContentLable.text = cellItem.commentContent;
        commentCell.timeLable.text = cellItem.publishDate;
        commentCell.likeLabel.text = [NSString stringWithFormat:@"%d",cellItem.likeNum];
        [commentCell.deleteButton setHidden:cellItem.hideDeleteButton];
        [commentCell.replyButton setHidden:cellItem.hideReplyButton];
        // 添加 reply 事件
        if(cellItem.hideReplyButton == NO)
            [commentCell.replyButton addTarget:self action:@selector(pressReplyButton:) forControlEvents:UIControlEventTouchUpInside];
        cell = commentCell;
    }
    
    return cell;
}

#pragma mark 回复评论
- (void)pressReplyButton:(UIButton *)btn
{
    // 得到 indexPath
    UIView *contentView = [btn superview];
    CommentCell *cell = (CommentCell *)[contentView superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    NSInteger i = indexPath.row;
    NSString *contentID = [_commentItems[i] commentID];
    NSString *fatherID = self.contentID;
    
    // 弹窗输入内容
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"回复" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"输入回复内容";
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray *textfields = alertController.textFields;
        UITextField *textfield = textfields[0];
        NSString *content = [textfield text];
        
        // 发送！
        NSString *URL = [NSString stringWithFormat:@"http://172.18.178.56/api/comment"];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        NSDictionary *body = @{
            @"contentID" : contentID,
            @"fatherID"  : fatherID,
            @"content"   : content,
            @"isReply"   : @YES
        };
        
        [manager POST:URL parameters:body headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSLog(@"%@", responseObject);
                    [self loadData];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"failed somehow");
                }];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    
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

#pragma mark 从后台拉取评论数据
- (void)loadData
{
    NSString *URL = [NSString stringWithFormat:@"http://172.18.178.56/api/comment/%@", _contentID];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:URL parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDict = (NSDictionary *)responseObject;
        NSLog(@"%@",responseDict);
        if([responseDict[@"State"] isEqualToString:@"success"])
        {
            self.commentItems = [NSMutableArray new];
            NSArray *data = responseDict[@"Data"];
            if((NSNull *)data != [NSNull null])
            {
                NSInteger n = [data count];
                for(int i = 0; i < n; i++)
                {
                    // 插入评论Item
                    FullCommentItem *commentItem = [[FullCommentItem alloc] initWithDict:data[i]];
                    CommentCellItem *convertedCommentItem = [[CommentCellItem alloc]initWithFullCommentItem:commentItem];
                    [self.commentItems addObject:convertedCommentItem];
                    
                    // 插入其回复Items
                    NSString *commentOwnerName = convertedCommentItem.userName;
                    NSArray *replyItemDicts = commentItem.replies;
                    
                    if((NSNull *)replyItemDicts != [NSNull null])
                    {
                        for(int i = 0; i < [replyItemDicts count]; i++)
                        {
                            NSDictionary *dict = replyItemDicts[i];
                            FullReplyItem *replyItem = [[FullReplyItem alloc]initWithDict:dict];
                            CommentCellItem *convertedReplyItem = [[CommentCellItem alloc]initWithFullReplyItem:replyItem andCommentOwnerName:commentOwnerName];
                            [self.commentItems addObject:convertedReplyItem];
                        }
                    }
                }
            }
        }
        else
        {
            NSLog(@"You might have mistaken the contentID");
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Get comments failed somehow");
    }];
}


@end
