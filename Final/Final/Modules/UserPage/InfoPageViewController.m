//
//  InfoPageViewController.m
//  Final
//
//  Created by itlab on 1/7/21.
//

#import <Masonry/Masonry.h>
#import <MDCButton+MaterialTheming.h>
#import <MDCOutlinedTextArea.h>
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/SDWebImage.h>
#import "InfoPageViewController.h"
#import "UserListTableViewController.h"
#import "UserItem.h"
#import "UserInfo.h"
#import "AppConfig.h"

@interface InfoPageViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic,strong) UIImageView *avatarView;
@property (nonatomic,strong) UILabel *usernameLabel;
@property (nonatomic,strong) UILabel *bioLabel;

@property (nonatomic,strong) UILabel *followingLabel;
@property (nonatomic,strong) UILabel *followingNumberLabel;
@property (nonatomic,strong) UILabel *followerLabel;
@property (nonatomic,strong) UILabel *followerNumberLabel;
@property (nonatomic,strong) UILabel *likeLabel;
@property (nonatomic,strong) UILabel *likeNumberLabel;

@property (nonatomic,strong) MDCButton *actionButton;

@property (nonatomic,strong) MDCOutlinedTextArea *textArea;
@property (nonatomic,strong) MDCButton *submitBioButton;
// data
@property (nonatomic) UserItem *userItem;
@end

@implementation InfoPageViewController
-(instancetype) initWithUsername:(NSString *)username
{
    self = [super init];
    self.username = username;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.avatarView];
    [self.view addSubview:self.usernameLabel];
    [self.view addSubview:self.actionButton];
    [self.view addSubview:self.followingNumberLabel];
    [self.view addSubview:self.followingLabel];
    [self.view addSubview:self.followerNumberLabel];
    [self.view addSubview:self.followerLabel];
    [self.view addSubview:self.likeNumberLabel];
    [self.view addSubview:self.likeLabel];
    [self.view addSubview:self.bioLabel];
    [self.view addSubview:self.textArea];
    [self.view addSubview:self.submitBioButton];
    
    
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view).offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarView).offset(5);
        make.left.mas_equalTo(self.avatarView.mas_right).offset(20);
    }];
    
    [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.usernameLabel);
        make.top.mas_equalTo(self.usernameLabel.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(150, 40));
    }];
    
    [self.followerNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarView).offset(12);
        make.top.mas_equalTo(self.avatarView.mas_bottom).offset(15);
    }];
    
    [self.followerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.followerNumberLabel.mas_right).offset(6);
        make.centerY.equalTo(self.followerNumberLabel);
    }];
    
    [self.followingNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.followerLabel.mas_right).offset(26);
        make.centerX.equalTo(self.view).offset(-30);
        make.centerY.equalTo(self.followerLabel);
    }];
    
    [self.followingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.followingNumberLabel.mas_right).offset(6);
        make.centerY.equalTo(self.followingNumberLabel);
    }];
    
    [self.likeNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
//        make.left.mas_equalTo(self.followingLabel.mas_right).offset(20);
        make.right.mas_equalTo(self.likeLabel.mas_left).offset(-6);
        make.centerY.equalTo(self.followingLabel);
    }];
    
    [self.likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.likeNumberLabel.mas_right).offset(6);
        make.right.equalTo(self.view).offset(-40);
        make.centerY.equalTo(self.likeNumberLabel);
    }];
    
    UILabel *bioTitleLabel = [[UILabel alloc]init];
    [bioTitleLabel setText:@"Bio"];
    [bioTitleLabel setTextColor:[UIColor darkGrayColor]];
    [bioTitleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.view addSubview:bioTitleLabel];
    
    UIView *underLine = [[UIView alloc]init];
    [underLine setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:underLine];
    
    [bioTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.followingNumberLabel.mas_bottom).offset(30);
        make.left.equalTo(self.view).offset(30);
    }];
    
    [underLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bioTitleLabel.mas_bottom).offset(2);
        make.left.equalTo(self.view).offset(30);
        make.height.mas_equalTo(1);
        make.right.equalTo(self.view).offset(-30);
    }];
    
    [self.bioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bioTitleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
    }];
    
    [self.textArea mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bioTitleLabel.mas_bottom).offset(11);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
    }];
    
    [self.submitBioButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textArea.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.mas_equalTo(50);
    }];
    
    
    [self loadData];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    // 阴影
