//
//  PostViewController.m
//  mid
//
//  Created by itlab on 11/26/20.
//

#import "PostViewController.h"
#import "BigImageViewController.h"
#import "PostCell.h"
#import "CommentTableViewController.h"

@interface PostViewController ()

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - UITableViewDataSource

// section 个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Section 中的 Cell 个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

// cell 的具体属性
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 以下代码得到一个 PostCell, 几乎没有数据，需要赋值。
    // 有复用版本
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PostCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    // 无复用版本
//    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PostCell" owner:self options:nil];
//    PostCell *cell = [topLevelObjects objectAtIndex:0];
    
    // 设置数据
//    [cell setVal:..];

    // 设置Block（点击略缩图事件）
    cell.showImageBlock = ^(UIImage *img){
        BigImageViewController *bivc = [[BigImageViewController alloc] init];
        bivc.view.backgroundColor = [UIColor blackColor];
        bivc.image = img;
        //[self.navigationController pushViewController:bivc animated:YES];
        [self presentViewController:bivc animated:YES completion:nil];
    };

    // 为buttons设置事件
    [cell.likeButton addTarget:self action:@selector(likePost:) forControlEvents:UIControlEventTouchUpInside];
    [cell.favButton addTarget:self action:@selector(favPost:) forControlEvents:UIControlEventTouchUpInside];
    [cell.commentButton addTarget:self action:@selector(showCommentPage:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteButton setHidden:YES];
    
    // for test use
    [cell addPic:[UIImage imageNamed:@"testPic.jpg"]];
    
    return cell;
}

// 选中 cell 的效果
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{}

// 取消选中 cell 的效果
//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{}
#pragma mark 喜欢button
- (void)favPost:(UIButton *)btn
{
    UIView *contentView = [btn superview];
    PostCell *cell = (PostCell *)[contentView superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    // 已经得到indexPath
    NSLog(@"press fav button at row %ld", indexPath.row);
}


#pragma mark 点赞button
- (void)likePost:(UIButton *)btn
{
    UIView *contentView = [btn superview];
    PostCell *cell = (PostCell *)[contentView superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    // 已经得到indexPath
    NSLog(@"press like button at row %ld", indexPath.row);
}



#pragma mark 评论区button
- (void)showCommentPage:(UIButton *)btn
{
    UIView *contentView = [btn superview];
    PostCell *cell = (PostCell *)[contentView superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    // 已经得到indexPath
    NSLog(@"press comment button at row %ld", indexPath.row);
//    [self.navigationController pushViewController:[CommentTableViewController new] animated:NO];
    [self presentViewController:[CommentTableViewController new] animated:YES completion:nil];
}

@end
