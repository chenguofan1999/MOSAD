//
//  AppDelegate.m
//  hw2
//
//  Created by itlab on 2020/10/27.
//  Copyright © 2020 itlab. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarController.h"
#import <UIKit/UIKit.h>



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self initializeData];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    
    // Create a UITabBarController
    TabBarController *tbc = [[TabBarController alloc] init];
    
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tbc];
    
    self.window.rootViewController = tbc;
    
//    [[UINavigationBar appearance] setTranslucent:NO];
//    nav.extendedLayoutIncludesOpaqueBars = YES;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)initializeData
{
    // 以下三组数据用于随机生成发现页面的已有记录
    NSArray *spotList = @[@"Venice",
                          @"Brandenburg Gate",
                          @"Statue of Liberty",
                          @"Big-Ben",
                          @"US Capitol",
                          @"Orthodox Church",
                          @"Colosseum",
                          @"25 de April Bridge",
                          @"Tower"];
    
    NSArray *locationList = @[@"Italy",
                              @"Berlin",
                              @"NYC",
                              @"London",
                              @"Washington DC",
                              @"Moscow",
                              @"Rome",
                              @"Lisbon",
                              @"Pisa"];
    
    NSArray *imageList = @[[UIImage imageNamed:@"venice-canal-color.png"],
                           [UIImage imageNamed:@"brandenburg-gate-color.png"],
                           [UIImage imageNamed:@"statue-of-liberty-color.png"],
                           [UIImage imageNamed:@"big-ben-color.png"],
                           [UIImage imageNamed:@"us-capitol-color.png"],
                           [UIImage imageNamed:@"orthodox-church-color.png"],
                           [UIImage imageNamed:@"colosseum-color.png"],
                           [UIImage imageNamed:@"25-de-abril-bridge-color.png"],
                           [UIImage imageNamed:@"tower-of-pisa-color.png"],];
    
    NSArray *monthList = @[@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun",
                           @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dev"];
    
    _items = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < 20; i++)
    {
        int rand = i < 9 ? i : arc4random() % 9;
        
        NSString *date =[NSString stringWithFormat:@"%@ %d",monthList[arc4random() % 12], arc4random() % 21 + 10];
        
        NSString *location = locationList[rand];
        NSString *spot = spotList[rand];
        
        NSString *thoughts = @"Just nice";
        NSMutableArray *pics = [[NSMutableArray alloc] init];
        [pics addObject:imageList[rand]];
        [pics addObject:imageList[rand]];
        [pics addObject:imageList[rand]];
        [pics addObject:imageList[rand]];
        [pics addObject:imageList[rand]];
        
        Item *thisItem = [[Item alloc] initWithDate:date
                                        andLocation:location
                                            andSpot:spot
                                        andThoughts:thoughts
                                            andPics:pics
                                            andIcon:imageList[rand]];
        [_items addObject:thisItem];
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end


#pragma mark 实现Item
@implementation Item
-(instancetype) initWithDate:(NSString *)date
                 andLocation:(NSString *)location
                     andSpot:(NSString *)spot
                 andThoughts:(NSString *)thoughts
                     andPics:(NSMutableArray *)pics
                     andIcon:(UIImage *)icon
{
    self = [super init];
    _date = date;
    _location = location;
    _spot = spot;
    _thoughts = thoughts;
    _pics = pics;
    _displayedInFindView = icon;
    
    
    return self;
}

-(NSString*)getBriefInfo
{
    return [NSString stringWithFormat:@"%@: %@ of %@", _date, _spot, _location];
}

-(NSString*)getDetailedInfo
{
    return [NSString stringWithFormat:@"时间：%@\n\n地点：%@\n\n景点：%@\n\n感想：\n%@", _date, _location, _spot, _thoughts];
}

@end
