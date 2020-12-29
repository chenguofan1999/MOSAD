//
//  AppConfig.m
//  Final
//
//  Created by itlab on 12/29/20.
//

#import "AppConfig.h"

static AppConfig *appConfig = nil;
@implementation AppConfig
+ (AppConfig *)sharedConfig
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        appConfig = [[AppConfig alloc]init];
        [AppConfig configGreenTheme];
    });
    return appConfig;
}

+ (UIColor *)getMainColor
{
    AppConfig *config = [AppConfig sharedConfig];
    return config.mainColor;
}

+ (void)configGreenTheme
{
    CGFloat themeColorR = (float)0x00/255;
    CGFloat themeColorG = (float)0x68/255;
    CGFloat themeColorB = (float)0x37/255;
    appConfig.mainColor = [UIColor colorWithRed:themeColorR green:themeColorG blue:themeColorB alpha:1];
    
    
}
@end
