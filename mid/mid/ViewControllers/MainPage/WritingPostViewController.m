//
//  PostViewController.m
//  mid
//
//  Created by itlab on 2020/11/23.
//

#import "WritingPostViewController.h"

@interface WritingPostViewController ()
@property (nonatomic) int picNum;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIScrollView *imageView;
@property (nonatomic, strong) UIView *innerImageView;
@property (nonatomic, strong) UIButton *addPicButton;

@property (nonatomic) int x;
@property (nonatomic) int y;
@property (nonatomic) int w;
@property (nonatomic) int h;


@end

@implementation WritingPostViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 加载此页面时隐藏 tabBar
    self.tabBarController.tabBar.hidden=YES;
    
    // 计算无遮挡页面尺寸
    UIWindow *window = UIApplication.sharedApplication.windows[0];
    CGRect safe = window.safeAreaLayoutGuide.layoutFrame;
    //CGRect statusRect = window.windowScene.statusBarManager.statusBarFrame;
    CGRect navRect = self.navigationController.navigationBar.frame;
    //CGRect tabRect = self.tabBarController.tabBar.frame;
    
    _x = safe.origin.x;
    _y = safe.origin.y + navRect.size.height;
    _w = safe.size.width;
    _h = safe.size.height - navRect.size.height;
    
    
    // 右上方按钮
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithTitle:@"Post"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(postIt)];
    [self.navigationItem setRightBarButtonItem:postButton];
    
    // 上方的文本框
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(_x, _y, _w, _h - 120)];
    [textView setFont:[UIFont systemFontOfSize:20]];
    [self.view addSubview:textView];
    
    // 下方的贴图区域
    [self loadPicZone];
    
    // 初始化imagePicker
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.delegate = self;
    _imagePicker.allowsEditing = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden=NO;
}

- (void)postIt
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 图片区域
- (void)loadPicZone
{
    // imageView 是下方整个添加和显示图片的区域
    _imageView = [[UIScrollView alloc] initWithFrame:CGRectMake(_x, _y + _h - 120, _w, 120)];
    [_imageView setBackgroundColor:[UIColor lightGrayColor]];
    
    // innerImageView 是 imageView 的内部视图，应将图片和按钮添加到此视图
    // 每次更改该视图的 frame 时应调用 _imageView 的 setContentSize: 方法
    _innerImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _w, 120)];
    [_imageView addSubview:_innerImageView];
    [_imageView setContentSize:_innerImageView.frame.size];
    [_imageView setClipsToBounds:YES];
    
    // 对按钮的初始话
    _addPicButton = [[UIButton alloc] initWithFrame:[self frameAtIndex:0]];
    [_addPicButton setTitle:@"+" forState:UIControlStateNormal];
    [_addPicButton.titleLabel setFont:[UIFont systemFontOfSize:40]];
    [_addPicButton setBackgroundColor:[UIColor darkGrayColor]];
    [[_addPicButton layer]setCornerRadius:5];
    [_addPicButton addTarget:self action:@selector(addPic) forControlEvents:UIControlEventTouchUpInside];
    [_innerImageView addSubview:_addPicButton];
    
    [self.view addSubview:_imageView];
}

- (void)addPic
{
    // 如果图片数已大于等于3，resize
    if(_picNum >= 3)
    {
        [_innerImageView setFrame:CGRectMake(0, 0, 120 * (_picNum + 1), 120)];
        [_imageView setContentSize:_innerImageView.frame.size];
    }
    
    // 呈现选项：从相册中选取 / 从相机选取 / 取消
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    [actionSheet addAction:photoAction];
    [actionSheet addAction:cameraAction];
    [actionSheet addAction:cancelAction];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
    
}

// 对选中图片的处理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 呈现选中的照片的视图
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageView *newPicView = [[UIImageView alloc] initWithFrame:[self frameAtIndex:_picNum]];
    newPicView.image = selectedImage;
    
    // 视图样式
    [newPicView.layer setCornerRadius:5];
    [newPicView.layer setMasksToBounds:YES];
    
    [_imageView addSubview:newPicView];
    
    // 添加成功后再移动添加按钮
    _addPicButton.frame = [self frameAtIndex:_picNum + 1];
    
    // 增加图片计数
    _picNum ++;
}

- (CGRect)frameAtIndex:(int)i
{
    return CGRectMake(10 + 110 * i, 10, 100, 100);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
