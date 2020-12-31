//
//  VideoPageViewController.h
//  Final
//
//  Created by itlab on 12/31/20.
//

#import <UIKit/UIKit.h>
#import "DetailedContentItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface VideoPageViewController : UIViewController
@property (nonatomic) DetailedContentItem *contentItem;
- (instancetype)initWithContentItem:(DetailedContentItem *)contentItem;
@end

NS_ASSUME_NONNULL_END