//    [self.navigationController.navigationBar.layer setShadowColor:[UIColor clearColor].CGColor];
//    // 线条
//    [self.navigationController.navigationBar setValue:@(YES) forKeyPath:@"hidesShadow"];
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    // 阴影
//    [self.navigationController.navigationBar.layer setShadowColor:[UIColor darkGrayColor].CGColor];
//    // 线条
//    [self.navigationController.navigationBar setValue:@(NO) forKeyPath:@"hidesShadow"];
//}




#pragma mark 懒加载
- (UIImageView *)avatarView
{
    if(_avatarView == nil)
    {
        _avatarView = [[UIImageView alloc]init];
        [_avatarView setBackgroundColor:[UIColor grayColor]];
        [_avatarView setContentMode:UIViewContentModeScaleAspectFill];
        [_avatarView setClipsToBounds:YES];
        [_avatarView.layer setCornerRadius:50];
    }
    return _avatarView;
}

- (UILabel *)usernameLabel
{
    if(_usernameLabel == nil)
    {
        _usernameLabel = [[UILabel alloc]init];
        [_usernameLabel setFont:[UIFont boldSystemFontOfSize:24]];
    }
    return _usernameLabel;
}

- (UILabel *)bioLabel
{
    if(_bioLabel == nil)
    {
        _bioLabel = [[UILabel alloc]init];
        [_bioLabel setNumberOfLines:0];
        [_bioLabel setTextColor:[UIColor darkGrayColor]];
        [_bioLabel setFont:[UIFont systemFontOfSize:17]];
    }
    return _bioLabel;
}

- (UILabel *)followingLabel
{
    if(_followingLabel == nil)
    {
        _followingLabel = [[UILabel alloc]init];
        [_followingLabel setTextColor:[UIColor grayColor]];
        [_followingLabel setFont:[UIFont systemFontOfSize:18]];
        [_followingLabel setText:@"Following"];
    }
    return _followingLabel;
}


- (UILabel *)followerLabel
{
    if(_followerLabel == nil)
    {
        _followerLabel = [[UILabel alloc]init];
        [_followerLabel setTextColor:[UIColor grayColor]];
        [_followerLabel setFont:[UIFont systemFontOfSize:18]];
        [_followerLabel setText:@"Follower"];
    }
    return _followerLabel;
}


- (UILabel *)likeLabel
{
    if(_likeLabel == nil)
    {
        _likeLabel = [[UILabel alloc]init];
        [_likeLabel setTextColor:[UIColor grayColor]];
        [_likeLabel setFont:[UIFont systemFontOfSize:18]];
        [_likeLabel setText:@"Like"];
    }
    return _likeLabel;
}

- (UILabel *)followingNumberLabel
{
    if(_followingNumberLabel == nil)
    {
        _followingNumberLabel = [[UILabel alloc]init];
        [_followingNumberLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [_followingNumberLabel setUserInteractionEnabled:YES];
        [_followingNumberLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toFollowingPage)]];
    }
    return _followingNumberLabel;
}


- (UILabel *)followerNumberLabel
{
    if(_followerNumberLabel == nil)
    {
        _followerNumberLabel = [[UILabel alloc]init];
        [_followerNumberLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [_followerNumberLabel setUserInteractionEnabled:YES];
        [_followerNumberLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toFollowerPage)]];
    }
    return _followerNumberLabel;
}


- (UILabel *)likeNumberLabel
{
    if(_likeNumberLabel == nil)
    {
        _likeNumberLabel = [[UILabel alloc]init];
        [_likeNumberLabel setFont:[UIFont boldSystemFontOfSize:18]];
    }
    return _likeNumberLabel;
}

