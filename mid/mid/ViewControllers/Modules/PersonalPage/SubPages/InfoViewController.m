//
//  infoTableViewController.m
//  mid
//
//  Created by itlab on 11/28/20.
//

#import "InfoViewController.h"
#import <AFNetworking/AFNetworking.h>
@interface InfoViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIView *avatarView;
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UITableView *infoView;
@property (nonatomic) CGFloat w;
@property (nonatomic) CGFloat h;
@property (nonatomic) UserItem *userItem;
@end

@implementation InfoViewController

- (instancetype)initWithUserID:(NSString *)userID;
{
    self = [super init];
    _userID = userID;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // 计算无遮挡页面尺寸
    UIWindow *window = UIApplication.sharedApplication.windows[0];
    CGRect safe = window.safeAreaLayoutGuide.layoutFrame;
    _w = safe.size.width;
    _h = safe.size.height;
    
    [self.view addSubview:self.avatarView];
    [self.view addSubview:self.infoView];
    
    [self loadData];
}

- (UIView *)avatarView
{
    if(_avatarView == nil)
    {
        _avatarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _w, 160)];
        _avatar = [[UIImageView alloc] initWithFrame:CGRectMake(_w/2 - 45, 35, 90, 90)];
        _avatar.image = [UIImage imageNamed:@"testPortrait.jpg"];
        _avatar.layer.cornerRadius = 45;
        _avatar.layer.masksToBounds = YES;
        _avatar.layer.borderWidth = 0;
        [_avatarView addSubview:_avatar];
    }
    return _avatarView;
}

- (UITableView *)infoView
{
    if(_infoView == nil)
    {
        _infoView = [[UITableView alloc]initWithFrame:CGRectMake(0, 160, _w, _h - 160)];
        _infoView.delegate = self;
        _infoView.dataSource = self;
    }
    return _infoView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                   reuseIdentifier:nil];
    
    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text = @"用户名";
            cell.detailTextLabel.text = _userItem.userName;
            break;
        case 1:
            cell.textLabel.text = @"邮箱";
            cell.detailTextLabel.text = _userItem.email;
            break;
        case 2:
            cell.textLabel.text = @"Bio";
            cell.detailTextLabel.text = _userItem.bio;
            break;
        case 3:
            cell.textLabel.text = @"性别";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", _userItem.gender];
            break;
        case 4:
            cell.textLabel.text = @"Nick Name";
            cell.detailTextLabel.text = @"Nick";
            break;
    }

    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"个人信息";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (void)loadData
{
    NSString *URL = [NSString stringWithFormat:@"%@%@",@"http://172.18.178.56/api/user/info/",_userID];
//    NSLog(@"URL: %@:",URL);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:URL parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@", responseObject);
        NSDictionary *dict = (NSDictionary *)responseObject;
        self.userItem = [[UserItem alloc]initWithDict:dict];
        [self.infoView reloadData];
        [self.avatar setImage:[self.userItem avatar]];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed somehow");
    }];
}

@end
