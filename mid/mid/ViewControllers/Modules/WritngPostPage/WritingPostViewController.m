//
//  PostViewController.m
//  mid
//
//  Created by itlab on 2020/11/23.
//

#import "WritingPostViewController.h"
#import "ContentItem.h"
#import <AFNetworking/AFNetworking.h>

@interface WritingPostViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
@property (nonatomic) ContentItem *postItem;
@property (nonatomic) int picNum;

@property (nonatomic, strong) UITextField *titleField;
@property (nonatomic, strong) UITextView *detailView;

@property (nonatomic, strong) UITableView *optionTable;
@property (nonatomic, strong) UISwitch *publicSwitch;

@property (nonatomic, strong) UIScrollView *imageView;
@property (nonatomic, strong) UIView *innerImageView;
@property (nonatomic, strong) UIButton *addPicButton;
@property (nonatomic, strong) UIImagePickerController *imagePicker;

@property (nonatomic) int x;
@property (nonatomic) int y;
@property (nonatomic) int w;
@property (nonatomic) int h;


@end

@implementation WritingPostViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化model对象
    _postItem = [ContentItem new];
    
    // 加载此页面时隐藏 tabBar
    self.tabBarController.tabBar.hidden=YES;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
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
    
    // 手动设置返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backTapped:)];
    
    // Title 输入框
    _titleField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, _w, 60)];
    [_titleField setPlaceholder:@"Title"];
    [_titleField setFont:[UIFont systemFontOfSize:30]];
    [self.view addSubview:_titleField];
    
    // Detail 输入框
    _detailView = [[UITextView alloc] initWithFrame:CGRectMake(0, 60, _w, _h - 300)];
    [_detailView setFont:[UIFont systemFontOfSize:20]];
    _detailView.delegate = self;
    [_detailView setText:@"Detail"];
    [_detailView setTextColor:[UIColor lightGrayColor]];
    [self.view addSubview:_detailView];
    
    // optionTable
    _optionTable = [[UITableView alloc]initWithFrame:CGRectMake(0, _h - 240, _w, 120) style:UITableViewStylePlain];
    _optionTable.delegate = self;
    _optionTable.dataSource = self;
    [_optionTable setTableHeaderView:[[UIView alloc] initWithFrame:CGRectZero]];
    [_optionTable setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [_optionTable setBounces:NO];
    [self.view addSubview:_optionTable];
    
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
    _postItem.title = _titleField.text;
    _postItem.detail = _detailView.text;
    _postItem.isPublic = [_publicSwitch isOn];
    NSString *URL = @"http://172.18.178.56/api/content/text";
    NSDictionary *body = [_postItem getDict];
    
    NSLog(@"%@", body);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    [manager POST:URL parameters:body headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *response = (NSDictionary *)responseObject;
        if([response[@"State"] isEqualToString:@"success"])
        {
            [self Alert:@"发布成功"];
            [self.navigationController popViewControllerAnimated:NO];
        }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self Alert:@"请求失败"];
        }];
    
}

#pragma mark 图片区域
- (void)loadPicZone
{
    // imageView 是下方整个添加和显示图片的区域
    _imageView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _h - 120, _w, 120)];
    [_imageView setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1]];
    
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
    [_addPicButton setBackgroundColor:[UIColor lightGrayColor]];
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


- (void)backTapped:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

# pragma mark UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return 0.0001f;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                                   reuseIdentifier:nil];
    [cell setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1]];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Tags";
            cell.detailTextLabel.text = [_postItem.tags componentsJoinedByString:@","];
            break;
            
        case 1:
            cell.textLabel.text = @"Public";
            _publicSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
            [cell addSubview:_publicSwitch];
            cell.accessoryView = _publicSwitch;
            
            break;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 增加tag
    if(indexPath.row == 0)
    {
        UIAlertController *addTagController = [UIAlertController alertControllerWithTitle:@"标签" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [addTagController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"#";
        }];
        [addTagController addAction:[UIAlertAction actionWithTitle:@"添加标签"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *action) {
            NSArray *textfields = addTagController.textFields;
            UITextField * tagField = textfields[0];
            NSString *newTag = tagField.text;
            
            // 添加到 model 里
            [self.postItem.tags addObject:newTag];
            
            // 更新当前显示的 tag
            [self.optionTable reloadData];
        }]];
        [addTagController addAction:[UIAlertAction actionWithTitle:@"清空标签"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *action) {
            // 清空 tags
            self.postItem.tags = [NSMutableArray new];
            // 更新当前显示的 tag
            [self.optionTable reloadData];
        }]];
        [addTagController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        
        [self presentViewController:addTagController animated:YES completion:nil];
    }
}


# pragma mark place holder 模拟
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Detail"]) {
         textView.text = @"";
         textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Detail";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

# pragma mark 提示
- (void)Alert:(NSString *)msg
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    
    // 显示对话框
    [self presentViewController:alert animated:true completion:nil];
}

@end
