//
//  miniUserInfo.m
//  mid
//
//  Created by itlab on 12/2/20.
//

#import "MiniUserItem.h"

@implementation MiniUserItem
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    self.userName = dict[@"Name"];
    self.gender = [dict[@"Gender"] intValue];
    
//    NSString *avatarURL = dict[@"Avatar"];
    
    if(self.gender == 0)
        self.avatar = [UIImage imageNamed:@"maleUser.png"];
    else if(self.gender == 1)
        self.avatar = [UIImage imageNamed:@"femaleUser.png"];
    else
        self.avatar = [UIImage imageNamed:@"kawaii-dinosaur.png"];

    return self;
    
}
@end
