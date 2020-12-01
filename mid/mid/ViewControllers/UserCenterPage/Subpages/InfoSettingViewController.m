//
//  SettingTableViewController.m
//  mid
//
//  Created by itlab on 11/29/20.
//

#import "InfoSettingViewController.h"
#import "TabBarController.h"
#import "UserInfo.h"
#import <AFNetworking/AFNetworking.h>
@interface InfoSettingViewController ()
@property (nonatomic, strong) UITextField *textField;
@end

@implementation InfoSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [UserInfo updateUserInfo];
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserInfo *userInfo = [UserInfo sharedUser];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                                   reuseIdentifier:nil];
    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text = @"用户名";
            cell.detailTextLabel.text = userInfo.name;
            break;
        case 1:
            cell.textLabel.text = @"邮箱";
            cell.detailTextLabel.text = userInfo.email;
            break;
        case 2:
            cell.textLabel.text = @"Bio";
            cell.detailTextLabel.text = userInfo.bio;
            break;
        case 3:
            cell.textLabel.text = @"性别";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",userInfo.gender];
            break;
        case 4:
            cell.textLabel.text = @"Nick Name";
            cell.detailTextLabel.text = @"None";
            break;
        case 5:
            cell.textLabel.text = @"班级";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",userInfo.classNum];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger i = indexPath.row;
    NSArray *array = @[@"用户名",@"邮箱",@"Bio",@"性别",@"Nick Name",@"班级"];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"修改%@", array[i]] message:[NSString stringWithFormat:@"输入新的%@", array[i]] preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"20个字符以内";
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if(i == 0)
        {
            NSArray *textfields = alertController.textFields;
            UITextField * namefield = textfields[0];
            NSLog(@"%@",namefield.text);
            [self changeUserName:namefield.text];
        }
        else
        {
            [self Alert:[NSString stringWithFormat:@"暂不支持修改%@", array[i]]];
        }
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

# pragma mark 改名
- (void)changeUserName:(NSString *)newName
{
    NSString *URL = @"http://172.18.178.56/api/user/name";
    NSDictionary *body = @{@"name":newName};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:URL parameters:body headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *response = (NSDictionary *)responseObject;
        if([response[@"State"] isEqualToString:@"success"])
        {
            [self Alert:@"改名成功"];
        }
        else
        {
            [self Alert:@"更改用户名失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"request failure");
    }];
}

# pragma mark 提示
- (void)Alert:(NSString *)msg
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    
    // 显示对话框
    [self presentViewController:alert animated:true completion:nil];
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

@end
