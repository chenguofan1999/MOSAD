//
//  miniUserInfo.h
//  mid
//
//  Created by itlab on 12/2/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MiniUserItem : NSObject
@property (nonatomic) NSString *userName;
@property (nonatomic) int gender;
@property (nonatomic) UIImage *avatar;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
