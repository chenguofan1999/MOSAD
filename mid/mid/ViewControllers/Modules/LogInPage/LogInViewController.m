//
//  LogInViewController.m
//  mid
//
//  Created by itlab on 11/29/20.
//

#import "LogInViewController.h"
#import "TabBarController.h"
#import "SceneDelegate.h"

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
        if([username isEqualToString:@"chen"] && [password isEqualToString:@"pass"])
        {
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
            window.rootViewController = [[TabBarController alloc] init];
        }
        else
        {
            NSLog(@"Wrong");
        }
    }
    else
    {
        
    }
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
