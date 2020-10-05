//
//  Hero.m
//  test_hw1
//
//  Created by itlab on 2020/10/4.
//

#import "Hero.h"

@implementation Hero

- (id)init
{
    blood_value = 100;
    energy_value = 100;
    return self;
}

- (NSInteger)getBlood_value
{
    return blood_value;
}

- (NSInteger)getEnergy_value
{
    return energy_value;
}

- (NSInteger)getDamage
{
    return damage;
}

- (NSString *)getCountry
{
    return country;
}

- (void)changeBlood_value:(NSInteger)n
{
    blood_value += n;
    if(blood_value < 0) blood_value = 0;
}

- (void)changeEnergy_value:(NSInteger)n
{
    energy_value += n;
    if(energy_value < 0) energy_value = 0;
}

- (void)changeDamage:(NSInteger)n
{
    damage += n;
    if(damage < 0) damage = 0;
}

+ (void)PKOneUnit
{
    // randomly choose two heroes a and b.
    // then call [Hero PKA:a PKB:b]
    NSArray *heroes = @[[[Zhangfei alloc] init], [[Lvbu alloc] init], [[Diaochan alloc] init],
                        [[Kongming alloc] init], [[Huatuo alloc] init], [[Guanyu alloc] init],
                        [[Caocao alloc] init], [[Simayi alloc] init], [[Zhouyu alloc] init],
                        [[Zhangfei alloc] init], [[Xiahoudun alloc] init]];
    int i = arc4random_uniform(11);
    int j = arc4random_uniform(11);
    while(i == j) j = arc4random_uniform(11);
    
    [Hero PKA:heroes[i] PKB:heroes[j]];
}

+ (void)PKA:(Hero *)a PKB:(Hero *)b
{
    NSLog(@"%@ vs %@", [a className], [b className]);
    NSLog(@"");
    // a fights with b (attack in turns) for at most 10 rounds
    for(int i = 0; i < 10; i ++)
    {
        NSLog(@"<<< Round %d >>>", i+1);
        BOOL t;
        t = [a action:b];
        if(t)
        {
            NSLog(@"%@ won the fight!", [a className]);
            return;
        }
        
        NSLog(@"");
        
        t = [b action:a];
        if(t)
        {
            NSLog(@"%@ won the fight!", [b className]);
            return;
        }
        NSLog(@"");
    }
    NSLog(@"What a pity, a tie!");
}

- (BOOL)action:(Hero *)target
{
    // no implementation in Hero class
    return NO;
}

- (void)hit:(Hero *)target
{
    NSInteger before = [target getBlood_value];
    [target changeBlood_value:-damage];
    NSLog(@"%@ had no energy but to hit %@ gently", [self className], [target className]);
    NSLog(@"%@ blood: %ld -> %ld", [target className], before, [target getBlood_value]);
}
@end

@implementation Zhangfei : Hero
- (id)init
{
    self = [super init];
    country = @"Shu";
    damage = 10;
    return self;
}

- (BOOL)action:(Hero *)target
{
    //NSLog(@"%@: blood : %ld, energy : %ld", [target className], [target getBlood_value], [target getEnergy_value]);
    if(energy_value >= 85)
    {
        [self shoutTo:target];
    }
    else if(energy_value >= 30)
    {
        [self heavyStrike:target];
    }
    else // physical attack
    {
        [self hit:target];
    }
    
    return [target getBlood_value] == 0;
}

- (void)heavyStrike:(Hero *)target
{
    NSInteger before = [target getBlood_value];
    [target changeBlood_value:-15];
    [self changeEnergy_value:-30];
    NSLog(@"Zhangfei gave %@ a damn heavy strike !", [target className]);
    NSLog(@"%@ blood: %ld -> %ld", [target className], before, [target getBlood_value]);
}

- (void)shoutTo:(Hero *)target
{
    NSInteger before = [target getEnergy_value];
    [target changeEnergy_value:-40];
    [self changeEnergy_value:-15];
    NSLog(@"Zhangfei shouted to %@ ...", [target className]);
    NSLog(@"%@ energy: %ld -> %ld", [target className], before, [target getEnergy_value]);
}

@end

@implementation Lvbu : Hero

