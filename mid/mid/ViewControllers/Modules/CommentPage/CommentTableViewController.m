//
//  CommentTableViewController.m
//  mid
//
//  Created by itlab on 11/28/20.
//

#import "CommentTableViewController.h"
#import "CommentCell.h"
#import <AFNetworking/AFNetworking.h>
#import "FullCommentItem.h"

@interface CommentTableViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UILabel *header;
@end

@implementation CommentTableViewController

- (instancetype)initWithContentID:(NSString *)contentID
{
    self = [super init];
    _contentID = contentID;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    CGFloat w = [[UIScreen mainScreen] bounds].size.width;
    _header = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, w, 80)];
    _header.text = @"  评论";
    _header.font = [UIFont boldSystemFontOfSize:30];
    self.tableView.tableHeaderView = _header;
    
    UINib *nib = [UINib nibWithNibName:@"CommentCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"CommentCell"];
    
    [self loadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return [_commentItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    
    NSInteger i = indexPath.row;
    cell.userNameLable.text = [_commentItems[i] userName];
    cell.textContentLable.text = [_commentItems[i] commentContent];
    cell.timeLable.text = [self timeStampToTime:[_commentItems[i] publishDate]];
    
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

#pragma mark 从后台拉取评论数据
- (void)loadData
{
    NSString *URL = [NSString stringWithFormat:@"http://172.18.178.56/api/comment/%@", _contentID];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:URL parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDict = (NSDictionary *)responseObject;
        NSLog(@"%@",responseDict);
        if([responseDict[@"State"] isEqualToString:@"success"])
        {
            self.commentItems = [NSMutableArray new];
            NSArray *data = responseDict[@"Data"];
            if((NSNull *)data != [NSNull null])
            {
                NSInteger n = [data count];
                for(int i = 0; i < n; i++)
                {
                    FullCommentItem *newItem = [[FullCommentItem alloc] initWithDict:data[i]];
                    [self.commentItems addObject:newItem];
                }
            }
        }
        else
        {
            NSLog(@"You might have mistaken the contentID");
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Get comments failed somehow");
    }];
}


@end
