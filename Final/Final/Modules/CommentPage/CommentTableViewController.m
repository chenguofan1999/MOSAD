//
//  CommentTableViewController.m
//  Final
//
//  Created by itlab on 1/3/21.
//


#import <SDWebImage/SDWebImage.h>
#import <SDWebImage/UIButton+WebCache.h>
#import <AFNetworking/AFNetworking.h>
#import <MaterialComponents/MDCFilledTextField.h>
#import <MaterialTextControls+OutlinedTextFields.h>
#import <MaterialDialogs.h>
#import <FTPopOverMenu/FTPopOverMenu.h>
#import "ReplyTableViewController.h"
#import "CommentTableViewController.h"
#import "CommentTableViewCell.h"
#import "UserPageViewController.h"
#import "CommentItem.h"
#import "TimeTool.h"
#import "UserInfo.h"

@interface CommentTableViewController () <UINavigationControllerDelegate>
@property (nonatomic, strong) UILabel *commentNumberLabel;
@property (nonatomic, strong) MDCBaseTextField *commentField;
@property (nonatomic, strong) UIImageView *userAvatarView;
@property (nonatomic, strong) UIButton *sendButton;
@end

@implementation CommentTableViewController
- (instancetype)initWithContentID:(int)contentID
{
    self = [super init];
    self.contentID = contentID;
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
    [fieldContainerView addSubview:self.commentField];
    [self.tableView setTableHeaderView:fieldContainerView];
    
    [self loadDataOrderBy:LoadCommentsOrderByTime];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadDataOrderBy:LoadCommentsOrderByTime];
}

- (void)setNavBar
{
    // 背景色
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1]];
    
    // 标题
    UILabel *commentTitleLabel = [[UILabel alloc]init];
    [commentTitleLabel setText:@"Comments"];
    [commentTitleLabel setFont:[UIFont systemFontOfSize:20]];
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc]initWithCustomView:commentTitleLabel];
    
    // 回复数
    _commentNumberLabel = [[UILabel alloc]init];
    [_commentNumberLabel setTextColor:[UIColor darkGrayColor]];
    [_commentNumberLabel setText:@"      "];//撑开frame
    [_commentNumberLabel setFont:[UIFont systemFontOfSize:20]];
    UIBarButtonItem *numberItem = [[UIBarButtonItem alloc]initWithCustomView:_commentNumberLabel];
    
    [self.navigationItem setLeftBarButtonItems:@[titleItem, numberItem]];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemClose target:self action:@selector(closeCommentPage)]];
    
}

- (void)closeCommentPage
{
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadComments" object:self];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadComments" object:self];
}

#pragma mark header view
- (MDCBaseTextField *)commentField
{
    if(_commentField == nil)
    {
        _commentField = [[MDCBaseTextField alloc]init];
        [_commentField setFrame:CGRectMake(5, 14, 350, 50)];
        [_commentField setPlaceholder:@"Add a public comment..."];
        [_commentField setLeftViewMode:UITextFieldViewModeAlways];
        [_commentField setRightViewMode:UITextFieldViewModeWhileEditing];
        _commentField.rightView = self.sendButton;
        _commentField.leftView = self.userAvatarView;
    }
    return _commentField;
}

