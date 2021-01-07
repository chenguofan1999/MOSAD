//
//  UserListTableViewController.m
//  Final
//
//  Created by itlab on 1/7/21.
//

#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/SDWebImage.h>
#import "UserListTableViewController.h"
#import "UserListTableViewCell.h"
#import "UserPageViewController.h"
#import "MiniUserItem.h"


@interface UserListTableViewController ()
@property (nonatomic) UserListTableType userListTableType;
@property (nonatomic) NSString *username;
@property (nonatomic) NSString *URL;
@property (nonatomic) NSMutableArray *userItems;
@end

NSString static *reuseIdentifier = @"cell";

@implementation UserListTableViewController
- (instancetype)initWithUsername:(NSString *)username type:(UserListTableType)type
{
    self = [super initWithStyle:UITableViewStylePlain];
    self.username = username;
    self.userListTableType = type;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注册
    UINib *nib = [UINib nibWithNibName:@"UserListTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:reuseIdentifier];
    
    [self loadData];
    [self.tableView setTableFooterView:[UIView new]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.userItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];

    MiniUserItem *itemForThisCell = self.userItems[indexPath.row];
    
    [cell.usernameLabel setText: itemForThisCell.userName];
    [cell.subscriberLabel setText:[NSString stringWithFormat:@"%d subscribers",itemForThisCell.followerNum]];
    [cell.avatarView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://159.75.1.231:5009%@", itemForThisCell.avatarURL]]  placeholderImage:[UIImage imageNamed:@"edvard-munch.png"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *username = [self.userItems[indexPath.row] userName];
    UserPageViewController *userPage = [[UserPageViewController alloc]initWithUsername:username];
    [self.navigationController pushViewController:userPage animated:YES];
}
    
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}
//
//
//
//// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }
//}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark load data
- (void)loadData
{
    NSString *URL;
    if(self.userListTableType == UserListTableTypeFollowing)
        URL = [NSString stringWithFormat:@"http://159.75.1.231:5009/users/%@/following",self.username];
    else
        URL = [NSString stringWithFormat:@"http://159.75.1.231:5009/users/%@/followers",self.username];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:URL parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *response = (NSDictionary *)responseObject;
        if([response[@"status"] isEqualToString:@"success"])
        {
            NSArray *data = response[@"data"];
            self.userItems = [NSMutableArray new];
            for(int i = 0; i < [data count]; i++)
            {
                MiniUserItem *newItem = [[MiniUserItem alloc]initWithDict:data[i]];
                [self.userItems addObject:newItem];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed to get user list");
    }];
}
@end
