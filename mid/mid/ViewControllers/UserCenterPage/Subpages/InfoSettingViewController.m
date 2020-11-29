//
//  SettingTableViewController.m
//  mid
//
//  Created by itlab on 11/29/20.
//

#import "InfoSettingViewController.h"

@interface InfoSettingViewController ()
@property (nonatomic, strong) UITextField *textField;
@end

@implementation InfoSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                                   reuseIdentifier:nil];
    
    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text = @"用户名";
            cell.detailTextLabel.text = @"Chen";
            break;
        case 1:
            cell.textLabel.text = @"邮箱";
            cell.detailTextLabel.text = @"chen2027@gmail.com";
            break;
        case 2:
            cell.textLabel.text = @"Bio";
            cell.detailTextLabel.text = @"Na";
            break;
        case 3:
            cell.textLabel.text = @"性别";
            cell.detailTextLabel.text = @"0";
            break;
        case 4:
            cell.textLabel.text = @"Nick Name";
            cell.detailTextLabel.text = @"None";
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
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
//                                                   reuseIdentifier:nil];
//    switch (indexPath.row)
//    {
//        case 0:
//            cell.textLabel.text = @"用户名";
//            cell.detailTextLabel.text = @"Chen";
//            break;
//        case 1:
//            cell.textLabel.text = @"邮箱";
//            cell.detailTextLabel.text = @"chen2027@gmail.com";
//            break;
//        case 2:
//            cell.textLabel.text = @"Bio";
//            cell.detailTextLabel.text = @"Na";
//            break;
//        case 3:
//            cell.textLabel.text = @"性别";
//            cell.detailTextLabel.text = @"0";
//            break;
//        case 4:
//            cell.textLabel.text = @"Nick Name";
//            cell.detailTextLabel.text = @"None";
//            break;
//    }
    NSInteger i = indexPath.row;
    NSArray *array = @[@"用户名",@"邮箱",@"Bio",@"性别",@"Nick Name"];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"修改%@",array[i]] message:[NSString stringWithFormat:@"输入新的%@", array[i]] preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"不要太长";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray *textfields = alertController.textFields;
        UITextField * namefield = textfields[0];
        NSLog(@"%@",namefield.text);
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
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