- (MDCButton *)actionButton
{
    if(_actionButton == nil)
    {
        _actionButton = [[MDCButton alloc]init];
        [_actionButton applyContainedThemeWithScheme:[MDCContainerScheme new]];
        [_actionButton addTarget:self action:@selector(actionButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionButton;
}

- (MDCOutlinedTextArea *)textArea
{
    if(_textArea == nil)
    {
        _textArea = [[MDCOutlinedTextArea alloc]init];
//        _textArea.textView.delegate = self;
        [_textArea.label setText:@""];
        [_textArea setNormalLabelColor:[UIColor grayColor] forState:MDCTextControlStateNormal];
        [_textArea setFloatingLabelColor:[UIColor grayColor] forState:MDCTextControlStateNormal];
        [_textArea setFloatingLabelColor:[AppConfig getMainColor] forState:MDCTextControlStateEditing];
        
        [_textArea setOutlineColor:[UIColor lightGrayColor] forState:MDCTextControlStateNormal];
        [_textArea setOutlineColor:[AppConfig getMainColor] forState:MDCTextControlStateEditing];
        [_textArea setMaximumNumberOfVisibleRows:100];
        [_textArea.textView setBounces:NO];
        [_textArea setHidden:YES];
    }
    return _textArea;
}

- (MDCButton *)submitBioButton
{
    if(_submitBioButton == nil)
    {
        _submitBioButton = [[MDCButton alloc]init];
        [_submitBioButton applyContainedThemeWithScheme:[MDCContainerScheme new]];
        [_submitBioButton setBackgroundColor:[AppConfig getMainColor]];
        [_submitBioButton setTitle:@"Submit" forState:UIControlStateNormal];
        [_submitBioButton addTarget:self action:@selector(submitBioString) forControlEvents:UIControlEventTouchUpInside];
        [_submitBioButton setHidden:YES];
    }
    return _submitBioButton;
}



#pragma mark to follow page

- (void)toFollowingPage
{
    UserListTableViewController *userList =[[UserListTableViewController alloc]initWithUsername:self.username type:UserListTableTypeFollowing];
    [userList.navigationItem setTitle:@"Subscribing List"];
    [self.navigationController pushViewController:userList animated:YES];
}

- (void)toFollowerPage
{
    UserListTableViewController *userList =[[UserListTableViewController alloc]initWithUsername:self.username type:UserListTableTypeFollowed];
    [userList.navigationItem setTitle:@"Subscribers List"];
    [self.navigationController pushViewController:userList animated:YES];
}

#pragma mark action button
- (void)actionButtonClicked
{
    if(self.username == [UserInfo sharedUser].username)
    {
        // 修改个人资料
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Edit Profile" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *editBioAction = [UIAlertAction actionWithTitle:@"Edit Bio" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self editBioAction];
        }];
        UIAlertAction *avatarAction = [UIAlertAction actionWithTitle:@"Upload Avatar" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:nil];
        
        [actionSheet addAction:editBioAction];
        [actionSheet addAction:avatarAction];
        [actionSheet addAction:cancelAction];
        
        [self presentViewController:actionSheet animated:YES completion:nil];
        
        [self loadData];
    }
    else
    {
        NSString *URL = [NSString stringWithFormat:@"http://159.75.1.231:5009/user/following/%@",self.userItem.userName];
        NSDictionary *header = @{
            @"Authorization":[UserInfo sharedUser].token
        };
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        if(self.userItem.followedByMe == YES)
        {
            // Unfollow
            [manager DELETE:URL parameters:nil headers:header success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"%@",responseObject);
                NSDictionary *response = (NSDictionary *)responseObject;
                if([response[@"status"] isEqualToString:@"success"])
                {
                    NSLog(@"unfollow succeeded");
                }
                [self loadData];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"unfollow failed");
            }];
        }
        else
        {
            // Follow
            [manager PUT:URL parameters:nil headers:header success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"%@",responseObject);
                NSDictionary *response = (NSDictionary *)responseObject;
                if([response[@"status"] isEqualToString:@"success"])
                {
                    NSLog(@"follow succeeded");
                }
                [self loadData];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"follow failed");
            }];
        }
    }
}


