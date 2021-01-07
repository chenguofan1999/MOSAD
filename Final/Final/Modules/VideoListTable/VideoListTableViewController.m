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
#import "UserPageViewController.h"
#import "OrderedVideoListTable.h"
@interface VideoListTableViewController ()
@property (nonatomic) int contentNum;
@end

@implementation VideoListTableViewController
- (instancetype)initWithURL:(NSString *)URL
{
    self = [super init];
    self.serviceURL = URL;
    self.contentNum = 10;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // delegate
    self.tableView.delegate = self;
    
    // 注册
    UINib *nib = [UINib nibWithNibName:@"VideoListTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"VideoListTableViewCell"];

    
    // 样式
    //    [self.tableView setBounces:NO];
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
    [cell.coverImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://159.75.1.231:5009%@",itemForThisRow.coverURL]] placeholderImage:[UIImage imageNamed:@"Yourtube4.png"]];
    [cell.avatarButton sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://159.75.1.231:5009%@",itemForThisRow.userItem.avatarURL]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"edvard-munch.png"]];
    [cell.avatarButton setTag:indexPath.row];
    [cell.avatarButton addTarget:self action:@selector(avatarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // duration label
    [cell.durationLabel setText:[TimeTool durationInSecondsToString:itemForThisRow.duration]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 290;
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
        NSLog(@"Detailed contentItem: %@", responseObject);
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

#pragma mark 点击头像
- (void)avatarButtonClicked:(UIButton *)btn
{
    NSInteger i = btn.tag;
    NSString *username = [self.contentItems[i] userItem].userName;
    UserPageViewController *userPage = [[UserPageViewController alloc]initWithUsername:username];
    [self.navigationController pushViewController:userPage animated:YES];
}

#pragma mark delegata
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"%lf %lf",scrollView.contentOffset.y,[scrollView.panGestureRecognizer velocityInView:scrollView].y);
//    CGPoint vel = [scrollView.panGestureRecognizer velocityInView:scrollView];
    if(scrollView.contentOffset.y > 140)
    {
        if([self.customDelegate respondsToSelector:@selector(slideDown)])
        {
            [self.customDelegate slideDown];
        }
    }
    else
    {
        if([self.customDelegate respondsToSelector:@selector(slideUp)])
        {
            [self.customDelegate slideUp];
        }
    }

}

@end
