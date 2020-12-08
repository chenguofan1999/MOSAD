//
//  GalleryViewController.m
//  hw3
//
//  Created by itlab on 12/8/20.
//

#import "GalleryViewController.h"
#import "GalleryTableViewCell.h"
#import <Masonry/Masonry.h>
#import <AFNetworking/AFNetworking.h>

#define CachePathForURL(url) [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[url lastPathComponent]]

@interface GalleryViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *imageTable;
@property (nonatomic, strong) NSMutableArray *imageURLList;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) NSMutableDictionary *imageDict;
@property (nonatomic, strong) NSString *cachesPath;
@end

@implementation GalleryViewController

- (instancetype)init
{
    self = [super init];
    self.tabBarItem = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemDownloads tag:1];
    self.tabBarItem.title = @"Info";
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initTableView];
    
    
    [self.imageURLList addObject:@"https://hbimg.huabanimg.com/d8784bbeac692c01b36c0d4ff0e072027bb3209b106138-hwjOwX_fw658"];
    [self.imageURLList addObject:@"https://hbimg.huabanimg.com/6215ba6f9b4d53d567795be94a90289c0151ce73400a7-V2tZw8_fw658"];
    [self.imageURLList addObject:@"https://hbimg.huabanimg.com/834ccefee93d52a3a2694535d6aadc4bfba110cb55657-mDbhv8_fw658"];
    [self.imageURLList addObject:@"https://hbimg.huabanimg.com/f3085171af2a2993a446fe9c2339f6b2b89bc45f4e79d-LacPMl_fw658"];
    [self.imageURLList addObject:@"https://hbimg.huabanimg.com/e5c11e316e90656dd3164cb97de6f1840bdcc2671bdc4-vwCOou_fw658"];
    [self.imageURLList addObject:@"https://512pixels.net/downloads//macos-wallpapers/10-14-Night.jpg"];
    
    //
    // 获取Caches目录
    _cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

# pragma mark 懒加载
- (NSMutableArray *)imageURLList
{
    if(_imageURLList == nil)
    {
        _imageURLList = [[NSMutableArray alloc]init];
    }
    return _imageURLList;
}

- (NSMutableDictionary *)imageDict
{
    if(_imageDict == nil)
    {
        _imageDict = [[NSMutableDictionary alloc]init];
    }
    return _imageDict;
}

- (NSOperationQueue *)operationQueue
{
    if(_operationQueue == nil)
    {
        // 自定义队列, 会在子线程执行
        _operationQueue = [[NSOperationQueue alloc]init];
    }
    return _operationQueue;
}

# pragma mark 初始化TableView
- (void)initTableView
{
    // 设置tableView
    _imageTable = [[UITableView alloc]init];
    _imageTable.delegate = self;
    _imageTable.dataSource = self;
    [_imageTable setBounces:NO];
    
    [self.view addSubview:_imageTable];
    [_imageTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).with.offset(0);
    }];
    
    // 注册
    UINib *nib = [UINib nibWithNibName:@"GalleryTableViewCell" bundle:nil];
    [_imageTable registerNib:nib forCellReuseIdentifier:@"GalleryTableViewCell"];
    
    [self initButtonView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

# pragma mark 初始化按键条
- (void)initButtonView
{
    CGFloat w = [[UIScreen mainScreen] bounds].size.width;
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, w, 50)];
//    [buttonView.layer setCornerRadius:25];
    
    [buttonView setBackgroundColor:[UIColor lightGrayColor]];
    
    UIButton *loadButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, w/3, 50)];
    UIButton *clearButton = [[UIButton alloc]initWithFrame:CGRectMake(w/3, 0, w/3, 50)];
    UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(w*2/3, 0, w/3, 50)];
    
//    [loadButton setBackgroundColor:[UIColor darkGrayColor]];
    [clearButton setBackgroundColor:[UIColor grayColor]];
