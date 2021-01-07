//
//  BriefContentItem.h
//  Final
//
//  Created by itlab on 12/28/20.
//

#import <Foundation/Foundation.h>
#import "MiniUserItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface BriefContentItem : NSObject
@property (nonatomic) int contentID;
@property (nonatomic) int viewNum;
@property (nonatomic) int duration;
@property (nonatomic) long createTime;
@property (nonatomic) NSString *coverURL;
@property (nonatomic) NSString *title;
@property (nonatomic) MiniUserItem *userItem;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