- (UIButton *)sendButton
{
    if(_sendButton == nil)
    {
        _sendButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [_sendButton setImage:[[UIImage imageNamed:@"paper-plane.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_sendButton.imageView setTintColor:[UIColor grayColor]];
        [_sendButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_sendButton addTarget:self action:@selector(commentButtonClicked) forControlEvents:UIControlEventTouchUpInside];
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

- (void)commentButtonClicked
{
    NSString *URL = @"http://159.75.1.231:5009/comments";
    NSDictionary *header = @{
        @"Authorization":[UserInfo sharedUser].token
    };
    NSDictionary *body = @{
        @"text":[self.commentField text],
        @"contentID":@(self.contentID)
    };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:URL parameters:body headers:header progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *response = (NSDictionary *)responseObject;
        if([response[@"status"] isEqualToString:@"success"])
        {
            NSLog(@"succeed to make a comment");
            [self.commentField setText:@""];
            [self loadDataOrderBy:LoadCommentsOrderByTime];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed to make a comment");
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.commentItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentTableViewCell" forIndexPath:indexPath];
    CommentItem *itemForThisCell = self.commentItems[indexPath.row];
    
    
    [cell.avatarButton sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://159.75.1.231:5009%@", itemForThisCell.userItem.avatarURL]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"edvard-munch.png"]];
    [cell.avatarButton setTag:indexPath.row];
    [cell.avatarButton addTarget:self action:@selector(toUserPage:) forControlEvents:UIControlEventTouchUpInside];
    [cell.titleLable setText:[NSString stringWithFormat:@"%@ · %@", itemForThisCell.userItem.userName, [TimeTool timeBeforeInfoWithString:itemForThisCell.createTime]]];
    [cell.commentTextLable setText:itemForThisCell.commentText];
    [cell.likeLabel setText:itemForThisCell.likeNum > 0 ? [NSString stringWithFormat:@"%d", itemForThisCell.likeNum] : @""];
    [cell.replyLabel setText:itemForThisCell.replyNum > 0? [NSString stringWithFormat:@"%d", itemForThisCell.replyNum] : @""];
    
    [cell.likeButton setTag:indexPath.row];
    [cell.likeButton addTarget:self action:@selector(likeCommentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.replyButton setTag:indexPath.row];
    [cell.replyButton addTarget:self action:@selector(replyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.moreButton setTag:indexPath.row];
    [cell.moreButton addTarget:self action:@selector(moreActions:) forControlEvents:UIControlEventTouchUpInside];
    
    if(itemForThisCell.liked == YES)
    {
        [cell.likeButton setImage:[UIImage imageNamed:@"thumbs-up-filled.png"] forState:UIControlStateNormal];
    }
    else
    {
        [cell.likeButton setImage:[UIImage imageNamed:@"thumbs-up.png"] forState:UIControlStateNormal];
    }
    
    [itemForThisCell addObserver:cell forKeyPath:@"likeNum" options:NSKeyValueObservingOptionNew context:@"likeNum"];
    [itemForThisCell addObserver:cell forKeyPath:@"liked" options:NSKeyValueObservingOptionNew context:@"liked"];
    [itemForThisCell addObserver:cell forKeyPath:@"replyNum" options:NSKeyValueObservingOptionNew context:@"replyNum"];
    
    
    return cell;
}
#pragma mark 头像
- (void)toUserPage:(UIButton *)btn
{
    NSInteger i = btn.tag;
    CommentItem *itemForThisCell = self.commentItems[i];
    NSString *username = itemForThisCell.userItem.userName;
    UserPageViewController *userPage = [[UserPageViewController alloc]initWithUsername:username];
    [self.navigationController pushViewController:userPage animated:YES];
}

#pragma mark 点赞评论
- (void)likeCommentButtonClicked:(UIButton *)btn
{
    NSInteger i = btn.tag;
    CommentItem *itemForThisCell = self.commentItems[i];
    
    NSString *URL = [NSString stringWithFormat:@"http://159.75.1.231:5009/like/comment/%d",itemForThisCell.commentID];
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

#pragma mark 进入回复页面
- (void)replyButtonClicked:(UIButton *)btn
{
    NSInteger i = btn.tag;
    int commentID = [self.commentItems[i] commentID];
    [self.navigationController pushViewController:[[ReplyTableViewController alloc]initWithCommentID:commentID] animated:YES];
}

#pragma mark 更多选项
- (void)moreActions:(UIButton *)sender
{
    NSInteger i = sender.tag;
    CommentItem *thisItem = self.commentItems[i];
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
                    [self deleteComment:thisItem.commentID];
                    break;
            }
        } dismissBlock:nil];
    }
}

- (void)deleteComment:(int)commentID
{
    MDCAlertController *alertController = [MDCAlertController alertControllerWithTitle:@"DELETE" message:@"Are you sure?"];
    MDCAlertAction *cancelAction = [MDCAlertAction actionWithTitle:@"Cancel" handler:nil];
    MDCAlertAction *sureAction = [MDCAlertAction actionWithTitle:@"Sure" handler:^(MDCAlertAction * _Nonnull action) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        NSString *URL = [NSString stringWithFormat:@"http://159.75.1.231:5009/comments/%d",commentID];
        NSDictionary *header = @{
            @"Authorization":[UserInfo sharedUser].token
        };
        
        [manager DELETE:URL parameters:nil headers:header success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"succeeded to delete");
            [self loadDataOrderBy:LoadCommentsOrderByTime];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"failed to delete");
        }];
    }];
    [alertController addAction:sureAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark 网络请求
typedef NS_ENUM(NSInteger, LoadCommentMode) {
    LoadCommentsOrderByTime,
    LoadCommentsOrderByLikeNum
};

- (void)loadDataOrderBy:(LoadCommentMode)mode
{
    NSString *URL = @"http://159.75.1.231:5009/comments";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary *header = @{
        @"Authorization":[UserInfo sharedUser].token
    };
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:@(self.contentID) forKey:@"contentID"];
    switch (mode) {
        case LoadCommentsOrderByTime:
            [params setValue:@"time" forKey:@"orderBy"];
            break;
        case LoadCommentsOrderByLikeNum:
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
            self.commentItems = [NSMutableArray new];
            NSArray *commentData = response[@"data"];
            [self.commentNumberLabel setText:[NSString stringWithFormat:@" %ld", [commentData count]]];
            
            for(int i = 0; i < [commentData count]; i++)
            {
                CommentItem *newItem = [[CommentItem alloc]initWithDict:commentData[i]];
                [self.commentItems addObject:newItem];
            }
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed to get comment data");
    }];
}

@end
