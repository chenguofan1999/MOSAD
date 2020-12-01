//
//  ContentItem.h
//  mid
//
//  Created by itlab on 12/1/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ContentItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface FullDataItem : NSObject
@property (nonatomic) ContentItem *contentData;
@property (nonatomic) NSString *userName;
@property (nonatomic) int gender;
//@property (nonatomic) UIImage *avatar;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
