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
#import "TimeTool.h"
@interface VideoListTableViewController ()

@end

@implementation VideoListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // 注册
    UINib *nib = [UINib nibWithNibName:@"VideoListTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"VideoListTableViewCell"];
    [self.tableView setBounces:NO];
    
    // 样式
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadData)];
        
    
    
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


- (void)loadData
{
    NSString *URL = @"http://159.75.1.231:5009/contents";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary *header = @{
        @"Authorization":@"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6IkFsaWNlIn0.qQ2aj4ME0Vm-Kppv4-H-FAe6aLqCu4JNEtmCVKkfFII"
    };
    
    [manager GET:URL parameters:nil headers:header progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed to get contents");
    }];
    
}

@end
