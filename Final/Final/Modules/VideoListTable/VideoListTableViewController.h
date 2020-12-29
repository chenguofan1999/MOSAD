//
//  VideoListTableViewController.h
//  Final
//
//  Created by itlab on 12/28/20.
//

#import <UIKit/UIKit.h>
#import "BriefContentItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface VideoListTableViewController : UITableViewController
@property (nonatomic, strong) NSString *serviceURL;
@property (nonatomic, strong) NSMutableArray *contentItems;
@end

NS_ASSUME_NONNULL_END
