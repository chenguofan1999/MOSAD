//
//  DiscoverViewController.m
//  mid
//
//  Created by itlab on 2020/11/23.
//

#import "DiscoverViewController.h"
#import "PostCell.h"
#import "FullDataItem.h"
#import "ContentItem.h"
#import "FullContentItem.h"
#import "MiniUserItem.h"
#import "BigImageViewController.h"
#import "CommentTableViewController.h"
#import "ProfilePageViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface DiscoverViewController ()
@property (nonatomic) NSMutableArray *items;
@property (nonatomic, strong) UILabel *header;
@end

@implementation DiscoverViewController

- (instancetype)init
{
    self = [super init];
    
    self.tabBarItem.title = @"广场";
    self.tabBarItem.image = [UIImage imageNamed:@"search@2x.png"];
    self.tabBarItem.selectedImage =[UIImage imageNamed:@"search-filled@2x.png"];

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // 标题
    CGFloat w = [[UIScreen mainScreen] bounds].size.width;
    _header = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, w, 80)];
    _header.text = @"  最新内容";
    _header.font = [UIFont boldSystemFontOfSize:32];
    self.tableView.tableHeaderView = _header;
    
    // 初始化数据源
    _items = [NSMutableArray new];
    
    // 顶部 SegmentedControl
    NSArray *segmentedData = @[@"按时间线",@"按热度"];
    UISegmentedControl *segmentBar = [[UISegmentedControl alloc] initWithItems:segmentedData];
    [segmentBar setWidth:120 forSegmentAtIndex:0];
    [segmentBar setWidth:120 forSegmentAtIndex:1];
    [segmentBar addTarget:self action:@selector(choose:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentBar;
    
    [segmentBar setSelectedSegmentIndex:0];
    
    // 刷新 button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadData)];
    
    // 一些样式
    [self.tableView setBounces:NO];
    
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadData];
}

#pragma mark 热门or时间顺序
- (void)choose:(UISegmentedControl *)seg
{
    NSInteger Index = seg.selectedSegmentIndex;
    switch (Index) {
        case 0:
            // 设置数据源
            break;
        case 1:
            // 设置数据源
            break;
    }
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
    return [_items count];
}

// 点击变灰后立即恢复
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

// cell 的具体属性
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 以下代码得到一个 PostCell, 几乎没有数据，需要赋值。
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
        //[self.navigationController pushViewController:bivc animated:YES];
        [self presentViewController:bivc animated:YES completion:nil];
    };

    // 为buttons设置事件
    [cell.likeButton addTarget:self action:@selector(likePost:) forControlEvents:UIControlEventTouchUpInside];
    [cell.portraitButton addTarget:self action:@selector(toUserPage:) forControlEvents:UIControlEventTouchUpInside];
    [cell.favButton addTarget:self action:@selector(favPost:) forControlEvents:UIControlEventTouchUpInside];
    [cell.commentButton addTarget:self action:@selector(showCommentPage:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteButton setHidden:YES];
    
    // for test use
    [cell addPic:[UIImage imageNamed:@"testPic.jpg"]];
    
    // 设置 cell 的值
    long i = indexPath.row;
    ContentItem *contentItem = [_items[i] contentItem];
    MiniUserItem *userItem = [_items[i] userItem];
//    if([contentItem.type isEqualToString:@"Text"])
//    {
//        NSLog(@"not album");
//        [cell dontShowPicView];
//    }
    [cell dontShowPicView];
    cell.userNameLabel.text = userItem.userName;
    cell.portraitButton.imageView.image = userItem.avatar;
    [self setLabel:cell.textContentLable
         WithTitle:contentItem.title
              Tags:contentItem.tags
            Detail:contentItem.detail];
    cell.timeLable.text = [self timeStampToTime:[contentItem PublishDate]];
    cell.likeNumberLable.text = [NSString stringWithFormat:@"%d", [contentItem likeNum]];
    cell.commentNumberLable.text = [NSString stringWithFormat:@"%d", [contentItem commentNum]];
    
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

#pragma mark 头像button
- (void)toUserPage:(UIButton *)btn
{
    UIView *contentView = [btn superview];
    PostCell *cell = (PostCell *)[contentView superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    // 已经得到indexPath
    NSLog(@"press avator button at row %ld", indexPath.row);
    [self.navigationController pushViewController:[[ProfilePageViewController alloc]init] animated:NO];
}

#pragma mark 点赞button
- (void)likePost:(UIButton *)btn
{
    // 得到indexPath
    UIView *contentView = [btn superview];
    PostCell *cell = (PostCell *)[contentView superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    
    NSInteger i = indexPath.row;
    NSString *contentID = [[_items[i] contentItem]contentID];
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
    NSString *contentID = [[_items[indexPath.row] contentItem] contentID];
    NSString *ownerID = [[_items[indexPath.row] contentItem] ownerID];
    //[self.navigationController pushViewController:[CommentTableViewController new] animated:NO];
    [self presentViewController:[[CommentTableViewController alloc]initWithContentID:contentID andOwnerID:ownerID] animated:YES completion:nil];
}

# pragma mark 从后台拉取数据
- (void)loadData
{
    NSString *URL = @"http://172.18.178.56/api/content/public?page=1&eachPage=100";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:URL parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *response = (NSDictionary *)responseObject;
//        NSLog(@"%@",response);
        if([response[@"State"] isEqualToString:@"success"])
        {
//            self.items = [NSMutableArray new];
            NSArray *data = response[@"Data"];
            NSInteger n = [data count];
            for(int i = 0; i < n; i++)
            {
                FullDataItem *newItem = [[FullDataItem alloc]initWithDict:data[i]];
                if([self.items count] > i)
                    self.items[i] = newItem;
                else [self.items addObject:newItem];
            }
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Failed to fetch public contents somehow");
    }];
    
}

@end
