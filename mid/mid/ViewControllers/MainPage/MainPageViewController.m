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
#import "FullDataItem.h"
#import "UserInfo.h"
#import "ContentItem.h"
#import "PostViewController.h"
#import "ProfilePageViewController.h"
#import "CommentTableViewController.h"
#import <Masonry/Masonry.h>
#import <AFNetworking/AFNetworking.h>

@interface MainPageViewController ()<UISearchBarDelegate>
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UIView *categoryView;
@property (strong, nonatomic) NSArray *categories;
@property (nonatomic) NSInteger atPage;
@property (nonatomic) NSMutableArray *items;
@end

@implementation MainPageViewController


- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    // 页面样式
    //self.view.backgroundColor = [UIColor whiteColor];
    
    // TabBar项中的样式 (有必要在 init 时加载)
    [[self tabBarItem] setTitle:@"我的"];
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
    [self setPortraitButtonWithImage:[UIImage imageNamed:@"testPortrait.jpg"]];
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
    
    // 一些样式
    [self.tableView setBounces:NO];
    
    [self loadTextData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 设置导航栏不透明，一劳永逸解决排布问题
    // self.navigationController.navigationBar.translucent = NO;
    
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
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
}

#pragma mark 数据源
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
    [cell.portraitButton addTarget:self action:@selector(toUserPage:) forControlEvents:UIControlEventTouchUpInside];
    [cell.favButton setHidden:YES];
    [cell.deleteButton addTarget:self action:@selector(deletePost:) forControlEvents:UIControlEventTouchUpInside];
    [cell.commentButton addTarget:self action:@selector(showCommentPage:) forControlEvents:UIControlEventTouchUpInside];
    
    // for test use
    [cell addPic:[UIImage imageNamed:@"testPic.jpg"]];
    [cell addPic:[UIImage imageNamed:@"test100.jpg"]];
    [cell addPic:[UIImage imageNamed:@"test101.jpg"]];
    [cell addPic:[UIImage imageNamed:@"test102.jpg"]];
    
    // 设置cell值
    long i = indexPath.row;
    ContentItem *contentItem = _items[i];
    cell.userNameLabel.text = [UserInfo sharedUser].name;
    cell.portraitButton.imageView.image = [UserInfo sharedUser].avatar;
    [self setLabel:cell.textContentLable
         WithTitle:contentItem.title
              Tags:contentItem.tags
            Detail:contentItem.detail];
    cell.timeLable.text = [self timeStampToTime:[contentItem PublishDate]];
    cell.likeNumberLable.text = [NSString stringWithFormat:@"%d", [contentItem likeNum]];
    cell.commentNumberLable.text = [NSString stringWithFormat:@"%d", [contentItem commentNum]];
    
    return cell;
}

// section 个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Section 中的 Cell 个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_items count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
        category1.text = @"文字";
        
        UILabel *category2 = [[UILabel alloc] initWithFrame:CGRectMake(w * 2/5, 0, w / 5, h)];
        category2.text = @"图片";
        
        UILabel *category3 = [[UILabel alloc] initWithFrame:CGRectMake(w * 3/5, 0, w / 5, h)];
        category3.text = @"收藏";
        
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
    _atPage = sender.view.tag;
    
    // 样式改变
    for(int i = 0; i < [_categories count]; i++)
    {
        if(i == _atPage)
            [_categories[i] setTextColor:[UIColor blackColor]];
        else
            [_categories[i] setTextColor:[UIColor lightGrayColor]];
    }
    
    // 定义功能
    switch (_atPage) {
        case 0:
            NSLog(@"tag: 0");
            [self loadTextData];
            break;
        case 1:
            NSLog(@"tag: 1");
            break;
        case 2:
            NSLog(@"tag: 2");
            break;
        default:
            break;
    }
    
}

#pragma mark 加载 text 类内容

- (void)loadTextData
{
    NSString *URL = @"http://172.18.178.56/api/content/texts/self";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:URL parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *response = (NSDictionary *)responseObject;
        NSLog(@"%@",response);
        if([response[@"State"] isEqualToString:@"success"])
        {
            self.items = [NSMutableArray new];
            NSArray *data = response[@"Data"];
            NSInteger n = [data count];
            NSLog(@"Item Number: %ld",n);
            for(int i = 0; i < n; i++)
            {
                ContentItem *newItem = [[ContentItem alloc]initWithDict:data[i]];
                NSLog(@"this Item: %@", newItem);
                [self.items addObject:newItem];
            }
            for(int i = 0; i < n; i++)
                NSLog(@"item[%d] = %@",i,self.items[i]);
        }
        
        
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Failed to fetch public contents somehow");
    }];
}


