//
//  InsertViewController.m
//  hw2
//
//  Created by itlab on 2020/10/28.
//  Copyright © 2020 itlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InsertViewController.h"
#import "FindViewController.h"
#import "AppDelegate.h"

@interface InsertViewController()
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UITextField *timeTextField;
@property (nonatomic, strong) UITextField *locationTextField;
@property (nonatomic, strong) UITextField *siteTextField;
@property (nonatomic, strong) UITextView *thoughtsTextField;

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIView *picView;
@property (nonatomic, strong) UIButton *addImageButton;
@property (nonatomic, strong) NSMutableArray *picCache;
@property (nonatomic, strong) NSArray *picFrames;
@end

@implementation InsertViewController

- (instancetype)init
{
    if(self = [super init])
    {
        int w = self.view.bounds.size.width;
        int h = self.view.bounds.size.height;
        
        // 背景颜色
        self.view.backgroundColor = [UIColor whiteColor];
        
        // 设置 tab 栏中的样式
        self.tabBarItem.title = @"打卡";
        
        UIImage *icon1 = [UIImage imageNamed:@"mark-off@2x.png"];
        self.tabBarItem.image = icon1;
        UIImage *icon2 = [UIImage imageNamed:@"mark-on@2x.png"];
        self.tabBarItem.selectedImage = icon2;
        
        
        // 5个titles
        NSArray *titles = @[@"时间",@"地点",@"景点",@"心得",@"配图"];
        for(int i = 0; i < 5; i ++)
        {
            UILabel *newLable = [[UILabel alloc]initWithFrame:CGRectMake(30, i == 4? 550 : 150 + 70 * i, 40, 40)];
            newLable.text = titles[i];
            newLable.highlighted = YES;
            [self.view addSubview:newLable];
        }
        
        // 4个文本框, 前三个是textField, 最后一个是多行的textView
        _timeTextField = [[UITextField alloc]init];
        _locationTextField = [[UITextField alloc]init];
        _siteTextField = [[UITextField alloc]init];
        
        NSArray *textFields = @[_timeTextField, _locationTextField, _siteTextField];
        for(int i = 0; i < 3; i++)
        {
            // 三个textField的位置和样式
            [textFields[i] setFrame:CGRectMake(75, 150 + 70 * i, w - 110, 40)];
            [textFields[i] setBorderStyle:UITextBorderStyleRoundedRect];
            [[textFields[i] layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
            [[textFields[i] layer] setBorderWidth:1];
            [[textFields[i] layer] setCornerRadius:3];
    
            [self.view addSubview:textFields[i]];
        }
        [_timeTextField setPlaceholder:@"例如：Feb 30"];
        [_locationTextField setPlaceholder:@"例如：Beijing"];
        [_siteTextField setPlaceholder:@"例如：House of dictator"];
        
        // textView 的位置、样式
        _thoughtsTextField = [[UITextView alloc]init];
        _thoughtsTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _thoughtsTextField.layer.borderWidth = 1;
        _thoughtsTextField.layer.cornerRadius = 3;
        _thoughtsTextField.frame = CGRectMake(75, 360, w - 110, 160);
        _thoughtsTextField.font = [UIFont systemFontOfSize:22];
        [self.view addSubview:_thoughtsTextField];
        
        
        // 发布button
        UIButton *releaseButton = [[UIButton alloc]initWithFrame:CGRectMake(w - 80, h - 145, 60, 40)];
        
        releaseButton.layer.cornerRadius = 3;
        releaseButton.layer.masksToBounds = YES;
        releaseButton.backgroundColor = [UIColor lightGrayColor];
        
        [releaseButton setTitle:@"发布" forState:UIControlStateNormal];
        [releaseButton addTarget:self
                      action:@selector(releaseData)
            forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:releaseButton];
        
        
        
        // 整个添加图片部分
        
        // picView: at most 6 blocks of 2 x 3, last of which is the addImageButton
        _picView = [[UIView alloc]initWithFrame:CGRectMake(75, 540, 300, 200)];
        _picFrames = [[NSMutableArray alloc] init];
        _picFrames = @[[NSValue valueWithCGRect:CGRectMake(20, 20, 70, 70)],
                       [NSValue valueWithCGRect:CGRectMake(110, 20, 70, 70)],
                       [NSValue valueWithCGRect:CGRectMake(200, 20, 70, 70)],
                       [NSValue valueWithCGRect:CGRectMake(20, 110, 70, 70)],
                       [NSValue valueWithCGRect:CGRectMake(110, 110, 70, 70)],
                       [NSValue valueWithCGRect:CGRectMake(200, 110, 70, 70)]];
        _picCache = [[NSMutableArray alloc] init];
        
        _addImageButton = [[UIButton alloc]initWithFrame:[[_picFrames objectAtIndex:0] CGRectValue]];
        // addImageButton 的样式
        _addImageButton.backgroundColor = [UIColor whiteColor];
        
        _addImageButton.layer.shadowColor = [UIColor blackColor].CGColor;
        _addImageButton.layer.shadowOffset = CGSizeMake(1, 1);
        _addImageButton.layer.shadowRadius = 4;
        _addImageButton.layer.shadowOpacity = 0.2;
        
        [_addImageButton setTitle:@"+" forState:UIControlStateNormal];
        [_addImageButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _addImageButton.titleLabel.font = [UIFont systemFontOfSize:40];
        _addImageButton.enabled = YES;
        [_addImageButton addTarget:self action:@selector(choosePic) forControlEvents:UIControlEventTouchUpInside];
        [_picView addSubview:_addImageButton];
        
        [self.view addSubview:_picView];
        

    }
    return self;
}

    
- (void)viewDidLoad
{
    [self.navigationItem setTitle:[NSString stringWithFormat:@"添加打卡"]];
    [super viewDidLoad];
}


- (void)releaseData
{
    // 读取文本框数据
    NSString *date = [_timeTextField text];
    if([date isEqualToString:@""])
    {
        [self Alert:@"请输入日期"];
        return;
    }
    
    NSString *location = [_locationTextField text];
    if([location isEqualToString:@""])
    {
        [self Alert:@"请输入地点（城市、国家、地区）"];
        return;
    }
    NSString *spot = [_siteTextField text];
    
    if([spot isEqualToString:@""])
    {
        [self Alert:@"请输入地点（景点、场所）"];
        return;
    }
    
    NSString *thoughts = [_thoughtsTextField text];
    
    UIImage *displayedInFindView = [UIImage imageNamed:@"berlin-tv-tower.png"];
    
    // 提交数据
    AppDelegate *myDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [myDelegate.items insertObject:[[Item alloc]initWithDate:date
                                                 andLocation:location
                                                     andSpot:spot
                                                 andThoughts:thoughts
                                                     andPics:_picCache
                                                     andIcon:displayedInFindView] atIndex:0];
    
    
    // 清空图片缓存
    _picCache = [[NSMutableArray alloc]init];
    
    // 提示已发布
    [self Alert:@"已发布"];
    
    // 跳到 find 页面
    [self.tabBarController setSelectedIndex:0];
    
}

#pragma mark 选择图片
-(void)choosePic
{
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = YES;
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    [actionSheet addAction:photoAction];
    [actionSheet addAction:cancelAction];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
    [self presentViewController:_imagePicker animated:YES completion:nil];
}

// 对选中图片的处理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    // selectedImage 即为选中的照片
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSInteger n = [_picCache count];
    if(n < 5)
    {
        UIImageView *newPicView = [[UIImageView alloc]initWithFrame:[[_picFrames objectAtIndex:n]CGRectValue]];
        newPicView.image = selectedImage;
        [_picView addSubview:newPicView];
        _addImageButton.frame = [[_picFrames objectAtIndex: n + 1]CGRectValue];
        [_picCache addObject:selectedImage];
    }
}
    

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)Alert:(NSString *)msg {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    
    // 显示对话框
    [self presentViewController:alert animated:true completion:nil];
}


@end
