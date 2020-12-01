//
//  LogInViewController.m
//  mid
//
//  Created by itlab on 11/29/20.
//

#import "LogInViewController.h"
#import "TabBarController.h"
#import "SceneDelegate.h"
#import "UserInfo.h"
#import <AFNetworking/AFNetworking.h>

@interface LogInViewController ()
@property (nonatomic,strong) IBOutlet UILabel *logInHeader;
@property (nonatomic,strong) IBOutlet UITextField *emailField;
@property (nonatomic,strong) IBOutlet UITextField *passwordField;
@property (nonatomic,strong) IBOutlet UIButton *logInOrSignUpButton;
@property (nonatomic,strong) IBOutlet UILabel *switchLabel;

@property (nonatomic,strong) IBOutlet UILabel *signUpHeader;
@property (nonatomic,strong) IBOutlet UITextField *usernameField;
@property (nonatomic) bool isLogIn;
@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_passwordField setSecureTextEntry:YES];
    
    [_logInHeader setHidden:NO];
    [_signUpHeader setHidden:YES];
    [_usernameField setHidden:YES];
    [_logInOrSignUpButton setTitle:@"登录" forState:UIControlStateNormal];
    
    [_logInOrSignUpButton.layer setCornerRadius:5];
    
    [_switchLabel setUserInteractionEnabled:YES];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(switchMode)];
    [_switchLabel addGestureRecognizer:gesture];
    _isLogIn = YES;
}



# pragma mark 登录/注册
- (IBAction)logInOrSignUp:(id)sender
{
    NSString *username = [_usernameField text];
    NSString *email = [_emailField text];
    NSString *password = [_passwordField text];
    if(_isLogIn)
    {
        [self logInWithEmail:email AndPassword:password];
    }
    else
    {
        [self signUpWithUsername:username andEmail:email andPassword:password];
    }
}

- (void)logInWithEmail:(NSString *)email
           AndPassword:(NSString *)password
{
    NSString *URL = @"http://172.18.178.56/api/user/login/pass";
    NSDictionary *body = @{
        @"name":email,
        @"password":password
    };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:URL parameters:body headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"\nRequest success with responce %@", responseObject);
        NSDictionary *response = (NSDictionary *)responseObject;
        
        // 如果登录成功
        if([[response valueForKey:@"State"] isEqualToString:@"success"])
        {
            NSLog(@"LogIn success");
            
            // 获取个人信息
            //__block NSDictionary *selfInfo = nil;
            NSString *selfURL = @"http://172.18.178.56/api/user/info/self";
            [manager GET:selfURL parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"\nSelf Info: %@", responseObject);
                NSDictionary *selfInfo = (NSDictionary *)responseObject;
                
                [UserInfo configUser:selfInfo];
                
                // 找到主界面，更改根vc
                UIWindow* window = nil;
                if (@available(iOS 13.0, *))
                {
                    for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes)
                        if (windowScene.activationState == UISceneActivationStateForegroundActive)
                        {
                            window = windowScene.windows.firstObject;
                            break;
                        }
                }
                else
                {
                    window = [UIApplication sharedApplication].keyWindow;
                }
                window.rootViewController = [[TabBarController alloc]init];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"Get self info failed somehow");
            }];
        }
        else if([[response valueForKey:@"Data"] isEqualToString:@"not found"])
        {
            [self Alert:@"没有这个账号"];
        }
        else if([[response valueForKey:@"Data"] isEqualToString:@"crypto/bcrypt: hashedPassword is not the hash of the given password"])
        {
            [self Alert:@"密码错误"];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        NSLog(@"request failure");
    }];
    
}


- (void)signUpWithUsername:(NSString *)username
                  andEmail:(NSString *)email
               andPassword:(NSString *)password
{
    NSString *URL = @"http://172.18.178.56/api/user/register";
    NSDictionary *body = @{
        @"name":username,
        @"password":password,
        @"email":email
    };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:URL parameters:body headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *response = (NSDictionary *)responseObject;
        if([response[@"State"] isEqualToString:@"success"])
        {
            [self Alert:@"注册成功"];
            [self switchMode];
            [self.emailField setText:email];
            [self.passwordField setText:password];
        }
        else
        {
            [self Alert:@"注册失败"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        NSLog(@"request failure");
    }];
}

# pragma mark 切换
- (void)switchMode
{
    if(_isLogIn)
    {
        [_logInHeader setHidden:YES];
        [_signUpHeader setHidden:NO];
        [_usernameField setHidden:NO];
        [_logInOrSignUpButton setTitle:@"注册" forState:UIControlStateNormal];
        [_switchLabel setText:@"又想起来了？立即登录。"];
        [_emailField setText:@""];
        [_passwordField setText:@""];
        _isLogIn = NO;
    }
    else
    {
        [_logInHeader setHidden:NO];
        [_signUpHeader setHidden:YES];
        [_usernameField setHidden:YES];
        [_logInOrSignUpButton setTitle:@"登录" forState:UIControlStateNormal];
        [_switchLabel setText:@"没有账号？立即创建一个。"];
        [_emailField setText:@""];
        [_passwordField setText:@""];
        _isLogIn = YES;
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
