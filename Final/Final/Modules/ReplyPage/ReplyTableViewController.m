//
//  ReplyTableViewController.m
//  Final
//
//  Created by itlab on 1/3/21.
//
#import <SDWebImage/SDWebImage.h>
#import <SDWebImage/UIButton+WebCache.h>
#import <AFNetworking/AFNetworking.h>
#import <MaterialComponents/MDCFilledTextField.h>
#import <MaterialTextControls+OutlinedTextFields.h>
#import <FTPopOverMenu/FTPopOverMenu.h>
#import <MaterialDialogs.h>
#import "ReplyTableViewController.h"
#import "UserPageViewController.h"
#import "CommentTableViewCell.h"
#import "ReplyItem.h"
#import "TimeTool.h"
#import "UserInfo.h"


@interface ReplyTableViewController ()
@property (nonatomic, strong) UILabel *replyNumberLabel;
@property (nonatomic, strong) MDCBaseTextField *replyField;
@property (nonatomic, strong) UIImageView *userAvatarView;
@property (nonatomic, strong) UIButton *sendButton;
@end

@implementation ReplyTableViewController
- (instancetype)initWithCommentID:(int)commentID
{
    self = [super init];
    self.commentID = commentID;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注册
    UINib *nib = [UINib nibWithNibName:@"CommentTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"CommentTableViewCell"];
    
    // 样式
    [self.tableView setBounces:NO];
    
    // Nav bar 样式
    [self setNavBar];
    
    // header view: 输入栏
    UIView *fieldContainerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 70)];
    [fieldContainerView addSubview:self.replyField];
    [self.tableView setTableHeaderView:fieldContainerView];
    
    [self loadDataOrderBy:LoadRepliesOrderByTime];
}

- (void)setNavBar
{
    // 背景色
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1]];
    
    // 返回键
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [backButton.imageView setClipsToBounds:YES];
    [backButton setClipsToBounds:YES];
    [backButton.widthAnchor constraintEqualToConstant:25].active = YES;
    [backButton addTarget:self action:@selector(backToCommentPage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    // 标题
    UILabel *replyTitleLabel = [[UILabel alloc]init];
    [replyTitleLabel setText:@"replies"];
    [replyTitleLabel setFont:[UIFont systemFontOfSize:20]];
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc]initWithCustomView:replyTitleLabel];
    
    // 评论数
    _replyNumberLabel = [[UILabel alloc]init];
    [_replyNumberLabel setTextColor:[UIColor darkGrayColor]];
    [_replyNumberLabel setText:@"     "];//撑开frame
    [_replyNumberLabel setFont:[UIFont systemFontOfSize:20]];
    UIBarButtonItem *numberItem = [[UIBarButtonItem alloc]initWithCustomView:_replyNumberLabel];

    [self.navigationItem setLeftBarButtonItems:@[backItem, titleItem, numberItem]];
}

- (void)backToCommentPage
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark header view
- (MDCBaseTextField *)replyField
{
    if(_replyField == nil)
    {
        _replyField = [[MDCBaseTextField alloc]init];
        [_replyField setFrame:CGRectMake(5, 14, 350, 50)];
        [_replyField setPlaceholder:@"Add a public reply..."];
        [_replyField setLeftViewMode:UITextFieldViewModeAlways];
        [_replyField setRightViewMode:UITextFieldViewModeWhileEditing];
        _replyField.rightView = self.sendButton;
        _replyField.leftView = self.userAvatarView;
    }
    return _replyField;
}

