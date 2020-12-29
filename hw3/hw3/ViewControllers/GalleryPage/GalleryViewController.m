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
    
//    [self.imageURLList addObject:@"https://wallpapercave.com/wp/1f1ue2y.jpg"];
//    [self.imageURLList addObject:@"https://wallpapercave.com/wp/Phd2UEn.jpg"];
//    [self.imageURLList addObject:@"https://wallpapercave.com/wp/wp4842245.jpg"];
//    [self.imageURLList addObject:@"https://wallpaperaccess.com/full/3041.jpg"];
//    [self.imageURLList addObject:@"https://wallpapercave.com/wp/wp4842249.jpg"];
//    [self.imageURLList addObject:@"https://wallpapercave.com/wp/TMMBLEg.jpg"];
//    [self.imageURLList addObject:@"https://wallpapercave.com/wp/QQH2QHS.jpg"];
    
    [self.imageURLList addObject:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1607528405279&di=a81a788d8573f027a9056a97a43ad973&imgtype=0&src=http%3A%2F%2Fww2.sinaimg.cn%2Flarge%2F7328fe1bgw1ewb0839id3j21kw1wzkjn.jpg"];
    [self.imageURLList addObject:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1607528549812&di=655fe17791a9af7edc1f36a73d7a4aa5&imgtype=0&src=http%3A%2F%2Fpic2.zhimg.com%2Fe58f03aa19220b946e1bf2d51d9e7431_r.jpg"];
    [self.imageURLList addObject:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1607528635185&di=7c5422e49f10a69f0b7bcd5f81ed8274&imgtype=0&src=http%3A%2F%2Fimg1.doubanio.com%2Fpview%2Fevent_poster%2Fraw%2Fpublic%2F36bf6f6327eacdb.jpg"];
    [self.imageURLList addObject:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1607528641350&di=71f6248c548f037964dfccdb0cb75160&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20190805%2F91af619679b04f8e91326df979aba83d.jpeg"];
    [self.imageURLList addObject:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1607528549815&di=1d73307a4b6dc2dbe57bd67bb5d26d65&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20190805%2F9a3cd413bc77432fab809ce60d738900.jpeg"];
    [self.imageURLList addObject:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1607528405280&di=79d6f83084d6b0eb67d1e1cb54a22c7e&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201808%2F07%2F20180807203508_huknk.jpg"];
    
    
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
//    [buttonView.layer setCornerRadius:5];
    
    [buttonView setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat M = 10;
    CGFloat W = (w - 4 * M) / 3;
    UIButton *loadButton = [[UIButton alloc]initWithFrame:CGRectMake(M, 0, W, 50)];
    UIButton *clearButton = [[UIButton alloc]initWithFrame:CGRectMake(2 * M + W, 0, W, 50)];
    UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(3 * M + 2 * W, 0, W, 50)];
    
    [loadButton setBackgroundColor:[UIColor lightGrayColor]];
    [clearButton setBackgroundColor:[UIColor grayColor]];
    [deleteButton setBackgroundColor:[UIColor redColor]];
    
    [loadButton.layer setCornerRadius:5];
    [clearButton.layer setCornerRadius:5];
    [deleteButton.layer setCornerRadius:5];
    
    
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
        
        NSString *imageURL = self.imageURLList[i];
        [cell.infoTitleLabel setText:@"URL"];
        [cell.infoLabel setText:[NSString stringWithFormat:@"%@", imageURL]];
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
    [cell.infoTitleLabel setText:@"URL"];
    [cell.infoLabel setText:[NSString stringWithFormat:@"%@", imageURL]];
    
    // 查看沙盒中有无缓存
    NSString *cacheFilePath = CachePathForURL(imageURL);
    NSLog(@"%@",cacheFilePath);
    NSData *cacheImageData = [NSData dataWithContentsOfFile:cacheFilePath];
    if(cacheImageData != nil) // 如果沙盒中有缓存文件
    {
        [cell.myImageView setImage:[UIImage imageWithData:cacheImageData]];
        float size = [[[NSFileManager defaultManager] attributesOfItemAtPath:cacheFilePath error:nil] fileSize] / (1024.0 * 1024.0);
        [cell.infoTitleLabel setText:@"Size"];
        [cell.infoLabel setText:[NSString stringWithFormat:@"%.02f m", size]];
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