- (id) init
{
    self = [super init];
    country = @"Whatever";
    damage = 0; // don't worry it will grow
    return self;
}

- (void)getPower
{
    [self changeEnergy_value:-33];
    damage += 11;
    NSLog(@"Lvbu got power!");
    NSLog(@"Lvbu damage: %ld -> %ld", damage - 11, damage);
}

- (BOOL)action:(Hero *)target
{
    if(energy_value >= 33)
    {
        [self getPower];
    }
    else
    {
        [self hit:target];
    }
    
    return [target getBlood_value] == 0;
}

@end


@implementation Diaochan : Hero

- (id)init
{
    self = [super init];
    country = @"Eastern Han";
    damage = 5;
    return self;
}

- (void)lure:(Hero *)target
{
    NSInteger selfBefore = [self getBlood_value];
    NSInteger targetBefore = [target getBlood_value];
    [self changeEnergy_value:-20];
    [self changeBlood_value:10];
    [target changeBlood_value:-10];
    NSLog(@"Diaochan : \"You blood is mine!\"");
    NSLog(@"Diaochan( %ld -> %ld ) stealed 10 blood from %@(%ld -> %ld)",
          selfBefore, [self getBlood_value], [target className], targetBefore, [target getBlood_value]);
}

- (BOOL)action:(Hero *)target
{
    if(energy_value >= 20)
    {
        [self lure:target];
    }
    else
    {
        [self hit:target];
    }
    
    return [target getBlood_value] == 0;
}


@end


@implementation Kongming : Hero

- (id)init
{
    self = [super init];
    country = @"Shu";
    damage = 1;
    return self;
}

- (void)energySteal:(Hero *)target
{
    NSInteger targetBefore = [target getEnergy_value];
    [target changeEnergy_value: -25];
    NSInteger targetNow = [target getEnergy_value];
    NSInteger diff = targetBefore - targetNow;
    [self changeEnergy_value:diff];
    NSLog(@"Kongming : \"You magic is mine!\"");
    NSLog(@"Kongming(%ld -> %ld) stealed %ld energy from %@(%ld -> %ld)", [self getEnergy_value] - diff,
          [self getEnergy_value], diff, [target className], targetBefore, targetNow);
}

- (void)curse:(Hero *)target
{
    NSInteger before = [target getBlood_value];
    [target changeBlood_value:-22];
    [self changeEnergy_value:-30];
    NSLog(@"Kongming : \"Never have seen so shameless one can be!\"");
    NSLog(@"%@ blood: %ld -> %ld", [target className], before, [target getBlood_value]);
}

- (BOOL)action:(Hero *)target
{
    if([target getEnergy_value] >= 20)
    {
        [self energySteal:target];
    }
    else if(energy_value >= 30)
    {
        [self curse:target];
    }
    else
    {
        [self hit:target];
    }
    
    return [target getBlood_value] == 0;
}


@end


@implementation Huatuo : Hero

- (id)init
{
    self = [super init];
    country = @"Eastern Han";
    damage = 0;
    return self;
}


- (void)cure
{
    NSLog(@"Huatuo ate a peach :\"Kill me, you loser\"");
    [self changeBlood_value: + 8];
    NSLog(@"Huatuo blood : %ld -> %ld", [self getBlood_value] - 10, [self getBlood_value]);
}


- (BOOL)action:(Hero *)target
{
    [self cure];
    return NO;
}

@end


@implementation Guanyu : Hero

- (id)init
{
    self = [super init];
    country = @"Shu";
    damage = 18;
    return self;
}

- (void)hit:(Hero *)target
{
    NSInteger before = [target getBlood_value];
    [target changeBlood_value:-damage];
    NSLog(@"%@ played no tricks and hit %@", [self className], [target className]);
    NSLog(@"%@ (blood: %ld -> %ld) :\"Giao!\" ", [target className], before, [target getBlood_value]);
}

- (BOOL)action:(Hero *)target
{
    [self hit:target];
    return [target getBlood_value] == 0;
}

@end


@implementation Zhouyu : Hero

- (id) init
{
    burnDamage = 0;
    self = [super init];
    country = @"Wu";
    damage = 8;
    return self;
}