- (void)editBioAction
{
    [self.bioLabel setHidden:YES];
    [self.textArea.textView setText:[self.bioLabel text]];
    [self.textArea setHidden:NO];
    [self.submitBioButton setHidden:NO];
}

- (void)submitBioString
{
    [self.bioLabel setHidden:NO];
    [self.textArea setHidden:YES];
    [self.submitBioButton setHidden:YES];
    NSString *newBio = [self.textArea.textView text];
//    [self.bioLabel setText:newBio];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *URL = @"http://159.75.1.231:5009/user/bio";
    NSDictionary *header = @{
        @"Authorization":[UserInfo sharedUser].token
    };
    NSDictionary *body = @{
        @"bio":newBio
    };
    
    [manager PUT:URL parameters:body headers:header success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"successed to edit bio");
        [self loadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed to edit bio");
    }];
}

#pragma mark imagePicker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"%@", info);
    
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *imgData = UIImageJPEGRepresentation(selectedImage, 0.9);
    
    // upload as avatar
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *URL = @"http://159.75.1.231:5009/user/avatar";
    NSDictionary *header = @{
        @"Authorization":[UserInfo sharedUser].token
    };
    
    [manager POST:URL parameters:nil headers:header constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imgData name:@"avatar" fileName:@"avatar_image.jpg" mimeType:@"image/jpg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"successed to upload avatar");
        [self loadData];
        [UserInfo updateInfo];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed to upload avatar");
    }];
    
    
//    id block = ^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileData:imgData name:@"avatar" fileName:@"avatar_image.jpg" mimeType:@"image/jpg"];
//    };


    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 加载界面
- (void)updateAllViews
{
    [self.usernameLabel setText:self.userItem.userName];
    [self.bioLabel setText:self.userItem.bio];
    [self.followerNumberLabel setText:[NSString stringWithFormat:@"%d",self.userItem.followerNum]];
    [self.followingNumberLabel setText:[NSString stringWithFormat:@"%d",self.userItem.followingNum]];
    [self.likeNumberLabel setText:[NSString stringWithFormat:@"%d",self.userItem.likeNum]];

//    [self.usernameLabel sizeToFit];
//    [self.bioLabel sizeToFit];
//    [self.followerNumberLabel sizeToFit];
//    [self.followingNumberLabel sizeToFit];
//    [self.likeNumberLabel sizeToFit];
    
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://159.75.1.231:5009%@", self.userItem.avatarURL]] placeholderImage:[UIImage imageNamed:@"edvard-munch.png"]];
    
    // action button
    if(self.username == [UserInfo sharedUser].username)
    {
//        [self.actionButton setBackgroundColor:[UIColor grayColor]];
        [self.actionButton setTitle:@"Edit Profile" forState:UIControlStateNormal];
    }
    else if(self.userItem.followedByMe == YES)
    {
        [self.actionButton setBackgroundColor:[UIColor grayColor]];
        [self.actionButton setTitle:@"Following" forState:UIControlStateNormal];
    }
    else
    {
        [self.actionButton setBackgroundColor:[AppConfig getMainColor]];
        [self.actionButton setTitle:@"Follow" forState:UIControlStateNormal];
    }
    
    [self.view layoutIfNeeded];
}

- (void)loadData
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *URL = [NSString stringWithFormat:@"http://159.75.1.231:5009/users/%@",self.username];
    NSDictionary *header = @{
        @"Authorization":[UserInfo sharedUser].token
    };
    
    [manager GET:URL parameters:nil headers:header progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *response = (NSDictionary *)responseObject;
        if([response[@"status"] isEqualToString:@"success"])
        {
            self.userItem = [[UserItem alloc]initWithDict:response[@"data"]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateAllViews];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed to get user data");
    }];
    
}


@end
