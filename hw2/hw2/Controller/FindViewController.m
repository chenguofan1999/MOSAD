//
//  FindViewController.m
//  hw2
//
//  Created by itlab on 2020/10/28.
//  Copyright © 2020 itlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FindViewController.h"
#import "AppDelegate.h"
#import "DetailViewController.h"

@interface FindViewController()<UISearchBarDelegate>
@property (strong, nonatomic) UISearchBar *searchBar;

@end

@implementation FindViewController


- (instancetype)init
{
    // UITableViewController 的默认初始化方法是 initWithStyle:
    if(self = [super initWithStyle:UITableViewStyleGrouped])
    {
        self.view.backgroundColor = [UIColor whiteColor];
        
        // 设置 tab 栏样式
        self.tabBarItem.title = @"发现";
        
        UIImage *icon1 = [UIImage imageNamed:@"search-off@2x.png"];
        self.tabBarItem.image = icon1;
        UIImage *icon2 = [UIImage imageNamed:@"search-on@2x.png"];
        self.tabBarItem.selectedImage = icon2;
        
        // 设置 table 样式
        self.tableView.estimatedRowHeight = 70.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.navigationItem.hidesSearchBarWhenScrolling = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:[NSString stringWithFormat:@"打卡清单"]];
    // 延迟加载搜索框
    [self.view addSubview:self.searchBar];
    self.tableView.tableHeaderView = self.searchBar;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    AppDelegate *myDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [myDelegate sortItems];
    
    // 注意 每一次显示发现页面时需要重新加载数据源
    [self.tableView reloadData];
}


#pragma mark 搜索栏样式
// 延迟加载搜索栏
- (UISearchBar *)searchBar
{
    if(!_searchBar)
    {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
        // 消除搜索框的不必要的背景颜色
        UIImage* clearColor = [FindViewController GetImageWithColor:[UIColor clearColor] Height:35];
        _searchBar.delegate = self;
        [_searchBar setBackgroundImage:clearColor];
        //[_searchBar setShowsCancelButton:YES animated:YES];
    }
    return _searchBar;
}

/**
 *  生成图片
 *
 *  @param color  图片颜色
 *  @param height 图片高度
 *
 *  @return 生成的图片
 *  （这里用于生成透明背景图，去掉搜索框的背景色）
 */
+ (UIImage*) GetImageWithColor:(UIColor*)color Height:(CGFloat)height
{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

#pragma mark 搜索栏功能
// 按下搜索时
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *input = [searchBar text];
    AppDelegate *myDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSInteger n = [myDelegate.items count];
    for(int i = 0; i < n; i++)
    {
        NSString *brief = [[myDelegate.items objectAtIndex:i] getBriefInfo];
        if([brief rangeOfString:input].location != NSNotFound)
        {
            [self foundAt:i withBrief:brief];
            return;
        }
    }
    [self NotFoundAlert];
}

- (void)foundAt:(int)i withBrief:(NSString *)brief {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"找到了！"
                                                                   message:brief
                                                            preferredStyle:UIAlertControllerStyleAlert];
    // 增加查看选项
    [alert addAction:[UIAlertAction actionWithTitle:@"查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        DetailViewController *dvc = [[DetailViewController alloc] initWithIndex:(int)i];
        [self.navigationController pushViewController:dvc animated:YES];
    }]];
    
    // 增加取消选项
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];

    // 显示对话框
    [self presentViewController:alert animated:true completion:nil];
}

- (void)NotFoundAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:@"没找到"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    
    // 显示对话框
    [self presentViewController:alert animated:true completion:nil];
}




#pragma mark - UITableViewDataSource
// 返回 section 的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// 返回每个 Section 中的 Cell 个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppDelegate *myDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    return [myDelegate.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *myDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSInteger i = indexPath.row;
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                   reuseIdentifier:nil];
    cell.textLabel.text = [myDelegate.items[i] getBriefInfo];
    cell.imageView.image = [myDelegate.items[i] displayedInFindView];
    
    if(indexPath.row % 2 == 1)
    {
        cell.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger i = indexPath.row;
    DetailViewController *dvc = [[DetailViewController alloc] initWithIndex:(int)i];
    [self.navigationController pushViewController:dvc animated:YES];
}

#pragma mark 动画 和 边框
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    // 一开始比较小
//    cell.layer.transform = CATransform3DMakeScale(0.4, 0.4, 1);
//
//    // 动画时间为0.5秒,缩放回正常大小
//    [UIView animateWithDuration:0.5 animations:^{cell.layer.transform = CATransform3DMakeScale(1, 1, 1);}];
//
//
//    // 边框
//    [cell.contentView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
//    [cell.contentView.layer setBorderWidth:0.5];
//    cell.contentView.layer.cornerRadius = 10;
//    cell.contentView.layer.masksToBounds = YES;
//}

@end
