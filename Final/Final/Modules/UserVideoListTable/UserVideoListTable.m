//
//  UserVideoListTable.m
//  Final
//
//  Created by itlab on 1/7/21.
//

#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/SDWebImage.h>
#import <MaterialButtons+Theming.h>
#import <Masonry/Masonry.h>

#import "UserInfo.h"
#import "TimeTool.h"
#import "OrderedVideoListTable.h"
#import "BriefContentItem.h"
#import "OrderedVideoListTableCell.h"
#import "VideoPageViewController.h"
@interface OrderedVideoListTable () <UITableViewDelegate>
// headview
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIButton *modeButton;
@property (nonatomic, strong) UILabel *modeLabel;
@property (nonatomic, strong) UILabel *headerTitle;

// data
@property (nonatomic) OrderedVideoListTableType tableType;
@property (nonatomic) NSMutableArray *videoItems;
@property (nonatomic) NSMutableDictionary *queryParams;
@property (nonatomic) UserVideoListTableOrderMode orderMode;
@property (nonatomic) NSString *baseURL;
@end

@implementation OrderedVideoListTable
- (instancetype)initWithUserName:(NSString *)username
{
    self = [super init];
    self.queryParams = [NSMutableDictionary dictionary];
    [self.queryParams setValue:username forKey:@"user"];
    self.tableType = OrderedVideoListTableTypeUser;
    self.orderMode = UserVideoListTableOrderByTimeDesc;
    return self;
}

- (instancetype)initAsHistory
{
    self = [super init];
    self.queryParams = [NSMutableDictionary new];
    [self.queryParams setValue:@"true" forKey:@"history"];
    self.tableType = OrderedVideoListTableTypeHistory;
    self.orderMode = UserVideoListTableOrderByTimeDesc;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注册
    UINib *nib = [UINib nibWithNibName:@"OrderedVideoListTableCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"OrderedVideoListTableCell"];

    self.baseURL = @"http://159.75.1.231:5009/contents";
    
    [self.tableView setTableHeaderView:self.headerView];
    
    [self loadData];
}

- (UIView *)headerView
{
    if(_headerView == nil)
    {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        [_headerView addSubview:self.modeButton];
        [_headerView addSubview:self.modeLabel];
        [_headerView addSubview:self.headerTitle];
        [self.modeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headerView);
            make.right.equalTo(_headerView).offset(-10);
        }];
        
        [self.modeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headerView);
            make.right.mas_equalTo(self.modeLabel.mas_left).offset(-5);
            make.size.mas_equalTo(CGSizeMake(22, 22));
        }];
        
        [self.headerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headerView);
            make.left.equalTo(_headerView).offset(15);
        }];
    }
    return  _headerView;
}

- (UIButton *)modeButton
{
    if(_modeButton == nil)
    {
        _modeButton = [[UIButton alloc]init];
        [_modeButton setTintColor:[UIColor grayColor]];
        [_modeButton setImage:[[UIImage imageNamed:@"descending.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_modeButton addTarget:self action:@selector(changeSortingMode) forControlEvents:UIControlEventTouchUpInside];
    }
    return _modeButton;
}

- (UILabel *)modeLabel
{
    if(_modeLabel == nil)
    {
        _modeLabel = [[UILabel alloc]init];
        [_modeLabel setTextColor:[UIColor grayColor]];
        [_modeLabel setFont:[UIFont systemFontOfSize:16]];
        [_modeLabel setUserInteractionEnabled:YES];
        [_modeLabel setText:@"By Time"];
        [_modeLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeSortingMode)]];
    }
    return _modeLabel;
}

- (UILabel *)headerTitle
{
    if(_headerTitle == nil)
    {
        _headerTitle = [[UILabel alloc]init];
        [_headerTitle setText:@"Uploads"];
        [_headerTitle setFont:[UIFont boldSystemFontOfSize:24]];
    }
    return _headerTitle;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.videoItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderedVideoListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderedVideoListTableCell" forIndexPath:indexPath];
    BriefContentItem *itemForThisRow = self.videoItems[indexPath.row];
    
    // cover image
    [cell.coverView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://159.75.1.231:5009%@",itemForThisRow.coverURL]] placeholderImage:[UIImage imageNamed:@"Yourtube2.png"]];
    
    // title label
    [cell.videoTitleLabel setText:itemForThisRow.title];
    
    // info label
    switch (self.tableType) {
        case OrderedVideoListTableTypeUser:
            [cell.videoInfoLabel setText:[NSString stringWithFormat:@"%d views · %@"
                                          , itemForThisRow.viewNum
                                          , [TimeTool timeBeforeInfoWithString:itemForThisRow.createTime]]];
            break;
        case OrderedVideoListTableTypeHistory:
            [cell.videoInfoLabel setText:[NSString stringWithFormat:@"%@\n%d views · %@"
                                          , itemForThisRow.userItem.userName
                                          , itemForThisRow.viewNum
                                          , [TimeTool timeBeforeInfoWithString:itemForThisRow.createTime]]];
            break;
        default:
            break;
    }
    
    // duration label
    [cell.durationLabel setText:[TimeTool durationInSecondsToString:itemForThisRow.duration]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger i = indexPath.row;
    int contentID = [self.videoItems[i] contentID];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 128;
}

#pragma mark Order
- (void)changeSortingMode
{
    self.orderMode = (self.orderMode + 1) % 4;
    [self configQueryParams];
    [self loadData];
}

- (void)configQueryParams
{
    switch (self.orderMode) {
        case UserVideoListTableOrderByTimeDesc:
            [self.queryParams setValue:@"time" forKey:@"orderBy"];
            [self.queryParams setValue:@"desc" forKey:@"order"];
            [self.modeButton setImage:[[UIImage imageNamed:@"descending.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            [_modeLabel setText:@"By Time"];
            break;
        case UserVideoListTableOrderByTimeAsc:
            [self.modeButton setImage:[[UIImage imageNamed:@"ascending.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            [_modeLabel setText:@"By Time"];
            [self.queryParams setValue:@"time" forKey:@"orderBy"];
            [self.queryParams setValue:@"asc" forKey:@"order"];
            break;
        case UserVideoListTableOrderByViewNumDesc:
            [self.modeButton setImage:[[UIImage imageNamed:@"ascending.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            [_modeLabel setText:@"By View"];
            [self.queryParams setValue:@"viewNum" forKey:@"orderBy"];
            [self.queryParams setValue:@"desc" forKey:@"order"];
            break;
        case UserVideoListTableOrderByViewNumAsc:
            [self.modeButton setImage:[[UIImage imageNamed:@"descending.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            [_modeLabel setText:@"By View"];
            [self.queryParams setValue:@"viewNum" forKey:@"orderBy"];
            [self.queryParams setValue:@"asc" forKey:@"order"];
            break;
        default:
            break;
    }
}

#pragma mark loadData
- (void)loadData
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary *header = @{
        @"Authorization":[UserInfo sharedUser].token
    };
    
    [manager GET:self.baseURL parameters:self.queryParams headers:header progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *response = (NSDictionary *)responseObject;
        if([response[@"status"] isEqualToString:@"success"])
        {
            self.videoItems = [NSMutableArray new];
            NSArray *data = response[@"data"];
            for(int i = 0; i < [data count]; i++)
            {
                BriefContentItem *newItem = [[BriefContentItem alloc]initWithDict:data[i]];
                [self.videoItems addObject:newItem];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed to get contents");
    }];
}

#pragma mark scroll delegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//
//}

@end
