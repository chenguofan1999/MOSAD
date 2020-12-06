//
//  PostViewController.m
//  mid
//
//  Created by itlab on 11/26/20.
//
#import "PostViewController.h"
#import "BigImageViewController.h"
#import "ContentItem.h"
#import "PostCell.h"
#import "CommentTableViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface PostViewController ()
@property (nonatomic) NSMutableArray *contentitems;
@end

@implementation PostViewController
- (instancetype)initWithType:(NSString *)contentType
                      UserID:(NSString *)userID
                    UserName:(NSString *)userName
{
    self = [super init];
    _userID = userID;
    _contentType = contentType;
    _userName = userName;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

#pragma mark - UITableViewDataSource

// section 个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Section 中的 Cell 个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_contentitems count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

// cell 的具体属性
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 以下代码得到一个 PostCell, 几乎没有数据，需要赋值。
    // 有复用版本
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PostCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }

    // 设置Block（点击略缩图事件）
    cell.showImageBlock = ^(UIImage *img){
        BigImageViewController *bivc = [[BigImageViewController alloc] init];
        bivc.view.backgroundColor = [UIColor blackColor];
        bivc.image = img;
        [self presentViewController:bivc animated:YES completion:nil];
    };

    // 为buttons设置事件
    [cell.likeButton addTarget:self action:@selector(likePost:) forControlEvents:UIControlEventTouchUpInside];
    [cell.favButton addTarget:self action:@selector(favPost:) forControlEvents:UIControlEventTouchUpInside];
    [cell.commentButton addTarget:self action:@selector(showCommentPage:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteButton setHidden:YES];
    
    // for test use
//    [cell addPic:[UIImage imageNamed:@"testPic.jpg"]];
    
    long i = indexPath.row;
    ContentItem *contentItem = _contentitems[i];
    
    if([contentItem.contentType isEqualToString:@"Text"])
    {
        [cell dontShowPicView];
    }
    else
    {
        NSArray *images = contentItem.album[@"Images"];
        if((NSNull *)images != [NSNull null])
        {
            for(int i = 0; i < [images count]; i++)
            {
                NSString *thumbName = images[i][@"Thumb"];
                NSString *imageURL = [NSString stringWithFormat:@"http://172.18.178.56/api/thumb/%@", thumbName];
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
                [cell addPic:image];
            }
            if([images count] == 0)
            {
                [cell addPic:[UIImage imageNamed:@"noImage.jpg"]];
            }
        }
    }
    
    [self setLabel:cell.textContentLable
         WithTitle:contentItem.contentTitle
              Tags:contentItem.tags
            Detail:contentItem.detail];
    cell.timeLable.text = [self timeStampToTime:[contentItem PublishDate]];
    cell.likeNumberLable.text = [NSString stringWithFormat:@"%d", [contentItem likeNum]];
    cell.commentNumberLable.text = [NSString stringWithFormat:@"%d", [contentItem commentNum]];
    cell.userNameLabel.text = _userName;
    [cell.portraitButton setImage:[UIImage imageNamed:@"maleUser.png"] forState:UIControlStateNormal];
    
    return cell;
}

#pragma mark 时间戳转化日期
- (NSString *)timeStampToTime:(long)time
{
   // 时段转换时间
   NSDate *date=[NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)time];
   // 时间格式
   NSDateFormatter *dataformatter = [[NSDateFormatter alloc] init];
   dataformatter.dateFormat = @"MM-dd HH:mm";
   // 时间转换字符串
   return [dataformatter stringFromDate:date];
}

