//
//  CommentTableViewController.m
//  mid
//
//  Created by itlab on 11/28/20.
//

#import "CommentTableViewController.h"
#import "CommentCell.h"
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
{
    self = [super init];
    _contentID = contentID;
    
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
    
    // 样式
    [self.tableView setBounces:NO];
    [self.view setBackgroundColor:veryLightGrayColor];
    
    // 发布button
    
    
    [self loadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return [_commentItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    
    NSInteger i = indexPath.row;
    cell.userNameLable.text = [_commentItems[i] userName];
    cell.textContentLable.text = [_commentItems[i] commentContent];
    cell.timeLable.text = [self timeStampToTime:[_commentItems[i] publishDate]];
    cell.likeLabel.text = [NSString stringWithFormat:@"%d",[_commentItems[i] likeNum]];
    if([UserInfo sharedUser].userId != [_commentItems[i] userID])
    {
        [cell.deleteButton setHidden:YES];
    }
    else
    {
        [cell.replyButton setHidden:YES];
    }
    
    
    
    return cell;
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
                    FullCommentItem *newItem = [[FullCommentItem alloc] initWithDict:data[i]];
                    [self.commentItems addObject:newItem];
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
