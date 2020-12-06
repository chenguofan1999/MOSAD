//
//  MyPageViewController.h
//  mid
//
//  Created by itlab on 2020/11/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainPageViewController : UITableViewController
@property (nonatomic) NSInteger atPage;
- (void)loadTextData;
- (void)loadAlbumData;
@end

NS_ASSUME_NONNULL_END
