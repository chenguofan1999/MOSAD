//
//  LoginPageViewController.m
//  Final
//
//  Created by itlab on 12/29/20.
//

#import "LoginPageViewController.h"
#import <MaterialComponents/MDCFilledTextField.h>
#import <MaterialTextControls+OutlinedTextFields.h>
#import <MaterialComponents/MDCButton+MaterialTheming.h>
#import <MaterialDialogs.h>
#import "SceneDelegate.h"
#import "AppConfig.h"
#import "MainTabBarController.h"
#import "UserInfo.h"
#import <sys/utsname.h>
#import <Masonry/Masonry.h>
#import <AFNetworking/AFNetworking.h>

@interface LoginPageViewController () <UITextFieldDelegate>
@property (nonatomic) bool isLogin;
@property (nonatomic, strong) UIImageView *appLogo;
@property (nonatomic, strong) MDCButton *modeButton;
@property (nonatomic, strong) MDCButton *actionButton;
@property (nonatomic, strong) MDCFilledTextField *usernameField;
@property (nonatomic, strong) MDCFilledTextField *passwordField;
@end

@implementation LoginPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isLogin = YES;
    
    [self.view addSubview:self.appLogo];
    [self.view addSubview:self.modeButton];
    [self.view addSubview:self.usernameField];
    [self.view addSubview:self.passwordField];
    [self.view addSubview:self.actionButton];
    
    
    __weak LoginPageViewController *weakSelf = self;
    [self.appLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(180, 70));
        make.top.equalTo(weakSelf.view).offset(120);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
    [self.usernameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(300, 40));
        make.top.equalTo(self.appLogo.mas_bottom).offset(60);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];

    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(300, 40));
        make.top.equalTo(self.usernameField.mas_bottom).offset(60);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];

    [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(130, 40));
        make.bottom.equalTo(weakSelf.view).offset(-60);
        make.right.equalTo(self.passwordField.mas_right);
    }];
    
    [self.modeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(160, 40));
        make.bottom.equalTo(weakSelf.view).offset(-60);
        make.left.equalTo(self.passwordField.mas_left);
    }];
}

- (MDCButton *)modeButton
{
    if(_modeButton) return _modeButton;
    _modeButton = [MDCButton new];
    [_modeButton applyTextThemeWithScheme:[MDCContainerScheme new]];
    [_modeButton setTitle:@"Create Account" forState:UIControlStateNormal];
    [_modeButton setTitleColor:[AppConfig getMainColor] forState:UIControlStateNormal];
    [_modeButton addTarget:self action:@selector(changeMode) forControlEvents:UIControlEventTouchUpInside];
    return _modeButton;
}

-(UIImageView *)appLogo
{
    if(_appLogo != nil) return _appLogo;
    _appLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Yourtube1.png"]];
    [_appLogo setClipsToBounds:YES];

    return _appLogo;
}


