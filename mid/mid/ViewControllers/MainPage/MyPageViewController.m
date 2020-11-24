//
//  MyPageViewController.m
//  mid
//
//  Created by itlab on 2020/11/23.
//

#import "MyPageViewController.h"
#import "WritingPostViewController.h"
#import "PostCell.h"

@interface MyPageViewController ()<UISearchBarDelegate>
@property (strong, nonatomic) UISearchBar *searchBar;
@property (nonatomic) Mode mode;
@end

@implementation MyPageViewController


- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    // 页面样式
    self.view.backgroundColor = [UIColor whiteColor];
    
    // TabBar项中的样式
    [[self tabBarItem] setTitle:@"主页"];
    [self.tabBarItem setImage:[UIImage imageNamed:@"compass@2x.png"]];
    [self.tabBarItem setSelectedImage:[UIImage imageNamed:@"compass-filled@2x.png"]];

    /** 导航栏中的样式
     * 右侧按钮用于切换模式（我的 / 我关注的）
     * 左侧按钮用于发布
     */
    
    // 右侧按钮
    UIBarButtonItem *rightButtuon = [[UIBarButtonItem alloc]initWithTitle:@"switch"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(switchMode)];
    [self.navigationItem setRightBarButtonItem:rightButtuon];
    [self switchToMine];
    
    // 左侧按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithTitle:@"post"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(post)];
    [leftButton setImage:[UIImage imageNamed:@"add@2x.png"]];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 延迟加载搜索框
    [self.view addSubview:self.searchBar];
    self.tableView.tableHeaderView = self.searchBar;
    
    // 注册 nib 文件
    UINib *nib = [UINib nibWithNibName:@"PostCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"PostCell"];
}


#pragma mark 搜索栏
// 延迟加载搜索栏
- (UISearchBar *)searchBar
{
    if(!_searchBar)
    {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
        // 消除搜索框的不必要的背景颜色
        UIImage* clearColor = [MyPageViewController GetImageWithColor:[UIColor clearColor] Height:35];
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

// cell 高度
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 120;
//}

// cell 的具体属性
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    if (cell == nil) {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PostCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    return cell;
}

// 选中 cell 的效果
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}


#pragma mark 模式切换
- (void)switchToMine
{
    [self.navigationItem setTitle:@"我的"];
    [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"people@2x.png"]];
    _mode = Mine;
}

- (void)switchToFollowing
{
    [self.navigationItem setTitle:@"我关注的"];
    [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"me@2x.png"]];
    _mode = Following;
}

- (void)switchMode
{
    if(_mode == Mine)
    {
        [self switchToFollowing];
    }
    else
    {
        [self switchToMine];
    }
    [self.tableView reloadData];
}

#pragma mark 创建post
- (void)post
{
    [self.navigationController pushViewController:[[WritingPostViewController alloc]init] animated:YES];
}

@end
