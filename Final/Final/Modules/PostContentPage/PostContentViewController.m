//
//  PostContentViewController.m
//  Final
//
//  Created by itlab on 12/28/20.
//

#include <stdlib.h>
#import <MaterialComponents/MDCButton+MaterialTheming.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MaterialTextControls+FilledTextAreas.h>
#import <MaterialTextControls+FilledTextFields.h>
#import <MaterialTextControls+OutlinedTextAreas.h>
#import <MaterialTextControls+OutlinedTextFields.h>
#import <AFNetworking/AFNetworking.h>
#import <AVFoundation/AVFoundation.h>
#import <SJVideoPlayer/SJVideoPlayer.h>
#import <Masonry/Masonry.h>
#import <PhotosUI/PhotosUI.h>
#import <Photos/Photos.h>
#import <MaterialDialogs.h>
#import "PostContentViewController.h"
#import "AppConfig.h"
#import "UserInfo.h"
#import "PreViewController.h"
#import "BigImageViewController.h"

@interface PostContentViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,PHPickerViewControllerDelegate,UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic, strong) UILabel *selectCoverImageLabel;
@property (nonatomic, strong) MDCButton *selectVideoButton;
@property (nonatomic, strong) MDCButton *sendButton;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) MDCFilledTextField *titleField;
@property (nonatomic, strong) MDCFilledTextArea *descriptionArea;

@property (nonatomic, strong) UIImageView *videoIcon;
@property (nonatomic, strong) UIImageView *imageIcon;
@property (nonatomic, strong) UIImageView *titleIcon;
@property (nonatomic, strong) UIImageView *pencilIcon;

@property (nonatomic, strong) UIColor *POSTFontColor;
@property (nonatomic, strong) UIColor *POSTBGColor;
@property (nonatomic, strong) UIColor *POSTSurfaceColor;
@property (nonatomic, strong) UIColor *POSTButtonColor;

@property (nonatomic, strong) UIActivityIndicatorView *uploadingIndicator;

// cache data
@property (nonatomic) NSURL *videoURL;
@property (nonatomic) NSData *cachedImageData;
@property (nonatomic) UIImage *coverImage;
@property (nonatomic) int videoDuration;

@end

@implementation PostContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setColors];
    
    
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    [scrollView setBounces:NO];
    [scrollView setBackgroundColor:self.POSTBGColor];
    [self.view addSubview:scrollView];
    
    UIView *backView = [[UIView alloc]init];
    [backView setBackgroundColor:self.POSTBGColor];
    [scrollView addSubview:backView];
    
    [backView addSubview:self.selectVideoButton];
    [backView addSubview:self.coverImageView];
    [backView addSubview:self.titleField];
    [backView addSubview:self.descriptionArea];
    [backView addSubview:self.videoIcon];
    [backView addSubview:self.imageIcon];
    [backView addSubview:self.titleIcon];
    [backView addSubview:self.pencilIcon];
    
    [backView addSubview:self.uploadingIndicator];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    
    [self.selectVideoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView).offset(40);
        make.left.equalTo(backView).offset(70);
        make.right.equalTo(backView).offset(-25);
        make.height.mas_equalTo(50);
    }];
    
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.selectVideoButton.mas_bottom).offset(30);
        make.left.equalTo(backView).offset(70);
        make.right.equalTo(backView).offset(-25);
        make.height.mas_equalTo(150);
    }];
    
    [self.titleField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.coverImageView.mas_bottom).offset(40);
        make.left.equalTo(backView).offset(70);
        make.right.equalTo(backView).offset(-25);
        make.height.mas_equalTo(50);
    }];
    
    [self.descriptionArea mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleField.mas_bottom).offset(50);
        make.left.equalTo(backView).offset(70);
        make.right.equalTo(backView).offset(-25);
        make.bottom.equalTo(backView).offset(-320);
    }];
    
    [self.videoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.centerY.equalTo(self.selectVideoButton);
        make.left.equalTo(backView).offset(20);
    }];
    
    [self.imageIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.top.equalTo(self.coverImageView).offset(8);
        make.left.equalTo(backView).offset(20);
    }];
    
    [self.titleIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.centerY.equalTo(self.titleField);
        make.left.equalTo(backView).offset(20);
    }];
    
    [self.pencilIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.top.equalTo(self.descriptionArea).offset(8);
        make.left.equalTo(backView).offset(20);
    }];
    
