//
//  PostItem.h
//  mid
//
//  Created by itlab on 12/1/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContentItem : NSObject
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *detail;
@property (nonatomic) NSMutableArray *tags;
@property (nonatomic) bool isPublic;

@property (nonatomic) NSString *contentID;
@property (nonatomic) long PublishDate;
@property (nonatomic) int likeNum;
@property (nonatomic) int commentNum;

- (instancetype)initWithDict:(NSDictionary *)dict;
- (NSDictionary *)getDict;

@end

NS_ASSUME_NONNULL_END