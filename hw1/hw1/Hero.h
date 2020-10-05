//
//  Hero.h
//  test_hw1
//
//  Created by itlab on 2020/10/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Hero : NSObject
{
    NSString *country;
    NSInteger blood_value;
    NSInteger energy_value;
    NSInteger damage;
}

- (NSInteger)getBlood_value;
- (NSInteger)getEnergy_value;
- (NSInteger)getDamage;
- (NSString *)getCountry;

- (void)changeDamage:(NSInteger)n;
- (void)changeBlood_value:(NSInteger)n;
- (void)changeEnergy_value:(NSInteger)n;

+ (void)PKOneUnit;
+ (void)PKA:(Hero *)a
        PKB:(Hero *)b;
- (BOOL)action:(Hero *)target;
- (void)hit:(Hero *)target;

@end

@interface Zhangfei : Hero
- (void) heavyStrike:(Hero *)target;
- (void) shoutTo:(Hero *)target;
@end

@interface Lvbu : Hero
- (void) getPower;
@end

@interface Diaochan : Hero
- (void) lure:(Hero *)target;
@end

@interface Kongming : Hero
- (void) energySteal:(Hero *)target;
- (void) curse:(Hero *)target;
@end

@interface Huatuo : Hero
- (void) cure;
@end

@interface Guanyu : Hero
@end

@interface Zhouyu : Hero
{
    NSInteger burnDamage;
}
- (void) burn:(Hero *)target;
@end

@interface Caocao : Hero
- (void) blackmail:(Hero *)target;
@end

@interface Simayi : Hero
- (void) thunderStrike:(Hero *)target;
@end

@interface Liubei : Hero
- (void) exchange:(Hero *)target;
@end

@interface Xiahoudun : Hero

@end
NS_ASSUME_NONNULL_END
