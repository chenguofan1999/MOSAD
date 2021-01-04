//
//  ExplorePageViewController.h
//  Final
//
//  Created by itlab on 12/28/20.
//

#import <UIKit/UIKit.h>
#import "NavedViewController.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, VideoSortingMode) {
    VideoSortingModeTimeDesc = 0,
    VideoSortingModeViewNumDesc = 1,
    VideoSortingModeTimeAsc = 2,
    VideoSortingModeViewNumAsc = 3
};

@interface ExplorePageViewController : NavedViewController

@end

NS_ASSUME_NONNULL_END