- (void) burn:(Hero *)target
{
    NSLog(@"Zhouyu set fire on %@'s boat", [target className]);
    burnDamage += 3;
}

- (void) hit:(Hero *)target
{
    NSInteger before = [target getBlood_value];
    [target changeBlood_value:- (damage + burnDamage)];
    NSLog(@"%@ hit %@, with %ld burn damage!", [self className], [target className], burnDamage);
    NSLog(@"%@ (blood: %ld -> %ld) :\"Damn it, you cheat!\" ", [target className], before, [target getBlood_value]);
}

- (BOOL) action:(Hero *)target
{
    [self burn:target];
    [self hit:target];
    return [target getBlood_value] == 0;
}

@end


@implementation Caocao : Hero

- (id)init
{
    self = [super init];
    country = @"Wei";
    damage = 10;
    return self;
}

- (void)blackmail:(Hero *)target
{
    NSInteger before = [target getDamage];
    [target changeDamage:-3];
    [self changeDamage:3];
    [self changeEnergy_value:-30];
    NSLog(@"Caocao :\"Give me your weapon, or I'll kill your king\"");
    NSLog(@"%@ damage: %ld -> %ld", [target className], before, [target getDamage]);
    NSLog(@"Caocao damage: %ld -> %ld", [self getDamage] - 2, [self getDamage]);
}

- (BOOL)action:(Hero *)target
{
    if(energy_value >= 30)
    {
        [self blackmail:target];
    }
    else
    {
        [self hit:target];
    }
    
    return [target getBlood_value] == 0;
}

@end


@implementation Simayi : Hero

- (id)init
{
    self = [super init];
    country = @"Wei";
    damage = 11;
    return self;
}

- (void)thunderStrike:(Hero *)target
{
    NSInteger before = [target getBlood_value];
    [target changeBlood_value:-25];
    [self changeEnergy_value:-50];
    NSLog(@"Simayi invoked thunder somehow from nowhere");
    NSLog(@"%@ blood: %ld -> %ld", [target className], before, [target getBlood_value]);
}

- (BOOL)action:(Hero *)target
{
    if(energy_value >= 50)
    {
        [self thunderStrike:target];
    }
    else
    {
        [self hit:target];
    }
    
    return [target getBlood_value] == 0;
}

@end

@implementation Liubei : Hero
- (id)init
{
    self = [super init];
    country = @"Shu";
    damage = 12;
    return self;
}

- (void)exchange:(Hero *)target
{
    NSInteger selfBefore = [self getBlood_value];
    NSInteger targetBefore = [target getBlood_value];
    [self changeBlood_value:targetBefore - selfBefore];
    [target changeBlood_value:selfBefore - targetBefore];
    NSLog(@"Liubei :\" Unexpected huh? \"");
    NSLog(@"Liubei blood : %ld -> %ld", selfBefore, targetBefore);
    NSLog(@"%@ blood : %ld -> %ld", [target className], targetBefore, selfBefore);
}

- (BOOL)action:(Hero *)target
{
    if([self getBlood_value] <= [target getBlood_value] - 30)
    {
        [self exchange:target];
    }
    else
    {
        [self hit:target];
    }
    
    return [target getBlood_value] == 0;
}

@end


@implementation Xiahoudun : Hero

- (instancetype)init
{
    self = [super init];
    country = @"Shu";
    damage = 25;
    return self;
}

- (void)hit:(Hero *)target
{
    NSInteger targetBefore = [target getBlood_value];
    NSInteger selfBefore = [self getBlood_value];
    [target changeBlood_value:-damage];
    [self changeBlood_value:-8];
    NSInteger targetNow = [target getBlood_value];
    NSInteger selfNow = [self getBlood_value];
    if(selfNow <= 0)
    {
        [self changeBlood_value:1 - selfNow];
        selfNow = 1;
    }
    NSLog(@"Xiahoudun hit %@ with no mercy (to himself)", [target className]);
    NSLog(@"Xiahoudun blood: %ld -> %ld", selfBefore, selfNow);
    NSLog(@"%@ blood: %ld -> %ld", [target className], targetBefore, targetNow);
}

- (BOOL)action:(Hero *)target
{
    [self hit:target];
    return [target getBlood_value] == 0;
}

@end