#pragma mark 加载 album 类内容

#pragma mark 加载 收藏 内容

#pragma mark 搜索栏
// 延迟加载搜索栏
- (UISearchBar *)searchBar
{
    if(!_searchBar)
    {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
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


#pragma mark 设定内部具有不同样式的内容
- (void)setLabel:(UILabel *)label
       WithTitle:(NSString *)title
            Tags:(NSMutableArray *)tags
          Detail:(NSString *)detail
{
    NSString *newTitle = nil;
    if([title length] == 0) newTitle = @"";
    else if([detail length] == 0 && [tags count] == 0) newTitle = title;
    else newTitle = [NSString stringWithFormat:@"%@\n", title];
    
    NSString *newDetail = nil;
    if([detail length] == 0) newDetail = @"";
    else if([tags count] == 0) newDetail = detail;
    else newDetail = [NSString stringWithFormat:@"%@\n", detail];
    
    NSMutableString *connectedTags = [[NSMutableString alloc]init];
    for(int i = 0; i < [tags count]; i++)
    {
        if(i == 0) [connectedTags appendString:@"#"];
        if(i == [tags count] - 1)
            [connectedTags appendFormat:@"%@", tags[i]];
        else
            [connectedTags appendFormat:@"%@ #", tags[i]];
    }
    
    NSUInteger lenTitle = [newTitle length];
    NSUInteger lenDetail = [newDetail length];
    NSUInteger lenTags = [connectedTags length];
    
    NSRange rangeTitle = NSMakeRange(0, lenTitle);
    NSRange rangeDetail = NSMakeRange(lenTitle, lenDetail);
    NSRange rangeTags = NSMakeRange(lenTitle + lenDetail, lenTags);
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@%@",newTitle,newDetail,connectedTags]];
    
    // Title 样式
    [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:rangeTitle];
    
    // Detail 样式
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:rangeDetail];
    
    // Tags 样式
    UIColor *tagColor = [UIColor colorWithRed:(float)29/255 green:(float)161/255 blue:(float)242/255 alpha:1];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:rangeTags];
    [str addAttribute:NSForegroundColorAttributeName value:tagColor range:rangeTags];
    
    [label setAttributedText:str];
}

#pragma mark 喜欢button
- (void)favPost:(UIButton *)btn
{
    UIView *contentView = [btn superview];
    PostCell *cell = (PostCell *)[contentView superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    // 已经得到indexPath
    NSLog(@"press fav button at row %ld", indexPath.row);
}

#pragma mark 头像button
- (void)toUserPage:(UIButton *)btn
{
    UIView *contentView = [btn superview];
    PostCell *cell = (PostCell *)[contentView superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    // 已经得到indexPath
    NSLog(@"press avator button at row %ld", indexPath.row);
    [self.navigationController pushViewController:[[ProfilePageViewController alloc]init] animated:NO];
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

#pragma mark 删除button
- (void)deletePost:(UIButton *)btn
{
    UIView *contentView = [btn superview];
    PostCell *cell = (PostCell *)[contentView superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    // 已经得到indexPath
    NSLog(@"press delete button at row %ld", indexPath.row);
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
    NSString *contentID = [_items[indexPath.row] contentID];
    NSString *ownerID = [_items[indexPath.row]ownerID];
    [self presentViewController:[[CommentTableViewController alloc]initWithContentID:contentID andOwnerID:ownerID] animated:YES completion:nil];
}


#pragma mark 导航栏两个button
- (void)setPortraitButtonWithImage:(UIImage *)image
{
    int r = 35;
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, r, r)];
    [button setImage:image forState:UIControlStateNormal];
    button.layer.cornerRadius = r/2;
    button.imageView.contentMode = UIViewContentModeScaleAspectFill; // 头像截取而不缩放
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
    [self.navigationController pushViewController:[[ProfilePageViewController alloc]init] animated:NO];
}
- (void)post
{
    [self.navigationController pushViewController:[WritingPostViewController new] animated:NO];
}


@end
