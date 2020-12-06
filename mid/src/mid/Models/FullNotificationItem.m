//
//  FullNotificationItem.m
//  mid
//
//  Created by itlab on 12/4/20.
//

#import "FullNotificationItem.h"

@implementation FullNotificationItem
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    self.userItem = [[MiniUserItem alloc]initWithDict:dict[@"User"]];
    self.notificationItem = [[NotificationItem alloc]initWithDict:dict[@"Data"]];
    return self;
}
@end
