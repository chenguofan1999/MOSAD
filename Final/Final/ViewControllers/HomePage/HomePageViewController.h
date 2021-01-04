//
//  HomePageViewController.h
//  Final
//
//  Created by itlab on 12/28/20.
//

#import <UIKit/UIKit.h>
#import "VideoListTableViewController.h"
#import "NavedViewController.h"
#import "TagView.h"
NS_ASSUME_NONNULL_BEGIN

@interface HomePageViewController : NavedViewController
@property (nonatomic, strong) VideoListTableViewController *videoListTableViewController;
@property (nonatomic, strong) TagView *tagView;
@end

NS_ASSUME_NONNULL_END

