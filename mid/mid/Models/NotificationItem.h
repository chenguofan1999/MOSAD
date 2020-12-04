//
//  NotificationItem.h
//  mid
//
//  Created by itlab on 12/4/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NotificationItem : NSObject
@property (nonatomic) NSString *notificationID;
@property (nonatomic) NSString *notificationContent;
@property (nonatomic) NSString *sourceID;
@property (nonatomic) NSString *targetID;
@property (nonatomic) NSString *notificationType;
@property (nonatomic) long createTime;
@property (nonatomic) bool read;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