#pragma mark 设定内部具有不同样式的内容
- (void)setLabel:(UILabel *)label
       WithTitle:(NSString *)title
            Tags:(NSMutableArray *)tags
          Detail:(NSString *)detail
{
    NSString *newTitle = nil;
    if([title length] == 0) newTitle = @"";
    else if([detail length] == 0 && [tags count] == 0) newTitle = title;
    else newTitle = [NSString stringWithFormat:@"%@\n", title];
    
    NSString *newDetail = nil;
    if([detail length] == 0) newDetail = @"";
    else if([tags count] == 0) newDetail = detail;
    else newDetail = [NSString stringWithFormat:@"%@\n", detail];
    
    NSMutableString *connectedTags = [[NSMutableString alloc]init];
    for(int i = 0; i < [tags count]; i++)
    {
        if(i == 0) [connectedTags appendString:@"#"];
        if(i == [tags count] - 1)
            [connectedTags appendFormat:@"%@", tags[i]];
        else
            [connectedTags appendFormat:@"%@ #", tags[i]];
    }
    
    NSUInteger lenTitle = [newTitle length];
    NSUInteger lenDetail = [newDetail length];
    NSUInteger lenTags = [connectedTags length];
    
    NSRange rangeTitle = NSMakeRange(0, lenTitle);
    NSRange rangeDetail = NSMakeRange(lenTitle, lenDetail);
    NSRange rangeTags = NSMakeRange(lenTitle + lenDetail, lenTags);
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@%@",newTitle,newDetail,connectedTags]];
    
    // Title 样式
    [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:rangeTitle];
    
    // Detail 样式
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:rangeDetail];
    
    // Tags 样式
    UIColor *tagColor = [UIColor colorWithRed:(float)29/255 green:(float)161/255 blue:(float)242/255 alpha:1];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:rangeTags];
    [str addAttribute:NSForegroundColorAttributeName value:tagColor range:rangeTags];
    
    [label setAttributedText:str];
}

#pragma mark 喜欢button
- (void)favPost:(UIButton *)btn
{
    UIView *contentView = [btn superview];
    PostCell *cell = (PostCell *)[contentView superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    // 已经得到indexPath
    NSLog(@"press fav button at row %ld", indexPath.row);
}


#pragma mark 点赞button
- (void)likePost:(UIButton *)btn
{
    UIView *contentView = [btn superview];
    PostCell *cell = (PostCell *)[contentView superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    // 已经得到indexPath
    NSLog(@"press like button at row %ld", indexPath.row);
    
    NSString *contentID = [_contentitems[indexPath.row] contentID];
    NSString *URL = [NSString stringWithFormat:@"%@%@",@"http://172.18.178.56/api/like/",contentID];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary *body = @{
        @"isContent" : @YES,
        @"isComment" : @NO,
        @"isReply" : @NO
    };
    
    NSLog(@"Id : %@", contentID);
    
    NSLog(@"尝试点赞");
    [manager POST:URL parameters:body headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if([responseObject[@"State"] isEqualToString:@"exist"])
        {
            NSLog(@"已经点赞，应取消点赞");
            [manager PATCH:URL parameters:body headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"%@", responseObject);
                [self loadData];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"failed to patch somehow");
            }];
        }
        else
            [self loadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed to post somehow");
    }];
}



#pragma mark 评论区button
- (void)showCommentPage:(UIButton *)btn
{
    UIView *contentView = [btn superview];
    PostCell *cell = (PostCell *)[contentView superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    // 已经得到indexPath
    NSLog(@"press comment button at row %ld", indexPath.row);
    NSString *contentID = [_contentitems[indexPath.row] contentID];
    NSString *ownerID = [_contentitems[indexPath.row] ownerID];
    [self presentViewController:[[CommentTableViewController alloc]initWithContentID:contentID andOwnerID:ownerID] animated:YES completion:nil];
}


#pragma mark 从后端拉取数据
- (void)loadData
{
    NSString *URL = nil;
    if([_contentType isEqualToString:@"Text"])
        URL = [NSString stringWithFormat:@"%@%@",@"http://172.18.178.56/api/content/texts/",_userID];
    else if([_contentType isEqualToString:@"Album"])
        URL = [NSString stringWithFormat:@"%@%@",@"http://172.18.178.56/api/content/album/",_userID];
    
    NSLog(@"=========== URL: %@ ============", URL);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:URL parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *response = (NSDictionary *)responseObject;
        NSLog(@"%@",response);
        if([response[@"State"] isEqualToString:@"success"])
        {
            self.contentitems = [NSMutableArray new];
            NSArray *data = response[@"Data"];
            if((NSNull *)data != [NSNull null])
            {
                NSInteger n = [data count];
                NSLog(@"Item Number: %ld",n);
                for(int i = 0; i < n; i++)
                {
                    ContentItem *newItem = [[ContentItem alloc]initWithDict:data[i]];
                    [self.contentitems addObject:newItem];
                }
            }
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Failed to fetch public contents somehow");
    }];
    
    
}

@end
