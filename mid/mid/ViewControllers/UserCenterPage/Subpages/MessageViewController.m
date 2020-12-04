//
//  MessageViewController.m
//  mid
//
//  Created by itlab on 11/29/20.
//

#import "MessageViewController.h"
#import "FullNotificationItem.h"
#import "NotificationItem.h"
#import "MiniUserItem.h"
#import <AFNetworking/AFNetworking.h>

@interface MessageViewController ()
@property (nonatomic) NSMutableArray *likeItems;
@property (nonatomic) NSMutableArray *replyItems;
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self loadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0)return [_likeItems count];
    return [_replyItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                                   reuseIdentifier:nil];
    NSInteger sec = indexPath.section;
    NSInteger row = indexPath.row;
    
    UIColor *unread = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    
    if(sec == 0)
    {
        FullNotificationItem *thisItem = _likeItems[row];
        NSString *userName = [thisItem userItem].userName;
        UIImage *avatar = [thisItem userItem].avatar;
        NSString *time = [self timeStampToTime:[thisItem notificationItem].createTime];
        
        [cell.textLabel setText:[NSString stringWithFormat:@" %@ 点赞了你的内容", userName]];
        [cell.imageView setImage:avatar];
        [cell.detailTextLabel setText:time];
        
        if(thisItem.notificationItem.read == NO)
            [cell setBackgroundColor:unread];
        else
            [cell setBackgroundColor:[UIColor whiteColor]];
    }
    else if(sec == 1)
    {
        FullNotificationItem *thisItem = _replyItems[row];
        NSString *userName = [thisItem userItem].userName;
        NSString *content = [thisItem notificationItem].notificationContent;
        UIImage *avatar = [thisItem userItem].avatar;
        NSString *time = [self timeStampToTime:[thisItem notificationItem].createTime];
        
        [cell.textLabel setText:[NSString stringWithFormat:@" %@ 评论你: %@", userName, content]];
        [cell.imageView setImage:avatar];
        [cell.detailTextLabel setText:time];
        
        if(thisItem.notificationItem.read == NO)
            [cell setBackgroundColor:unread];
        else
            [cell setBackgroundColor:[UIColor whiteColor]];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 标记为已读
    NSInteger sec = indexPath.section;
    NSInteger row = indexPath.row;
    
    FullNotificationItem *thisItem = nil;
    if(sec == 0) thisItem = _likeItems[row];
    else thisItem = _replyItems[row];
    
    NSString *notificationID = thisItem.notificationItem.notificationID;
    NSString *URL = [NSString stringWithFormat:@"http://172.18.178.56/api/notification/read/%@",notificationID];
    
    NSDictionary *body = @{
        @"isRead" : @YES
    };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager PATCH:URL parameters:body headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed to patch somehow");
    }];
    
    [[tableView cellForRowAtIndexPath:indexPath] setBackgroundColor:[UIColor whiteColor]];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *sectionNames = @[@"点赞通知",@"回复通知"];
    return sectionNames[section];
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
    NSString *URL = @"http://172.18.178.56/api/notification/all";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:URL parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSLog(@"%@",responseObject);
            NSDictionary *response = (NSDictionary *)responseObject;
            if([response[@"State"] isEqualToString:@"success"])
            {
                self.likeItems = [NSMutableArray new];
                self.replyItems = [NSMutableArray new];
                NSArray *data = response[@"Notification"];
                NSInteger n = [data count];
                for(int i = 0; i < n; i++)
                {
                    FullNotificationItem *newItem = [[FullNotificationItem alloc]initWithDict:data[i]];
                    if([newItem.notificationItem.notificationType isEqualToString:@"like"])
                    {
                        [self.likeItems addObject:newItem];
                    }
                    else if([newItem.notificationItem.notificationType isEqualToString:@"reply"])
                    {
                        [self.replyItems addObject:newItem];
                    }
                }
                [self.likeItems sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    FullNotificationItem *item1 = (FullNotificationItem *)obj1;
                    return item1.notificationItem.read;
                }];
            }
            [self.tableView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"failed to fetch notifications somehow");
        }];
}

@end
