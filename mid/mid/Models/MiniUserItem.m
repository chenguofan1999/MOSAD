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
    
    NSString *avatarURL = dict[@"Avatar"];
    NSURL *URL = [NSURL URLWithString:avatarURL];// 获取的图片地址
    self.avatar = [UIImage imageWithData: [NSData dataWithContentsOfURL:URL]]; // 根据地址取出图片
    
    return self;
    
}
@end
