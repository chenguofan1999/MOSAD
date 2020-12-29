//
//  AppConfig.h
//  Final
//
//  Created by itlab on 12/29/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppConfig : NSObject
@property (nonatomic) UIColor *mainColor;
@property (nonatomic) UIColor *auxiliaryColor;

+ (AppConfig *)sharedConfig;
+ (UIColor *)getMainColor;
+ (void)configGreenTheme;
@end

NS_ASSUME_NONNULL_END
