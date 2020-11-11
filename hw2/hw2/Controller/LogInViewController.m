//
//  LogInViewController.m
//  hw2
//
//  Created by itlab on 2020/10/28.
//  Copyright © 2020 itlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogInViewController.h"

@interface LogInViewController()<UITableViewDataSource, UITableViewDelegate>
@end

@implementation LogInViewController


- (instancetype)init
{
    if(self = [super init])
    {
        int w = self.view.bounds.size.width;
        int h = self.view.bounds.size.height;
        
        // 设置 tab 栏样式
        self.tabBarItem.title = @"我的";
        self.tabBarItem.image = [UIImage imageNamed:@"user-off@2x.png"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"user-on@2x.png"];
        
        // 未登录时的样式
        self.view.backgroundColor = [UIColor whiteColor];
        
        UIView *unlogedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
        unlogedView.backgroundColor = [UIColor whiteColor];
        
        UIButton *logInButton = [[UIButton alloc]initWithFrame:CGRectMake(w/2 - 80, h/2-80, 160, 160)];

        logInButton.layer.cornerRadius = 80;
        logInButton.backgroundColor = [UIColor lightGrayColor];
        
        // 用阴影做渐变色
        logInButton.layer.shadowColor = [UIColor blackColor].CGColor;
        logInButton.layer.shadowOffset =  CGSizeMake(0, 0);
        logInButton.layer.shadowOpacity = 1;
        logInButton.layer.shadowRadius = 150.0;
        
        logInButton.titleLabel.font = [UIFont systemFontOfSize:30];
        [logInButton setTitle:@"登录" forState:UIControlStateNormal];
        [logInButton addTarget:self
                      action:@selector(logedInView)
            forControlEvents:UIControlEventTouchUpInside];
        
        [unlogedView addSubview:logInButton];
        [self.view addSubview:unlogedView];

    }
    return self;
}

// 已登录的页面
- (void)logedInView
{
    // 清除之前的子控件
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 登录后的界面
    int w = self.view.bounds.size.width;
    int h = self.view.bounds.size.height;
    UIImageView *portraitView = [[UIImageView alloc]initWithFrame:CGRectMake(w/2 - 80, h/2 - 340, 160, 160)];
    portraitView.image = [[UIImage imageNamed:@"me.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    portraitView.layer.cornerRadius = 80;
    portraitView.layer.masksToBounds = YES;
    portraitView.layer.borderWidth = 2;
    portraitView.layer.borderColor = [UIColor grayColor].CGColor;
    [self.view addSubview:portraitView];
    
    UITableViewController *info = [[UITableViewController alloc]initWithStyle:UITableViewStyleGrouped];
    info.tableView.dataSource = self;
    info.tableView.delegate = self;
    info.view.frame = CGRectMake(0, h/2-150, w, h/2 + 100);
    [self.view addSubview:info.view];

}


#pragma mark - UITableViewDataSource
// 返回 section 的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

// 返回每个 Section 中的 Cell 个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)return 3;
    else return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                   reuseIdentifier:nil];
    switch(indexPath.section)
    {
        case 0:
            switch (indexPath.row)
            {
                case 0:
                    cell.textLabel.text = @"用户名";
                    cell.detailTextLabel.text = @"Chen";
                    break;
                case 1:
                    cell.textLabel.text = @"邮箱";
                    cell.detailTextLabel.text = @"chen2027@gmail.com";
                    break;
                case 2:
                    cell.textLabel.text = @"电话";
                    cell.detailTextLabel.text = @"1001001100";
                    break;
            }
            break;
        case 1:
            switch (indexPath.row)
            {
                case 0:
                    cell.textLabel.text = @"版本";
                    cell.detailTextLabel.text = @"V0.1";
                    break;
                case 1:
                    cell.textLabel.text = @"隐私和cookie";
                    break;
                case 2:
                    cell.textLabel.text = @"清除缓存";
                    break;
                case 3:
                    cell.textLabel.text = @"同步";
                    break;
            }
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)return @"个人信息";
    else return @"关于";
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1)return 20;
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger i = 3 * indexPath.section + indexPath.row;
    switch (i) {
        case 4:
            [self Alert:@"我们不关心你的隐私"];
            break;
        case 5:
            [self Alert:@"已清除缓存"];
        case 6:
            [self Alert:@"已同步"];
        case 3:
            [self Alert:@"我们不打算更新版本"];
        default:
            [self Alert:@"不可更改"];
            break;
    }
}

- (void)Alert:(NSString *)msg
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    
    // 显示对话框
    [self presentViewController:alert animated:true completion:nil];
}

@end
