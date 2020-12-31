//
//  DetailedContentItem.h
//  Final
//
//  Created by itlab on 12/31/20.
//

#import <Foundation/Foundation.h>
#import "MiniUserItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailedContentItem : NSObject
@property (nonatomic) int contentID;
@property (nonatomic) NSString *videoTitle;
@property (nonatomic) NSString *videoDescription;
@property (nonatomic) long createTime;
@property (nonatomic) NSString *videoURL;
@property (nonatomic) MiniUserItem *userItem;
@property (nonatomic) bool liked;
@property (nonatomic) int viewNum;
@property (nonatomic) int commentNum;
@property (nonatomic) int likeNum;
@property (nonatomic) NSMutableArray *videoTags;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
