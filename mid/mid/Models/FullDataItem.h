//
//  ContentItem.h
//  mid
//
//  Created by itlab on 12/1/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ContentItem.h"
#import "MiniUserItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface FullDataItem : NSObject
@property (nonatomic) ContentItem *contentItem;
@property (nonatomic) MiniUserItem *userItem;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