//    [deleteButton setBackgroundColor:[UIColor darkGrayColor]];
    
    [loadButton setTitle:@"加载" forState:UIControlStateNormal];
    [clearButton setTitle:@"清空" forState:UIControlStateNormal];
    [deleteButton setTitle:@"删除缓存" forState:UIControlStateNormal];
    
    [loadButton addTarget:self action:@selector(loadImages) forControlEvents:UIControlEventTouchUpInside];
    [clearButton addTarget:self action:@selector(clearImages) forControlEvents:UIControlEventTouchUpInside];
    [deleteButton addTarget:self action:@selector(deleteImageCache) forControlEvents:UIControlEventTouchUpInside];
    
    [buttonView addSubview:loadButton];
    [buttonView addSubview:clearButton];
    [buttonView addSubview:deleteButton];
    
    [_imageTable setTableHeaderView:buttonView];
}


# pragma mark 加载图片
- (void)loadImages
{
    NSLog(@"开始加载图片");
    [self.imageTable reloadData];
}

# pragma mark 清空图片
- (void)clearImages
{
    NSLog(@"清空图片");
    for(int i = 0; i < [self.imageURLList count]; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        GalleryTableViewCell *cell = [self.imageTable cellForRowAtIndexPath:indexPath];
        [cell.myImageView setImage:[GalleryViewController imageFromColor:[UIColor lightGrayColor]]];
    }
}

# pragma mark 删除缓存
- (void)deleteImageCache
{
    NSLog(@"删除图片缓存");
    for(int i = 0; i < [self.imageURLList count]; i++)
    {
        NSString *filePath = CachePathForURL(self.imageURLList[i]);
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL deleted = [fileManager removeItemAtPath:filePath error:nil];
        if(deleted)
        {
            NSLog(@"成功删除");
        }
        else
        {
            NSLog(@"删除失败");
        }
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        GalleryTableViewCell *cell = [self.imageTable cellForRowAtIndexPath:indexPath];
        [cell.progressBar setProgress:0 animated:YES];
    }
}


# pragma mark Tableview Data Source
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    GalleryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GalleryTableViewCell" forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[GalleryTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"GalleryTableViewCell"];
    }
    
    NSInteger i = indexPath.row;
    NSString *imageURL = self.imageURLList[i];
    [cell.progressBar setProgress:0 animated:NO];
    [cell.infoLabel setText:[NSString stringWithFormat:@"%@", imageURL]];
    
    // 查看沙盒中有无缓存
    NSString *cacheFilePath = CachePathForURL(imageURL);
    NSData *cacheImageData = [NSData dataWithContentsOfFile:cacheFilePath];
    if(cacheImageData != nil) // 如果沙盒中有缓存文件
    {
        [cell.myImageView setImage:[UIImage imageWithData:cacheImageData]];
        [cell.progressBar setProgress:1 animated:NO];
    }
    else // 沙盒里没有缓存过，需要下载
    {
        // 显示加载中
        NSLog(@"没有缓存，开始下载");
        [cell.myImageView setImage:[GalleryViewController imageFromColor:[UIColor lightGrayColor]]];
        [cell.indicator startAnimating];
        [UIView animateWithDuration:5 animations:^{
            [cell.progressBar setProgress:0.9 animated:YES];
        }];
        
        NSBlockOperation *downloadOperation = [NSBlockOperation blockOperationWithBlock:^{
            UIImage *downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
            
            // 如果下载成功
            if(downloadedImage)
            {
                // 存入沙盒中
                NSData *downloadedImageData = UIImagePNGRepresentation(downloadedImage);
                [downloadedImageData writeToFile:cacheFilePath atomically:YES];
            }
            
            // 刷新cell(一定要在主线程)
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.imageTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
        }];
        
        [self.operationQueue addOperation:downloadOperation];
    }
    
    return cell;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.imageURLList count];
}



/**
 *
 */
+ (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