//    [self.uploadingIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.centerY.equalTo(self.view);
//    }];
//    [self.navigationItem setTitle:@"Edit Content"];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:self.sendButton]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBarTintColor:self.POSTBGColor];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    if(self.videoURL != nil)
    {
        // delete cached video
        [[NSFileManager defaultManager] removeItemAtURL:self.videoURL error:nil];
    }
    [super viewWillDisappear:animated];
}

- (void)setColors
{
    CGFloat R = (float)0x36/255;
    CGFloat G = (float)0x36/255;
    CGFloat B = (float)0x40/255;
    self.POSTBGColor = [UIColor colorWithRed:R green:G blue:B alpha:1];
    
    R = (float)0x3D/255;
    G = (float)0x3D/255;
    B = (float)0x47/255;
    self.POSTSurfaceColor = [UIColor colorWithRed:R green:G blue:B alpha:1];
    
    R = (float)0xFF/255;
    G = (float)0xFF/255;
    B = (float)0xFF/255;
    self.POSTFontColor = [UIColor colorWithRed:R green:G blue:B alpha:1];
    
    R = (float)0x1E/255;
    G = (float)0xB9/255;
    B = (float)0x80/255;
    self.POSTButtonColor = [UIColor colorWithRed:R green:G blue:B alpha:1];
}

-(MDCButton *)selectVideoButton
{
    if(_selectVideoButton == nil)
    {
        _selectVideoButton = [[MDCButton alloc]init];
        [_selectVideoButton applyContainedThemeWithScheme:[MDCContainerScheme new]];
        [_selectVideoButton setBackgroundColor:self.POSTButtonColor];
        [_selectVideoButton setTitle:@"Select Video" forState:UIControlStateNormal];
        [_selectVideoButton addTarget:self action:@selector(selectVideoButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectVideoButton;
}



- (UIImageView *)coverImageView
{
    if(_coverImageView == nil)
    {
        _coverImageView = [[UIImageView alloc]init];
        [_coverImageView setBackgroundColor:self.POSTSurfaceColor];
        [_coverImageView.layer setCornerRadius:4];
        [_coverImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_coverImageView setClipsToBounds:YES];
        [_coverImageView addSubview:self.selectCoverImageLabel];
        [self.selectCoverImageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.coverImageView);
            make.centerY.equalTo(self.coverImageView);
        }];
        [_coverImageView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapCoverView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeCoverImage)];
        [_coverImageView addGestureRecognizer:tapCoverView];
    }
    return _coverImageView;
}

- (UILabel *)selectCoverImageLabel
{
    if(_selectCoverImageLabel == nil)
    {
        _selectCoverImageLabel = [[UILabel alloc]init];
//        [_selectCoverImageLabel setFont:[UIFont systemFontOfSize:14]];
        [_selectCoverImageLabel setFont:self.selectVideoButton.titleLabel.font];
        [_selectCoverImageLabel setTextColor:[UIColor grayColor]];
        [_selectCoverImageLabel setText:@"+ Cover Image"];
        [_selectCoverImageLabel sizeToFit];
    }
    return _selectCoverImageLabel;
}

