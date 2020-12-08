//
//  logInViewController.m
//  hw3
//
//  Created by itlab on 12/7/20.
//

#import "logInViewController.h"
#import "InfoPageViewController.h"
#import "ViewController.h"
#import "GalleryViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface logInViewController ()
@property (nonatomic,strong) IBOutlet UITextField *usernameField;
@property (nonatomic,strong) IBOutlet UITextField *passwordField;
@property (nonatomic,strong) IBOutlet UILabel *logInHeader;
@property (nonatomic,strong) IBOutlet UIButton *logInButton;
@end

@implementation logInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 样式
    [_passwordField setSecureTextEntry:YES];
    [_logInButton.layer setCornerRadius:5];
    
    NSString *homeDirectory = NSHomeDirectory();
    NSLog(@"homeDirectory = %@",homeDirectory);
}

# pragma mark 登录/注册
- (IBAction)logIn:(id)sender
{
    NSString *username = [_usernameField text];
    NSString *password = [_passwordField text];
    
    NSString *URL = @"http://172.18.176.202:3333/hw3/signup";
    NSDictionary *dict = @{
        @"name" : username,
        @"pwd"  : password
    };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:URL parameters:dict headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"\nRequest success with responce %@", responseObject);
        NSDictionary *response = (NSDictionary *)responseObject;
        
        // 登录成功
        if([[response valueForKey:@"msg"] isEqualToString:@"success"])
        {
//            [self Alert:@"登录成功"];
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
            
            // 跳转到新的页面
            UITabBarController *dest = [[UITabBarController alloc]init];
            InfoPageViewController *infoPage = [[InfoPageViewController alloc] initWithUserName:username];
            GalleryViewController *galleryPage = [[GalleryViewController alloc]init];
            dest.viewControllers = @[infoPage, galleryPage];
            window.rootViewController = dest;
        }
        else if([[response valueForKey:@"msg"] isEqualToString:@"fail"])
        {
//            [self Alert:@"登录失败，请检查用户名或密码"];
            [self Alert:@"您试下用户名:MOSAD, 密码:2020"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self Alert:@"请求失败，请检验网络环境"];
    }];
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
