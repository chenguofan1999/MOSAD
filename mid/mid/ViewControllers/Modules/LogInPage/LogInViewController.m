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
@property (nonatomic,strong) IBOutlet UILabel *header;
@property (nonatomic,strong) IBOutlet UITextField *usernameField;
@property (nonatomic,strong) IBOutlet UITextField *passwordField;
@property (nonatomic,strong) IBOutlet UIButton *logInOrSignUpButton;
@property (nonatomic,strong) IBOutlet UILabel *switchLabel;
@property (nonatomic) bool isLogIn;
@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_header setText:@"请登录。"];
    [_logInOrSignUpButton setTitle:@"登录" forState:UIControlStateNormal];
    [_switchLabel setText:@"没有账号？立即创建一个。"];
    
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
    NSString *password = [_passwordField text];
    if(_isLogIn)
    {
        [self logInWithUsername:username AndPassword:password];
    }
    else
    {
        
    }
}

- (void)logInWithUsername:(NSString *)username
              AndPassword:(NSString *)password
{
    NSString *URL = @"http://172.18.178.56/api/user/login/pass";
    NSDictionary *body = @{
        @"name":username,
        @"password":password
    };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:URL parameters:body headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"\nRequest success with responce %@", responseObject);
        NSDictionary *response = (NSDictionary *)responseObject;
        
        // 验证是否登录成功
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

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        NSLog(@"request failure");
    }];
    
}


- (void)signUpWithUsername:(NSString *)username
               andPassword:(NSString *)password
{
    
}

# pragma mark 切换
- (void)switchMode
{
    if(_isLogIn)
    {
        [_header setText:@"请注册。"];
        [_logInOrSignUpButton setTitle:@"注册" forState:UIControlStateNormal];
        [_switchLabel setText:@"又想起来了？立即登录。"];
        [_usernameField setText:@""];
        [_passwordField setText:@""];
        _isLogIn = NO;
    }
    else
    {
        [_header setText:@"请登录。"];
        [_logInOrSignUpButton setTitle:@"登录" forState:UIControlStateNormal];
        [_switchLabel setText:@"没有账号？立即创建一个。"];
        [_usernameField setText:@""];
        [_passwordField setText:@""];
        _isLogIn = YES;
    }
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