- (MDCFilledTextField *)titleField
{
    if(_titleField == nil)
    {
        _titleField = [[MDCFilledTextField alloc]init];
        _titleField.delegate = self;
        [_titleField.label setText:@"Title"];
        [_titleField.leadingAssistiveLabel setText:@"Required"];
        [_titleField.leadingAssistiveLabel setFont:[UIFont systemFontOfSize:12]];
        [_titleField setTextColor:self.POSTFontColor forState:MDCTextControlStateEditing];
        [_titleField setTextColor:self.POSTFontColor forState:MDCTextControlStateNormal];
        [_titleField setLeadingAssistiveLabelColor:[UIColor grayColor] forState:MDCTextControlStateNormal];
        [_titleField setLeadingAssistiveLabelColor:[UIColor grayColor] forState:MDCTextControlStateEditing];
        
        [_titleField setNormalLabelColor:[UIColor grayColor] forState:MDCTextControlStateNormal];
        [_titleField setFloatingLabelColor:[UIColor grayColor] forState:MDCTextControlStateNormal];
        [_titleField setFloatingLabelColor:self.POSTFontColor forState:MDCTextControlStateEditing];
        
        [_titleField setUnderlineColor:[UIColor lightGrayColor] forState:MDCTextControlStateNormal];
        [_titleField setUnderlineColor:self.POSTFontColor forState:MDCTextControlStateEditing];
        [_titleField setFilledBackgroundColor:self.POSTSurfaceColor forState:MDCTextControlStateNormal];
        [_titleField setFilledBackgroundColor:self.POSTSurfaceColor forState:MDCTextControlStateEditing];
        [_titleField setTextColor:self.POSTFontColor];
    }
    return _titleField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == _titleField && ![[textField text] isEqualToString:@""])
    {
        [_titleField.leadingAssistiveLabel setText:@"✓"];
        CGFloat R = (float)0x1E/255;
        CGFloat G = (float)0xB9/255;
        CGFloat B = (float)0x80/255;
        [_titleField setLeadingAssistiveLabelColor:[UIColor colorWithRed:R green:G blue:B alpha:1] forState:MDCTextControlStateNormal];
        [_titleField setLeadingAssistiveLabelColor:[UIColor colorWithRed:R green:G blue:B alpha:1] forState:MDCTextControlStateEditing];
    }
    else if(textField == _titleField && [[textField text] isEqualToString:@""])
    {
        [_titleField.leadingAssistiveLabel setText:@"Required"];
        [_titleField setLeadingAssistiveLabelColor:[UIColor grayColor] forState:MDCTextControlStateNormal];
        [_titleField setLeadingAssistiveLabelColor:[UIColor grayColor] forState:MDCTextControlStateEditing];
    }
}

- (MDCFilledTextArea *)descriptionArea
{
    if(_descriptionArea == nil)
    {
        _descriptionArea = [[MDCFilledTextArea alloc]init];
        _descriptionArea.textView.delegate = self;
        [_descriptionArea.label setText:@"Description"];
        [_descriptionArea.leadingAssistiveLabel setText:@"Required"];
        [_descriptionArea.leadingAssistiveLabel setFont:[UIFont systemFontOfSize:12]];
        [_descriptionArea setTextColor:self.POSTFontColor forState:MDCTextControlStateEditing];
        [_descriptionArea setTextColor:self.POSTFontColor forState:MDCTextControlStateNormal];
        [_descriptionArea setLeadingAssistiveLabelColor:[UIColor grayColor] forState:MDCTextControlStateNormal];
        [_descriptionArea setLeadingAssistiveLabelColor:[UIColor grayColor] forState:MDCTextControlStateEditing];
        
        [_descriptionArea setNormalLabelColor:[UIColor grayColor] forState:MDCTextControlStateNormal];
        [_descriptionArea setFloatingLabelColor:[UIColor grayColor] forState:MDCTextControlStateNormal];
        [_descriptionArea setFloatingLabelColor:self.POSTFontColor forState:MDCTextControlStateEditing];
        
        [_descriptionArea setUnderlineColor:[UIColor lightGrayColor] forState:MDCTextControlStateNormal];
        [_descriptionArea setUnderlineColor:self.POSTFontColor forState:MDCTextControlStateEditing];
        [_descriptionArea setFilledBackgroundColor:self.POSTSurfaceColor forState:MDCTextControlStateNormal];
        [_descriptionArea setFilledBackgroundColor:self.POSTSurfaceColor forState:MDCTextControlStateEditing];
        [_descriptionArea setMaximumNumberOfVisibleRows:100];
        [_descriptionArea setTextColor:self.POSTFontColor forState:MDCTextControlStateNormal];
        [_descriptionArea.textView setBounces:NO];
    }
    return _descriptionArea;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView == _descriptionArea.textView && ![[textView text] isEqualToString:@""])
    {
        [_descriptionArea.leadingAssistiveLabel setText:@"✓"];
        CGFloat R = (float)0x1E/255;
        CGFloat G = (float)0xB9/255;
        CGFloat B = (float)0x80/255;
        [_descriptionArea setLeadingAssistiveLabelColor:[UIColor colorWithRed:R green:G blue:B alpha:1] forState:MDCTextControlStateNormal];
        [_descriptionArea setLeadingAssistiveLabelColor:[UIColor colorWithRed:R green:G blue:B alpha:1] forState:MDCTextControlStateEditing];
    }
    else if(textView == _descriptionArea.textView && [[textView text] isEqualToString:@""])
    {
        [_descriptionArea.leadingAssistiveLabel setText:@"Required"];
        [_descriptionArea setLeadingAssistiveLabelColor:[UIColor grayColor] forState:MDCTextControlStateNormal];
        [_descriptionArea setLeadingAssistiveLabelColor:[UIColor grayColor] forState:MDCTextControlStateEditing];
    }
}

