//
//  InfoPageViewController.m
//  hw3
//
//  Created by itlab on 12/7/20.
//

#import "InfoPageViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface InfoPageViewController ()
@property (nonatomic) NSString *userLevel;
@property (nonatomic) NSString *userEmail;
@property (nonatomic) NSString *userPhone;
@end

@implementation InfoPageViewController
- (instancetype)initWithUserName:(NSString *)username
{
    self = [super init];
    _userName = username;
    _userLevel = @"";
    _userEmail = @"";
    _userPhone = @"";
    
//    self.tabBarItem = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemContacts tag:0];
    self.tabBarItem.title = @"Info";
    self.tabBarItem.image = [UIImage imageNamed:@"user@2x.png"];
    self.tabBarItem.selectedImage =[UIImage imageNamed:@"user-filled@2x.png"];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGFloat w = [[UIScreen mainScreen] bounds].size.width;
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, w, 80)];
    headerLabel.text = @"  Info";
    headerLabel.font = [UIFont boldSystemFontOfSize:32];
    [headerLabel setBackgroundColor:[UIColor lightGrayColor]];
    self.tableView.tableHeaderView = headerLabel;
    [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    
    [self loadData];
}

- (void)loadData
{
    NSString *URL = [NSString stringWithFormat:@"http://172.18.176.202:3333/hw3/getinfo?name=%@", _userName];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:URL parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"request success: %@", responseObject);
        NSDictionary *response = (NSDictionary *)responseObject;
        self.userLevel = response[@"level"];
        self.userEmail = response[@"email"];
        self.userPhone = response[@"phone"];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Failed to get info");
    }];
}


# pragma mark TableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"infoCell"];
    NSInteger i = indexPath.row;
    NSArray *keys = @[@"Name",@"Level",@"Email",@"Phone"];
    NSArray *vals = @[_userName, _userLevel, _userEmail, _userPhone];
    [cell.textLabel setText:keys[i]];
    [cell.detailTextLabel setText:vals[i]];
    return cell;
}

# pragma mark TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

@end
