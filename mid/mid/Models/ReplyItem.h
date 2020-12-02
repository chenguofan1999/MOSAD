//
//  ReplyItem.h
//  mid
//
//  Created by itlab on 12/2/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReplyItem : NSObject
@property (nonatomic) NSString *replyID;
@property (nonatomic) NSString *contentID;
@property (nonatomic) NSString *fatherID;
@property (nonatomic) NSString *userID;
@property (nonatomic) long publishDate;
@property (nonatomic) int likeNum;
@property (nonatomic) NSString *replyContent;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