- (MDCButton *)sendButton
{
    if(_sendButton == nil)
    {
        _sendButton = [MDCButton new];
        [_sendButton applyContainedThemeWithScheme:[MDCContainerScheme new]];
        [_sendButton setTitleFont:[UIFont systemFontOfSize:14] forState:UIControlStateNormal];
        [_sendButton setTitle:@"POST" forState:UIControlStateNormal];
        [_sendButton setBackgroundColor:self.POSTButtonColor forState:UIControlStateNormal];
        [_sendButton setMaximumSize:CGSizeMake(70, 28)];
        [_sendButton addTarget:self action:@selector(PostContent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

- (UIActivityIndicatorView *)uploadingIndicator
{
    if(_uploadingIndicator == nil)
    {
        _uploadingIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
        [_uploadingIndicator setColor:[UIColor grayColor]];
        [_uploadingIndicator setCenter:CGPointMake(self.view.frame.size.width/2, 300)];
    }
    return _uploadingIndicator;
}


#pragma mark post 事件

- (void)PostContent
{
    // check
    NSString *videoTitle = [self.titleField text];
    NSString *videoDescription = [[self.descriptionArea textView]text];
    if(self.cachedImageData == nil || self.videoURL == nil || [videoTitle isEqualToString:@""] || [videoDescription isEqualToString:@""])
    {
        MDCAlertController *alertController =
        [MDCAlertController alertControllerWithTitle:@"Not enough info"
                                             message:@"Video, cover, title and descriptions are all required"];
        MDCAlertAction *OKAction = [MDCAlertAction actionWithTitle:@"OK" handler:nil];
        [alertController addAction:OKAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    NSString *URL = @"http://159.75.1.231:5009/contents";
    NSDictionary *header = @{
        @"Authorization":[UserInfo sharedUser].token
    };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [self.uploadingIndicator startAnimating];
    
        
    [manager POST:URL parameters:nil headers:header constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // video
        [formData appendPartWithFileURL:self.videoURL name:@"video" error:nil];
        
        // cover image
        [formData appendPartWithFileData:self.cachedImageData name:@"cover" fileName:@"cover_image.jpg" mimeType:@"image/jpg"];
        
        // title
        [formData appendPartWithFormData:[videoTitle dataUsingEncoding:NSUTF8StringEncoding] name:@"title"];
        
        // description
        [formData appendPartWithFormData:[videoDescription dataUsingEncoding:NSUTF8StringEncoding] name:@"description"];
        
        // duration
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%d",self.videoDuration]dataUsingEncoding:NSUTF8StringEncoding] name:@"duration"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.uploadingIndicator stopAnimating];
        });
        NSLog(@"successed to upload");
        
        MDCAlertController *alertController =
        [MDCAlertController alertControllerWithTitle:@"Post Succeeded!" message:nil];
        MDCAlertAction *OKAction = [MDCAlertAction actionWithTitle:@"OK" handler:^(MDCAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:OKAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.uploadingIndicator stopAnimating];
        });
        
        NSLog(@"%@", error);
    }];
    
}

#pragma mark 左侧图标
- (UIImageView *)videoIcon
{
    if(_videoIcon == nil)
    {
        _videoIcon = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"video.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [_videoIcon setContentMode:UIViewContentModeScaleAspectFit];
        [_videoIcon setClipsToBounds:YES];
        [_videoIcon setTintColor:[UIColor lightGrayColor]];
    }
    return _videoIcon;
}

- (UIImageView *)imageIcon
{
    if(_imageIcon == nil)
    {
        _imageIcon = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"image.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [_imageIcon setContentMode:UIViewContentModeScaleAspectFit];
        [_imageIcon setClipsToBounds:YES];
        [_imageIcon setTintColor:[UIColor lightGrayColor]];
    }
    return _imageIcon;
}

- (UIImageView *)titleIcon
{
    if(_titleIcon == nil)
    {
        _titleIcon = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"title.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [_titleIcon setContentMode:UIViewContentModeScaleAspectFit];
        [_titleIcon setClipsToBounds:YES];
        [_titleIcon setTintColor:[UIColor lightGrayColor]];
    }
    return _titleIcon;
}

- (UIImageView *)pencilIcon
{
    if(_pencilIcon == nil)
    {
        _pencilIcon = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"edit.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [_pencilIcon setContentMode:UIViewContentModeScaleAspectFit];
        [_pencilIcon setClipsToBounds:YES];
        [_pencilIcon setTintColor:[UIColor lightGrayColor]];
    }
    return _pencilIcon;
}

#pragma mark 选视频事件
- (void)selectVideoButtonClicked
{
    PHPickerConfiguration *config = [[PHPickerConfiguration alloc] init];
    config.selectionLimit = 1;
    config.filter = [PHPickerFilter videosFilter];
    PHPickerViewController *pickerViewController = [[PHPickerViewController alloc] initWithConfiguration:config];
    pickerViewController.delegate = self;
    
    
    if(self.videoURL == nil)
    {
        [self presentViewController:pickerViewController animated:YES completion:nil];
    }
    else
    {
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *changeVideoAction = [UIAlertAction actionWithTitle:@"Select From Album" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self presentViewController:pickerViewController animated:YES completion:nil];
            }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:nil];
        UIAlertAction *preViewVideoAction = [UIAlertAction actionWithTitle:@"Preview" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self presentViewController:[[PreViewController alloc] initWithURL:self.videoURL] animated:YES completion:nil];
        }];
        
        [actionSheet addAction:changeVideoAction];
        [actionSheet addAction:cancelAction];
        [actionSheet addAction:preViewVideoAction];
        
        [self presentViewController:actionSheet animated:YES completion:nil];
    }
}

