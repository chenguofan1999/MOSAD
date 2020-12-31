//
//  VideoListTableViewController.m
//  Final
//
//  Created by itlab on 12/28/20.
//

#import "VideoListTableViewController.h"
#import "VideoListTableViewCell.h"
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/SDWebImage.h>
#import <SDWebImage/UIButton+WebCache.h>
#import <MJRefresh/MJRefresh.h>
#import "TimeTool.h"
#import "VideoPageViewController.h"
#import "UserInfo.h"
#import "DetailedContentItem.h"
@interface VideoListTableViewController ()
@property (nonatomic) int contentNum;
@end

@implementation VideoListTableViewController
- (instancetype)initWithURL:(NSString *)URL
{
    self = [super init];
    self.serviceURL = URL;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // 注册
    UINib *nib = [UINib nibWithNibName:@"VideoListTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"VideoListTableViewCell"];

    
    // 样式
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadData)];
    //    [self.tableView setBounces:NO];
    _contentNum = 5;
    [self addMJRefresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:NO];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.contentItems count];
//    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoListTableViewCell" forIndexPath:indexPath];
    
    BriefContentItem *itemForThisRow = self.contentItems[indexPath.row];
    [cell.titleLabel setText:itemForThisRow.title];
    [cell.infoLabel setText:[NSString stringWithFormat:@"%@ · %d views · %@",
                             itemForThisRow.userItem.userName, itemForThisRow.viewNum, [TimeTool timeBeforeInfoWithString:itemForThisRow.createTime]]];
    [cell.coverImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://159.75.1.231:5009%@",itemForThisRow.coverURL]] placeholderImage:[UIImage imageNamed:@"Yourtube1.png"]];
    [cell.avatarButton sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://159.75.1.231:5009%@",itemForThisRow.userItem.avatarURL]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"edvard-munch.png"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 280;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger i = indexPath.row;
    int contentID = [self.contentItems[i] contentID];
    
    NSString *URL = [NSString stringWithFormat:@"http://159.75.1.231:5009/contents/%d", contentID];
    NSDictionary *header = @{
        @"Authorization":[UserInfo sharedUser].token
    };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:URL parameters:nil headers:header progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *response = (NSDictionary *)responseObject;
        if([response[@"status"] isEqualToString:@"success"])
        {
            DetailedContentItem *detailedContentItem = [[DetailedContentItem alloc]initWithDict:response[@"data"]];
            [self.navigationController pushViewController:[[VideoPageViewController alloc] initWithContentItem:detailedContentItem] animated:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"get contentItem faied");
    }];
    
    
}

- (void)loadData
{
//    NSString *URL = @"http://159.75.1.231:5009/contents";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary *header = @{
        @"Authorization":[UserInfo sharedUser].token
    };
    
    
    [manager GET:self.serviceURL parameters:@{@"num":@(_contentNum)} headers:header progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *response = (NSDictionary *)responseObject;
        if([response[@"status"] isEqualToString:@"success"])
        {
            NSLog(@"success, data: %@",response);
            self.contentItems = [NSMutableArray new];
            NSArray *data = response[@"data"];
            for(int i = 0; i < [data count]; i++)
            {
                BriefContentItem *newItem = [[BriefContentItem alloc]initWithDict:data[i]];
                [self.contentItems addObject:newItem];
            }
        }
        [self.tableView reloadData];
        if([self.tableView.mj_header isRefreshing]) [self.tableView.mj_header endRefreshing];
        if([self.tableView.mj_footer isRefreshing]) [self.tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed to get contents");
    }];
    
}

- (void)addMJRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)loadMoreData
{
    _contentNum += 5;
    [self loadData];
}
@end
