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
    
    self.window.rootViewController = tbc;
    
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
                          @"Tower",
                          @"Tower",
                          @"Eiffel Tower",
                          @"Yellow Stone Park"];
    
    NSArray *locationList = @[@"Italy",
                              @"Berlin",
                              @"NYC",
                              @"London",
                              @"Washington DC",
                              @"Moscow",
                              @"Rome",
                              @"Lisbon",
                              @"Pisa",
                              @"Taipei",
                              @"Paris",
                              @"The US"];
    
    NSArray *imageList = @[[UIImage imageNamed:@"venice-canal-color.png"],
                           [UIImage imageNamed:@"brandenburg-gate-color.png"],
                           [UIImage imageNamed:@"statue-of-liberty-color.png"],
                           [UIImage imageNamed:@"big-ben-color.png"],
                           [UIImage imageNamed:@"us-capitol-color.png"],
                           [UIImage imageNamed:@"orthodox-church-color.png"],
                           [UIImage imageNamed:@"colosseum-color.png"],
                           [UIImage imageNamed:@"25-de-abril-bridge-color.png"],
                           [UIImage imageNamed:@"tower-of-pisa-color.png"],
                           [UIImage imageNamed:@"taipei-towers-color.png"],
                           [UIImage imageNamed:@"eiffel-tower-color.png"],
                           [UIImage imageNamed:@"yellowstone.png"]];
    
    NSArray *monthList = @[@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun",
                           @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec"];
    
    _items = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < 25; i++)
    {
        int rand = arc4random() % 12;
        
        NSString *date =[NSString stringWithFormat:@"%@ %d",monthList[arc4random() % 12], arc4random() % 21 + 10];
        
        NSString *location = locationList[rand];
        NSString *spot = spotList[rand];
        
        NSString *thoughts = @"Shall I compare thee to a summer's day?\n"\
        "Thou art more lovely and more temperate.\n"
        "Rough winds do shake the darling buds of May,\n"
        "And summer's lease hath all too short a date.\n"
        "Sometime too hot the eye of heaven shines,\n"
        "And often is his gold complexion dimmed;\n"
        "And every fair from fair sometime declines,\n"
        "By chance, or nature's changing course, untrimmed;\n"
        "But thy eternal summer shall not fade,\n"
        "Nor lose possession of that fair thou ow'st,\n"
        "Nor shall death brag thou wand’rest in his shade,\n"
        "When in eternal lines to Time thou grow'st.\n"
        "So long as men can breathe, or eyes can see,\n"
        "So long lives this, and this gives life to thee.\n";
        
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
    
    [self sortItems];
}

-(void)sortItems
{
    [_items sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Item *item1 = (Item *)obj1;
        Item *item2 = (Item *)obj2;

        NSString *date1 = item1.date;
        NSString *date2 = item2.date;

        NSArray *monthList = @[@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun",
                               @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec"];
        NSInteger month1 = [monthList indexOfObject:[date1 substringWithRange:NSMakeRange(0, 3)]];
        NSInteger month2 = [monthList indexOfObject:[date2 substringWithRange:NSMakeRange(0, 3)]];

        if(month1 != month2) return month1 < month2;
        
        NSInteger day1 = [date1 length] == 5? [[date1 substringWithRange:NSMakeRange(4, 1)] intValue] :
                         [[date1 substringWithRange:NSMakeRange(4, 2)] intValue];

        NSInteger day2 = [date2 length] == 5? [[date2 substringWithRange:NSMakeRange(4, 1)] intValue] :
                         [[date2 substringWithRange:NSMakeRange(4, 2)] intValue];

        return day1 < day2;
    }];
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
    return [NSString stringWithFormat:@"%@\n\n%@ of %@\n\n%@", _date, _spot, _location, _thoughts];
}

@end
