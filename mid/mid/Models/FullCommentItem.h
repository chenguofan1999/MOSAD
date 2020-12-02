//
//  CommentItem.h
//  mid
//
//  Created by itlab on 12/2/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface FullCommentItem : NSObject
@property (nonatomic) NSString *commentID;
@property (nonatomic) NSString *contentID;
@property (nonatomic) NSString *userID;
@property (nonatomic) long publishDate;
@property (nonatomic) NSString *commentContent;
@property (nonatomic) int likeNum;

@property (nonatomic) NSString *userName;
@property (nonatomic) int gender;
//@property (nonatomic) UIImage *avatar;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
