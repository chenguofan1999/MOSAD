//
//  FullContentItem.h
//  mid
//
//  Created by itlab on 12/3/20.
//

#import <Foundation/Foundation.h>
#import "ContentItem.h"
#import "MiniUserItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface FullContentItem : NSObject

@property (nonatomic) ContentItem *contentItem;
@property (nonatomic) MiniUserItem *userItem;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
