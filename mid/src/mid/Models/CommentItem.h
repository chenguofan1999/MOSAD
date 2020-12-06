//
//  CommentItem.h
//  mid
//
//  Created by itlab on 12/2/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentItem : NSObject
@property (nonatomic) NSString *commentID;
@property (nonatomic) NSString *fatherID;
@property (nonatomic) NSString *contentID;
@property (nonatomic) NSString *userID;
@property (nonatomic) long publishDate;
@property (nonatomic) NSString *commentContent;
@property (nonatomic) int likeNum;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
