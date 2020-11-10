//
//  AppDelegate.h
//  hw2
//
//  Created by itlab on 2020/10/27.
//  Copyright © 2020 itlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) NSMutableArray *items;

@end



@interface Item : NSObject
@property (nonatomic) NSString *date;
@property (nonatomic) NSString *location;
@property (nonatomic) NSString *spot;
@property (nonatomic) NSString *thoughts;
@property (nonatomic) NSMutableArray *pics;
@property (nonatomic) UIImage *displayedInFindView;

-(instancetype) initWithDate:(NSString*)date
                 andLocation:(NSString*)location
                     andSpot:(NSString*)spot
                 andThoughts:(NSString*)thoughts
                     andPics:(NSMutableArray*)pics
                     andIcon:(UIImage*)icon;
-(NSString*)getDetailedInfo;
-(NSString*)getBriefInfo;

@end