#pragma mark 选封面事件
- (void)changeCoverImage
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"Select From Album" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self presentViewController:imagePicker animated:YES completion:nil];
        }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleCancel
                                                             handler:nil];
    [actionSheet addAction:photoAction];
    [actionSheet addAction:cancelAction];
    
    if(self.videoURL != nil)
    {
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Select From Screenshot" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self presentViewController:[[PreViewController alloc]initWithURL:self.videoURL parentVC:self] animated:YES completion:nil];
        }]];
    }
    if(self.coverImage != nil)
    {
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Preview" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self presentViewController:[[BigImageViewController alloc]initWithImage:self.coverImage] animated:YES completion:nil];
        }]];
    }
    
    [self presentViewController:actionSheet animated:YES completion:nil];
    
}

- (void)UpdateCoverImage:(UIImage *)img
{
    self.coverImage = img;
    self.cachedImageData = UIImageJPEGRepresentation(img, 0.9);
    [self.selectCoverImageLabel setText:@"✓  COVER SELECTED"];
    [self.selectCoverImageLabel setTextColor:self.POSTButtonColor];
}

#pragma mark imagePicker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"%@", info);
    
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self UpdateCoverImage:selectedImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark PHPickerViewControllerDelegate
#define CachePathForURL(url) [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[url lastPathComponent]]
- (void)picker:(nonnull PHPickerViewController *)picker didFinishPicking:(nonnull NSArray<PHPickerResult *> *)results {
    [picker dismissViewControllerAnimated:YES completion:nil];
    for (PHPickerResult *result in results)
    {
        [result.itemProvider loadFileRepresentationForTypeIdentifier:@"public.movie" completionHandler:^(NSURL * _Nullable url, NSError * _Nullable error) {
            NSLog(@"before: %@",url);
            
            // 在沙盒中另存一份
            NSData *videoData = [NSData dataWithContentsOfURL:url];
            NSString *newPath = CachePathForURL(url);
            [videoData writeToFile:newPath atomically:YES];
            NSLog(@"after: %@",newPath);
            self.videoURL = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@",newPath]];
            
            // 获取时长
            AVURLAsset *asset = [AVURLAsset assetWithURL:self.videoURL];
            CMTime time = [asset duration];
            NSLog(@"时长 : %lf s", ceil(time.value/time.timescale));
            self.videoDuration = ceil(time.value/time.timescale);
        
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.selectVideoButton setBackgroundColor:self.POSTSurfaceColor];
                [self.selectVideoButton setTitle:@"✓  Video Selected" forState:UIControlStateNormal];
                [self.selectVideoButton setTitleColor:self.POSTButtonColor forState:UIControlStateNormal];
            });
        }];
    }
}

@end