- (MDCButton *)actionButton
{
    if(_actionButton != nil) return _actionButton;
    _actionButton = [MDCButton new];
    [_actionButton setTitle:@"Log in" forState:UIControlStateNormal];
    [_actionButton setBackgroundColor:[AppConfig getMainColor]];
    [_actionButton addTarget:self action:@selector(actionButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    return _actionButton;
}


- (MDCFilledTextField *)usernameField
{
    if(_usernameField != nil) return _usernameField;
    _usernameField = [[MDCFilledTextField alloc]init];
    [_usernameField setFilledBackgroundColor:[UIColor systemGray5Color] forState:MDCTextControlStateNormal];
    [_usernameField setFilledBackgroundColor:[UIColor systemGray5Color] forState:MDCTextControlStateEditing];
    [_usernameField setLeadingAssistiveLabelColor:[UIColor whiteColor] forState:MDCTextControlStateNormal];
    [_usernameField setLeadingAssistiveLabelColor:[UIColor grayColor] forState:MDCTextControlStateEditing];
    [_usernameField setNormalLabelColor:[UIColor grayColor] forState:MDCTextControlStateNormal];
    [_usernameField setUnderlineColor:[UIColor lightGrayColor] forState:MDCTextControlStateNormal];
    [_usernameField setUnderlineColor:[AppConfig getMainColor] forState:MDCTextControlStateEditing];
    [_usernameField setFloatingLabelColor:[AppConfig getMainColor] forState:MDCTextControlStateEditing];
    _usernameField.label.text = @"Username";
    [_usernameField sizeToFit];
    return _usernameField;
}

- (MDCFilledTextField *)passwordField
{
    if(_passwordField != nil) return _passwordField;
    _passwordField = [[MDCFilledTextField alloc]init];
    [_passwordField setFilledBackgroundColor:[UIColor systemGray5Color] forState:MDCTextControlStateNormal];
    [_passwordField setFilledBackgroundColor:[UIColor systemGray5Color] forState:MDCTextControlStateEditing];
    [_passwordField setLeadingAssistiveLabelColor:[UIColor whiteColor] forState:MDCTextControlStateNormal];
    [_passwordField setLeadingAssistiveLabelColor:[UIColor grayColor] forState:MDCTextControlStateEditing];
    [_passwordField setNormalLabelColor:[UIColor grayColor] forState:MDCTextControlStateNormal];
    [_passwordField setUnderlineColor:[UIColor lightGrayColor] forState:MDCTextControlStateNormal];
    [_passwordField setUnderlineColor:[AppConfig getMainColor] forState:MDCTextControlStateEditing];
    [_passwordField setFloatingLabelColor:[AppConfig getMainColor] forState:MDCTextControlStateEditing];
    _passwordField.label.text = @"Password";
//    [_passwordField setSecureTextEntry:YES];
    [_passwordField sizeToFit];
    return _passwordField;
}

- (void)actionButtonPressed
{
    NSString* username = [self.usernameField text];
    NSString* password = [self.passwordField text];
    
    if(_isLogin)
        [self loginWithUsername:username Password:password];
    else
        [self signupWithUsername:username Password:password];
}

- (void)changeMode
{
    [UIView animateWithDuration:0.8 animations:^{
        [self.usernameField setAlpha:0];
        [self.passwordField setAlpha:0];
    }];
    
    if(_isLogin)
    {
        _isLogin = NO;
        [self.actionButton setTitle:@"Create" forState:UIControlStateNormal];
        [self.modeButton setTitle:@"Log in" forState:UIControlStateNormal];
        [self.usernameField.leadingAssistiveLabel setText:@"Unique Identifying Username"];
        [self.passwordField.leadingAssistiveLabel setText:@"Any but empty string"];
    }
    else
    {
        _isLogin = YES;
        [self.actionButton setTitle:@"Log in" forState:UIControlStateNormal];
        [self.modeButton setTitle:@"Create account" forState:UIControlStateNormal];
        [self.usernameField.leadingAssistiveLabel setText:@""];
        [self.passwordField.leadingAssistiveLabel setText:@""];
    }
    
    [UIView animateWithDuration:0.8 animations:^{
        [self.usernameField setAlpha:1];
        [self.passwordField setAlpha:1];
    }];
}

- (void)signupWithUsername:(NSString *)username Password:(NSString *)password
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *URL = @"http://159.75.1.231:5009/signup";
    
    NSDictionary *body = @{
        @"username":username,
        @"password":password
    };
    
    [manager POST:URL parameters:body headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *response = (NSDictionary *)responseObject;
        if([response[@"status"] isEqualToString:@"success"])
        {
            [self alertWithUsername:username Password:password];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed to sign up");
    }];
}

- (void)loginWithUsername:(NSString *)username Password:(NSString *)password
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *URL = @"http://159.75.1.231:5009/login";
    
    NSDictionary *body = @{
        @"username":username,
        @"password":password
    };
    
    [manager POST:URL parameters:body headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *response = (NSDictionary *)responseObject;
        if([response[@"status"] isEqualToString:@"success"])
        {
            // 登录成功，现在更新本地用户信息
            UserInfo *sharedInfo = [UserInfo sharedUser];
            NSString *tokenString = response[@"token"];
            sharedInfo.token = tokenString;
            NSString *getInfoURL = @"http://159.75.1.231:5009/user";
            NSDictionary *header = @{@"Authorization":tokenString};
            [manager GET:getInfoURL parameters:nil headers:header progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"%@", responseObject);
                NSDictionary *response = (NSDictionary *)responseObject;
                if([response[@"status"] isEqualToString:@"success"])
                {
                    [UserInfo configUser:response[@"data"]];
                    // 跳转到app页面
                    [SceneDelegate jumpToTabBar];
                    
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"failed to get userinfo");
            }];
            
            // 同时获取用户关注的Tag
            NSString *getTagsURL = @"http://159.75.1.231:5009/user/tags";
            [manager GET:getTagsURL parameters:nil headers:header progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"%@", responseObject);
                NSDictionary *response = (NSDictionary *)responseObject;
                if([response[@"status"] isEqualToString:@"success"])
                {
                    UserInfo *sharedInfo = [UserInfo sharedUser];
                    sharedInfo.userTags = [NSMutableArray new];
                    NSArray *tags = response[@"data"];
                    for(int i = 0; i < [tags count]; i++)
                        [[sharedInfo mutableArrayValueForKey:@"userTags"] addObject:tags[i]];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"failed to get user tags");
            }];
        
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed to login");
    }];
}

- (void)alertWithUsername:(NSString *)username Password:(NSString *)password
{
    MDCAlertController *alertController =
    [MDCAlertController alertControllerWithTitle:@"Sign up success"
                                         message:@"You have created a new account, directly log in?"];

    MDCAlertAction *OKAction = [MDCAlertAction actionWithTitle:@"OK" handler:^(MDCAlertAction *action) {
        [self loginWithUsername:username Password:password];
    }];
    
    MDCAlertAction *CancelAction = [MDCAlertAction actionWithTitle:@"CANCEL" handler:^(MDCAlertAction *action) {
        [self changeMode];
        [self.usernameField setText:username];
        [self.passwordField setText:password];
    }];

    [alertController addAction:CancelAction];
    [alertController addAction:OKAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
