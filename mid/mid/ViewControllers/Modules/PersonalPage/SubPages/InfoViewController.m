//
//  infoTableViewController.m
//  mid
//
//  Created by itlab on 11/28/20.
//

#import "InfoViewController.h"

@interface InfoViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIView *avatorView;
@property (nonatomic, strong) UITableView *infoView;
@property (nonatomic) CGFloat w;
@property (nonatomic) CGFloat h;
@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    // 计算无遮挡页面尺寸
    UIWindow *window = UIApplication.sharedApplication.windows[0];
    CGRect safe = window.safeAreaLayoutGuide.layoutFrame;
    _w = safe.size.width;
    _h = safe.size.height;
    
    [self.view addSubview:self.avatorView];
    [self.view addSubview:self.infoView];
    
}

- (UIView *)avatorView
{
    if(_avatorView == nil)
    {
        _avatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _w, 160)];
        UIImageView *avator = [[UIImageView alloc] initWithFrame:CGRectMake(_w/2 - 45, 35, 90, 90)];
        avator.image = [UIImage imageNamed:@"testPortrait.jpg"];
        avator.layer.cornerRadius = 45;
        avator.layer.masksToBounds = YES;
        avator.layer.borderWidth = 1;
        [_avatorView addSubview:avator];
    }
    return _avatorView;
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
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
