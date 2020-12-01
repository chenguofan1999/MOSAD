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
    cell.textContentLable.text = [_items[i] contentData].detail;
    cell.userNameLable.text = [_items[i] userName];
    
    return cell;
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
//    [self.tableView reloadData];
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
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Failed to fetch public contents somehow");
    }];
    
    [self.tableView reloadData];
    
}

@end
