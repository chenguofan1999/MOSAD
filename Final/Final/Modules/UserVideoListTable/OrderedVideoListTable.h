//
//  UserVideoListTable.h
//  Final
//
//  Created by itlab on 1/7/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, OrderedVideoListTableType) {
    OrderedVideoListTableTypeUser,
    OrderedVideoListTableTypeHistory,
    OrderedVideoListTableTypeSearch,
    OrderedVideoListTableTypeLike,
    OrderedVideoListTableTypeSelf
};

typedef NS_ENUM(NSInteger, UserVideoListTableOrderMode) {
    UserVideoListTableOrderByTimeDesc,
    UserVideoListTableOrderByTimeAsc,
    UserVideoListTableOrderByViewNumDesc,
    UserVideoListTableOrderByViewNumAsc
};

@interface OrderedVideoListTable : UITableViewController
- (instancetype)initWithUserName:(NSString *)username;
- (instancetype)initWithTypeHistory;
- (instancetype)initWithTypeSearch;
- (void)searchWithKeyword:(NSString *)keyword;
- (instancetype)initWithTypeLikeByUsername:(NSString *)username;
- (instancetype)initWithTypeSelf;
@end

NS_ASSUME_NONNULL_END
