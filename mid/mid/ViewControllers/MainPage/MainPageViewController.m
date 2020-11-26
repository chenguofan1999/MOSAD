//
//  MyPageViewController.m
//  mid
//
//  Created by itlab on 2020/11/23.
//

#import "MainPageViewController.h"
#import "WritingPostViewController.h"
#import "BigImageViewController.h"
#import "PostCell.h"

@interface MainPageViewController ()<UISearchBarDelegate>
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UIView *categoryView;
@property (strong, nonatomic) NSArray *categories;
@end

@implementation MainPageViewController


- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    // 页面样式
    self.view.backgroundColor = [UIColor whiteColor];
    
    // TabBar项中的样式 (有必要在 init 时加载)
    [[self tabBarItem] setTitle:@"主页"];
    [self.tabBarItem setImage:[UIImage imageNamed:@"compass@2x.png"]];
    [self.tabBarItem setSelectedImage:[UIImage imageNamed:@"compass-filled@2x.png"]];
    
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /** 导航栏
     * 右侧按钮用于发布
     * 中间是搜索框
     * 左侧按钮是头像，点击进入个人页面
     */
    // 延迟加载搜索框, 放在 navBar 的中间
    [self.navigationItem setTitleView:[self searchBar]];
    // 左侧按钮
    [self setPortraitButtonWithImage:[UIImage imageNamed:@"chen.png"]];
    // 右侧按钮
    UIBarButtonItem *rightButton =
        [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                     target:self
                                                     action:@selector(post)];
    [self.navigationItem setRightBarButtonItem:rightButton];
    
    // 加载分类栏
    self.tableView.tableHeaderView = [self categoryView];
    
    
    // 注册 nib 文件
    UINib *nib = [UINib nibWithNibName:@"PostCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"PostCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 隐藏navbar下面的黑线
    UIView *backgroundView = [self.navigationController.navigationBar subviews].firstObject;
    UIView *navBottomLine;
    if (@available(iOS 14.0, *)) {
        navBottomLine = backgroundView.subviews.lastObject;
    } else {
        navBottomLine = backgroundView.subviews.firstObject;
    }
    navBottomLine.hidden = YES;
    
    // 页面设置背景颜色
    [self.tableView setBackgroundColor:[UIColor colorWithWhite:0.f alpha:0.03]];
}


#pragma mark 分类栏
// 延迟加载分类栏
- (UIView *)categoryView
{
    if(!_categoryView)
    {
        int w = [[UIScreen mainScreen] bounds].size.width;
        int h = 30;
        _categoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
        _categoryView.backgroundColor = [UIColor clearColor];
        
        UILabel *category1 = [[UILabel alloc] initWithFrame:CGRectMake(w * 1/5, 0, w / 5, h)];
        category1.text = @"分类1";
        
        UILabel *category2 = [[UILabel alloc] initWithFrame:CGRectMake(w * 2/5, 0, w / 5, h)];
        category2.text = @"分类2";
        
        UILabel *category3 = [[UILabel alloc] initWithFrame:CGRectMake(w * 3/5, 0, w / 5, h)];
        category3.text = @"分类3";
        
        _categories = [[NSArray alloc] init];
        _categories = @[category1, category2, category3];
        for(int i = 0; i < 3; i++)
        {
            UILabel *t = _categories[i];
            t.textAlignment = NSTextAlignmentCenter;
            t.tag = i;
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSec:)];
            [t setUserInteractionEnabled:YES];
            [t addGestureRecognizer:gesture];
            [t setTextColor:i == 0 ? [UIColor blackColor] : [UIColor lightGrayColor]];
            [_categoryView addSubview:t];
        }
    }
    return _categoryView;
}

- (void)tapSec:(UITapGestureRecognizer *)sender
{
    NSInteger target = sender.view.tag;
//    switch (i) {
//        case 0:
//            NSLog(@"tag: 0");
//            break;
//        case 1:
//            NSLog(@"tag: 1");
//            break;
//        case 2:
//            NSLog(@"tag: 2");
//            break;
//        default:
//            break;
//    }
    for(int i = 0; i < [_categories count]; i++)
    {
        if(i == target)
            [_categories[i] setTextColor:[UIColor blackColor]];
        else
            [_categories[i] setTextColor:[UIColor lightGrayColor]];
    }
}


#pragma mark 搜索栏
// 延迟加载搜索栏
- (UISearchBar *)searchBar
{
    if(!_searchBar)
    {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
        // 消除搜索框的不必要的背景颜色
        UIImage* clearColor = [MainPageViewController GetImageWithColor:[UIColor clearColor] Height:35];
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
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{}

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
    
    // 如果没有图片，用以下方法去掉显示图片的区域
    // [cell dontShowPicView];
    
    // 设置数据
    // [cell setVal:..];

    // 设置Block（点击略缩图事件）
    cell.actionBlock = ^(UIImage *img){
        BigImageViewController *bivc = [[BigImageViewController alloc] init];
        bivc.view.backgroundColor = [UIColor blackColor];
        bivc.image = img;
        //[self.navigationController pushViewController:bivc animated:YES];
        [self presentViewController:bivc animated:YES completion:nil];
    };
    
    // for test use
    [cell addPic:[UIImage imageNamed:@"7285.jpg"]];
    
    return cell;
}



// 选中 cell 的效果
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{}

// 取消选中 cell 的效果
//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}

#pragma mark 头像按键
- (void)setPortraitButtonWithImage:(UIImage *)image
{
    int r = 35;
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, r, r)];
    [button setImage:image forState:UIControlStateNormal];
    button.layer.cornerRadius = r/2;
    button.imageView.contentMode = UIViewContentModeScaleAspectFit; // 头像将等比例缩放
    button.layer.masksToBounds = YES;                               // 头像将只显示在圆圈内
    
    // 以下两句约束了button的控件大小
    [button.widthAnchor constraintEqualToConstant:35].active = YES;
    [button.heightAnchor constraintEqualToConstant:35].active = YES;
    
    button.layer.borderWidth = 1.2;
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [button addTarget:self action:@selector(toMyPage) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:button]];
}

- (void)toMyPage
{
    
}

#pragma mark 创建post
- (void)post
{
    [self.navigationController pushViewController:[[WritingPostViewController alloc]init] animated:YES];
}


@end
