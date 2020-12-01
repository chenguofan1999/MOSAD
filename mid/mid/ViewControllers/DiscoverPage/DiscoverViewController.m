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
#import "BigImageViewController.h"
#import "CommentTableViewController.h"
#import "ProfilePageViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface DiscoverViewController ()
@property (nonatomic) NSMutableArray *items;
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
    UILabel *header = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, w, 80)];
    header.text = @"  最新内容";
    header.font = [UIFont boldSystemFontOfSize:32];
    self.tableView.tableHeaderView = header;
    
    // 初始化数据源
    _items = [NSMutableArray new];
    
    NSArray *segmentedData = @[@"按时间线",@"按热度"];
    UISegmentedControl *segmentBar = [[UISegmentedControl alloc] initWithItems:segmentedData];
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
    // 无复用版本
//    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PostCell" owner:self options:nil];
//    PostCell *cell = [topLevelObjects objectAtIndex:0];
    
    // 设置数据
//    [cell setVal:..];

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
    //cell.textContentLable.text = [_items[i] contentData].detail;
    cell.userNameLable.text = [_items[i] userName];
    [self setLabel:cell.textContentLable
         WithTitle:[_items[i] contentData].title
              Tags:[_items[i] contentData].tags
            Detail:[_items[i] contentData].detail];
    return cell;
}

#pragma mark 设定内部具有不同样式的内容
- (void)setLabel:(UILabel *)label
       WithTitle:(NSString *)title
            Tags:(NSMutableArray *)tags
          Detail:(NSString *)detail
{
    NSString *newTitle = [title length] == 0 ? @"" : [NSString stringWithFormat:@"%@\n", title];
    NSString *newDetail = [detail length] == 0 ? @"" :[NSString stringWithFormat:@"%@\n", detail];
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
    [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17] range:rangeTitle];
    
    // Detail 样式
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:rangeDetail];
    
    // Tags 样式
    UIColor *tagColor = [UIColor colorWithRed:(float)29/255 green:(float)161/255 blue:(float)242/255 alpha:1];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:rangeTags];
    [str addAttribute:NSForegroundColorAttributeName value:tagColor range:rangeTags];
    
    [label setAttributedText:str];
}

// 选中 cell 的效果
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{}

// 取消选中 cell 的效果
//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{}
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
    UIView *contentView = [btn superview];
    PostCell *cell = (PostCell *)[contentView superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    // 已经得到indexPath
    NSLog(@"press like button at row %ld", indexPath.row);
}

#pragma mark 评论区button
- (void)showCommentPage:(UIButton *)btn
{
    UIView *contentView = [btn superview];
    PostCell *cell = (PostCell *)[contentView superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    // 已经得到indexPath
    NSLog(@"press comment button at row %ld", indexPath.row);
    //[self.navigationController pushViewController:[CommentTableViewController new] animated:NO];
    [self presentViewController:[CommentTableViewController new] animated:YES completion:nil];
}

# pragma mark 刷新
- (void)loadData
{
    NSString *URL = @"http://172.18.178.56/api/content/public?page=1&eachPage=20";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:URL parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *response = (NSDictionary *)responseObject;
//        NSLog(@"%@",response);
        if([response[@"State"] isEqualToString:@"success"])
        {
            NSArray *data = response[@"Data"];
            NSInteger n = [data count];
            for(int i = 0; i < n; i++)
            {
                FullDataItem *newItem = [[FullDataItem alloc]initWithDict:data[i]];
                NSLog(@"Item[%d]: %@", i, newItem);
                [self.items addObject:newItem];
            }
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Failed to fetch public contents somehow");
    }];
    
}

@end
