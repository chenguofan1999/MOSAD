//
//  HomePageViewController.m
//  Final
//
//  Created by itlab on 12/28/20.
//

#import "HomePageViewController.h"
#import "SearchPageViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <MaterialComponents/MDCFilledTextField.h>
#import <MaterialTextControls+OutlinedTextFields.h>
#import <SDWebImage/UIButton+WebCache.h>
#import <Masonry/Masonry.h>
#import <MaterialDialogs.h>
#import <AFNetworking/AFNetworking.h>
#import "UserInfo.h"
#import "AppConfig.h"

@interface HomePageViewController () <tagBtnDelegate>

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.videoListTableViewController.tableView];
    [self addChildViewController:self.videoListTableViewController];
    [self.videoListTableViewController loadData];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    // This clears the title of back button
    self.navigationController.navigationBar.topItem.title = @"";
}

- (void)dealloc
{
    [[UserInfo sharedUser] removeObserver:self forKeyPath:@"userTags"];
}

- (VideoListTableViewController *)videoListTableViewController
{
    if(_videoListTableViewController == nil)
    {
        _videoListTableViewController = [[VideoListTableViewController alloc] initWithURL:@"http://159.75.1.231:5009/contents?allTags=true"];
        _videoListTableViewController.tableView.frame = self.view.frame;
        _videoListTableViewController.tableView.tableHeaderView = self.tagView;
    }
    return _videoListTableViewController;
}

- (TagView *)tagView
{
    if(_tagView == nil)
    {
        _tagView = [[TagView alloc]initWithTagArray:[UserInfo sharedUser].userTags viewType:UserTagView];
        _tagView.tagDelegate = self;
        [[UserInfo sharedUser] addObserver:self
                                forKeyPath:@"userTags"
                                   options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                   context:@"userTags changed"];
    }
    return _tagView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"监听到%@的%@属性值改变了 - %@ - %@", object, keyPath, change, context);
    self.tagView.tagArray = [UserInfo sharedUser].userTags;
    [self.tagView updateTagButtons];
}

- (void)tagBtnClick:(nonnull UIButton *)btn
{
    self.videoListTableViewController.serviceURL = [NSString stringWithFormat:@"http://159.75.1.231:5009/contents?tag=%@",[btn.titleLabel text]];
    [self.videoListTableViewController loadData];
}

- (void)longPressBtn:(UIButton *)btn {
    NSLog(@"--");
    
    // 提示是否删除 tag
    MDCAlertController *alertController =
    [MDCAlertController alertControllerWithTitle:@"Delete Tag"
                                         message:[NSString stringWithFormat:@"Sure to delete tag '%@' ?",[btn.titleLabel text]]];
    
    MDCAlertAction *OKAction = [MDCAlertAction actionWithTitle:@"YES" handler:^(MDCAlertAction *action) {
        [self deleteUserTag:[btn.titleLabel text]];
    }];
    MDCAlertAction *CancelAction = [MDCAlertAction actionWithTitle:@"NO" handler:nil];
    
    [alertController addAction:CancelAction];
    [alertController addAction:OKAction];

    [alertController setMessageColor:[UIColor darkGrayColor]];
    [alertController setButtonTitleColor:[AppConfig getMainColor]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)addBtnClick:(UIButton *)btn
{
    NSLog(@"++");
    
    MDCAlertController *alertController =
    [MDCAlertController alertControllerWithTitle:@"Follow More Tags" message:nil];
    
    MDCFilledTextField *inputField = [[MDCFilledTextField alloc]init];
    [inputField.label setText:@"Tag"];
    [inputField setNormalLabelColor:[UIColor grayColor] forState:MDCTextControlStateNormal];
    [inputField setUnderlineColor:[UIColor lightGrayColor] forState:MDCTextControlStateNormal];
    [inputField setUnderlineColor:[UIColor grayColor] forState:MDCTextControlStateEditing];
    [inputField setFloatingLabelColor:[UIColor grayColor] forState:MDCTextControlStateEditing];
    
    alertController.accessoryView = inputField;
    
    MDCAlertAction *OKAction = [MDCAlertAction actionWithTitle:@"YES" handler:^(MDCAlertAction *action) {
        NSString *newTagString = [inputField text];
        if([newTagString containsString:@" "])
        {
            alertController.message = @"space not allowed";
            [self presentViewController:alertController animated:YES completion:nil];
        }
        [self addUserTag:newTagString];
    }];
    MDCAlertAction *CancelAction = [MDCAlertAction actionWithTitle:@"NO" handler:nil];
    [alertController addAction:OKAction];
    [alertController addAction:CancelAction];
    
    [alertController setTitleColor:[UIColor blackColor]];
    [alertController setButtonTitleColor:[AppConfig getMainColor]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)allBtnClick:(UIButton *)btn
{
    self.videoListTableViewController.serviceURL = @"http://159.75.1.231:5009/contents?allTags=true";
    [self.videoListTableViewController loadData];
}

- (void)deleteUserTag:(NSString *)tagName
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", nil];
    
    NSString *URL = @"http://159.75.1.231:5009/user/tags";
    NSDictionary *header = @{
        @"Authorization":[UserInfo sharedUser].token
    };
    NSDictionary *body = @{
        @"tag":tagName
    };
    
    [manager DELETE:URL parameters:body headers:header success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *response = (NSDictionary *)responseObject;
        if([response[@"status"] isEqualToString:@"success"])
        {
            NSLog(@"delete tag success");
            [UserInfo sharedUser].userTags = response[@"data"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed to delete tag %@",tagName);
    }];
}

- (void)addUserTag:(NSString *)tagName
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *URL = @"http://159.75.1.231:5009/user/tags";
    NSDictionary *header = @{@"Authorization":[UserInfo sharedUser].token};
    NSDictionary *body = @{@"tag":tagName};
    
    [manager POST:URL parameters:body headers:header progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *response = (NSDictionary *)responseObject;
        if([response[@"status"] isEqualToString:@"success"])
        {
            NSLog(@"add tag success");
            [UserInfo sharedUser].userTags = response[@"data"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed to add tag");
    }];
}

@end
