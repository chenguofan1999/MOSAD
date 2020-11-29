//
//  UIResponder+Scene.h
//  mid
//
//  Created by itlab on 11/29/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIResponder (Scene)

@property (nonatomic, readonly, nullable) UIScene *scene API_AVAILABLE(ios(13.0));

@end

NS_ASSUME_NONNULL_END