- (UIButton *)sendButton
{
    if(_sendButton == nil)
    {
        _sendButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [_sendButton setImage:[[UIImage imageNamed:@"paper-plane.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_sendButton.imageView setTintColor:[UIColor grayColor]];
        [_sendButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_sendButton addTarget:self action:@selector(replyButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

- (UIImageView *)userAvatarView
{
    if(_userAvatarView == nil)
    {
        _userAvatarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_userAvatarView setContentMode:UIViewContentModeScaleAspectFill];
        [_userAvatarView setClipsToBounds:YES];
        [_userAvatarView.layer setCornerRadius:20];
        [_userAvatarView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://159.75.1.231:5009%@", [UserInfo sharedUser].avatarURL]]];
    }
    return  _userAvatarView;
}

- (void)replyButtonClicked
{
    NSString *URL = @"http://159.75.1.231:5009/replies";
    NSDictionary *header = @{
        @"Authorization":[UserInfo sharedUser].token
    };
    NSDictionary *body = @{
        @"text":[self.replyField text],
        @"commentID":@(self.commentID)
    };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:URL parameters:body headers:header progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *response = (NSDictionary *)responseObject;
        if([response[@"status"] isEqualToString:@"success"])
        {
            NSLog(@"succeed to make a reply");
            [self.replyField setText:@""];
            [self loadDataOrderBy:LoadRepliesOrderByTime];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed to make a reply");
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.replyItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentTableViewCell" forIndexPath:indexPath];
    ReplyItem *itemForThisCell = self.replyItems[indexPath.row];
    
    [cell.avatarButton sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://159.75.1.231:5009%@", itemForThisCell.userItem.avatarURL]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"edvard-munch.png"]];
    [cell.avatarButton setTag:indexPath.row];
    [cell.avatarButton addTarget:self action:@selector(toUserPage:) forControlEvents:UIControlEventTouchUpInside];
    [cell.titleLable setText:[NSString stringWithFormat:@"%@ · %@", itemForThisCell.userItem.userName, [TimeTool timeBeforeInfoWithString:itemForThisCell.createTime]]];
    [cell.commentTextLable setText:itemForThisCell.replyText];
    [cell.likeLabel setText:itemForThisCell.likeNum > 0 ? [NSString stringWithFormat:@"%d", itemForThisCell.likeNum] : @""];
    [cell.replyButton setHidden:YES];
    [cell.replyLabel setHidden:YES];
    
    [cell.likeButton setTag:indexPath.row];
    [cell.likeButton addTarget:self action:@selector(likeReplyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.moreButton setTag:indexPath.row];
    [cell.moreButton addTarget:self action:@selector(moreActions:) forControlEvents:UIControlEventTouchUpInside];
    
    [itemForThisCell addObserver:cell forKeyPath:@"likeNum" options:NSKeyValueObservingOptionNew context:@"likeNum"];
    [itemForThisCell addObserver:cell forKeyPath:@"liked" options:NSKeyValueObservingOptionNew context:@"liked"];
    
    return cell;
}
#pragma mark 头像
- (void)toUserPage:(UIButton *)btn
{
    NSInteger i = btn.tag;
    ReplyItem *itemForThisCell = self.replyItems[i];
    NSString *username = itemForThisCell.userItem.userName;
    UserPageViewController *userPage = [[UserPageViewController alloc]initWithUsername:username];
    [self.navigationController pushViewController:userPage animated:YES];
}

#pragma mark 点赞回复
- (void) likeReplyButtonClicked:(UIButton *)btn
{
    NSInteger i = btn.tag;
    ReplyItem *itemForThisCell = self.replyItems[i];
    
    NSString *URL = [NSString stringWithFormat:@"http://159.75.1.231:5009/like/reply/%d",itemForThisCell.replyID];
    NSDictionary *header = @{
        @"Authorization":[UserInfo sharedUser].token
    };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    if(itemForThisCell.liked)
    {
        // do: cancel like
        [manager DELETE:URL parameters:nil headers:header success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@", responseObject);
            NSDictionary *response = (NSDictionary *)responseObject;
            if([response[@"status"] isEqualToString:@"success"])
            {
                itemForThisCell.liked = NO;
                itemForThisCell.likeNum --;
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"cancel like failed");
        }];
    }
    else
    {
        // do: like
        [manager PUT:URL parameters:nil headers:header success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@", responseObject);
            NSDictionary *response = (NSDictionary *)responseObject;
            if([response[@"status"] isEqualToString:@"success"])
            {
                itemForThisCell.liked = YES;
                itemForThisCell.likeNum ++;
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"like failed");
        }];
    }
}

#pragma mark 更多选项
- (void)moreActions:(UIButton *)sender
{
    NSInteger i = sender.tag;
    ReplyItem *thisItem = self.replyItems[i];
    if(thisItem.userItem.userID == [UserInfo sharedUser].userID)
    {
        FTPopOverMenuConfiguration *config = [FTPopOverMenuConfiguration defaultConfiguration];
        config.textColor = [UIColor whiteColor];
        config.imageSize = CGSizeMake(16, 16);
        config.ignoreImageOriginalColor = YES;
        
        [FTPopOverMenu showForSender:sender
                       withMenuArray:@[@"DELETE"]
                          imageArray:@[@"delete@2x"]
                       configuration:config
                           doneBlock:^(NSInteger selectedIndex) {
            switch (selectedIndex) {
                case 0:
                    [self deleteReply:thisItem.replyID];
                    break;
            }
        } dismissBlock:nil];
    }
}

- (void)deleteReply:(int)replyID
{
    MDCAlertController *alertController = [MDCAlertController alertControllerWithTitle:@"DELETE" message:@"Are you sure?"];
    MDCAlertAction *cancelAction = [MDCAlertAction actionWithTitle:@"Cancel" handler:nil];
    MDCAlertAction *sureAction = [MDCAlertAction actionWithTitle:@"Sure" handler:^(MDCAlertAction * _Nonnull action) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        NSString *URL = [NSString stringWithFormat:@"http://159.75.1.231:5009/replies/%d",replyID];
        NSDictionary *header = @{
            @"Authorization":[UserInfo sharedUser].token
        };
        
        [manager DELETE:URL parameters:nil headers:header success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"succeeded to delete");
            [self loadDataOrderBy:LoadRepliesOrderByTime];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"failed to delete");
        }];
    }];
    [alertController addAction:sureAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark 网络请求
typedef NS_ENUM(NSInteger, LoadReplyMode) {
    LoadRepliesOrderByTime,
    LoadRepliesOrderByLikeNum
};

- (void)loadDataOrderBy:(LoadReplyMode)mode
{
    NSString *URL = @"http://159.75.1.231:5009/replies";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary *header = @{
        @"Authorization":[UserInfo sharedUser].token
    };
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:@(self.commentID) forKey:@"commentID"];
    switch (mode) {
        case LoadRepliesOrderByTime:
            [params setValue:@"time" forKey:@"orderBy"];
            break;
        case LoadRepliesOrderByLikeNum:
            [params setValue:@"likeNum" forKey:@"orderBy"];
            break;
        default:
            break;
    }
        
    [manager GET:URL parameters:params headers:header progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *response = (NSDictionary *)responseObject;
        if([response[@"status"] isEqualToString:@"success"])
        {
            self.replyItems = [NSMutableArray new];
            NSArray *replyData = response[@"data"];
            [self.replyNumberLabel setText:[NSString stringWithFormat:@" %ld", [replyData count]]];
            
            for(int i = 0; i < [replyData count]; i++)
            {
                ReplyItem *newItem = [[ReplyItem alloc]initWithDict:replyData[i]];
                [self.replyItems addObject:newItem];
            }
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed to get reply data");
    }];
}

@end
