//
//  TimeTool.h
//  Final
//
//  Created by itlab on 12/29/20.
//

#ifndef TimeTool_h
#define TimeTool_h

@interface TimeTool : NSObject

+ (NSString *)timeBeforeInfoWithString:(NSTimeInterval)timeIntrval;
+ (NSString *)durationInSecondsToString:(int)duration;
@end

#endif /* TimeTool_h */
