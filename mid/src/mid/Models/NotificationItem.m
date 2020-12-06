//
//  NotificationItem.m
//  mid
//
//  Created by itlab on 12/4/20.
//

#import "NotificationItem.h"

@implementation NotificationItem
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    self.notificationID = dict[@"ID"];
    self.notificationContent = dict[@"Content"];
    self.sourceID = dict[@"SourceID"];
    self.targetID = dict[@"TargetID"];
    self.notificationType = dict[@"Type"];
    self.createTime = [dict[@"CreateTime"] longValue] / 1000;
    self.read = [dict[@"Read"] boolValue];
    return self;
}
@end
