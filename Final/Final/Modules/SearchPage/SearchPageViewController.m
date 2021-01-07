//
//  SearchPageViewController.m
//  Final
//
//  Created by itlab on 12/31/20.
//

#import "SearchPageViewController.h"
#import "OrderedVideoListTable.h"

@interface SearchPageViewController ()<UISearchBarDelegate>
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) OrderedVideoListTable *tableViewController;
@end

@implementation SearchPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitleView:self.searchBar];
    [self addChildViewController:self.tableViewController];
    [self.view addSubview:self.tableViewController.tableView];
    [self.tableViewController.tableView setFrame:self.view.frame];
}

- (UISearchBar *)searchBar
{
    if(_searchBar == nil)
    {
        _searchBar = [[UISearchBar alloc]init];
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (OrderedVideoListTable *)tableViewController
{
    if(_tableViewController == nil)
    {
        _tableViewController = [[OrderedVideoListTable alloc]initWithTypeSearch];
    }
    return _tableViewController;
}

#pragma mark delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.tableViewController searchWithKeyword:[searchBar text]];
}



@end
