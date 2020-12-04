//
//  FullNotificationItem.h
//  mid
//
//  Created by itlab on 12/4/20.
//

#import <Foundation/Foundation.h>
#import "NotificationItem.h"
#import "MiniUserItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface FullNotificationItem : NSObject
@property (nonatomic) NotificationItem *notificationItem;
@property (nonatomic) MiniUserItem *userItem;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
