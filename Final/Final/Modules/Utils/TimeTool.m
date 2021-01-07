//
//  TimeTool.m
//  Final
//
//  Created by itlab on 12/29/20.
//

#import <Foundation/Foundation.h>
#import "TimeTool.h"


@implementation TimeTool

+ (NSString *)timeBeforeInfoWithString:(NSTimeInterval)timeIntrval{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //获取此时时间戳长度
    NSTimeInterval nowTimeinterval = [[NSDate date] timeIntervalSince1970];
    int timeInt = nowTimeinterval - timeIntrval; //时间差
    
    int year = timeInt / (3600 * 24 * 30 *12);
    int month = timeInt / (3600 * 24 * 30);
    int day = timeInt / (3600 * 24);
    int hour = timeInt / 3600;
    int minute = timeInt / 60;
    if (year > 1) {
        return [NSString stringWithFormat:@"%d years ago",year];
    }else if (year == 1) {
        return @"1 year ago";
    }else if(month > 1){
        return [NSString stringWithFormat:@"%d months ago",month];
    }else if(month == 1){
        return @"1 month ago";
    }else if(day > 1){
        return [NSString stringWithFormat:@"%d days ago",day];
    }else if(day == 1){
        return @"1 day ago";
    }else if(hour > 1){
        return [NSString stringWithFormat:@"%d hours ago",hour];
    }else if(hour == 1){
        return @"1 hour ago";
    }else if(minute > 1){
        return [NSString stringWithFormat:@"%d minutes ago",minute];
    }else if(minute == 1){
        return @"1 minute ago";
    }else{
        return [NSString stringWithFormat:@"Just now"];
    }
}


+ (NSString *)durationInSecondsToString:(int)duration
{
    int second = duration % 60;
    int minute = duration / 60;
    return [NSString stringWithFormat:@" %02d:%02d ", minute, second];
}
@end
