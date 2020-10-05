# A tiny terminal game : the Three Kindoms

## 1. Requirements and Accomplishments

|**Requirements**|**met ?**|How|
|:--|:--|:--|
|Display the state of affected hero and the result of each game|Yep|2.1|
|Polymorphism|Yep|2.2|
|Object oriented|Yep|2.3|
|>10 heroes, with skills|Yep|2.4|

## 2. Implementation

### 2.1 Display of State / Result

Directly show my terminal in run-time:

```
2020-10-05 19:20:50.948632+0800 hw1[7828:678305] Huatuo vs Zhouyu
2020-10-05 19:20:50.949719+0800 hw1[7828:678305] 
2020-10-05 19:20:50.949789+0800 hw1[7828:678305] <<< Round 1 >>>
2020-10-05 19:20:50.949856+0800 hw1[7828:678305] Huatuo ate a peach :"Kill me, you loser"
2020-10-05 19:20:50.949915+0800 hw1[7828:678305] Huatuo blood : 98 -> 108
2020-10-05 19:20:50.949972+0800 hw1[7828:678305] 
2020-10-05 19:20:50.950028+0800 hw1[7828:678305] Zhouyu set fire on Huatuo's boat
2020-10-05 19:20:50.950092+0800 hw1[7828:678305] Zhouyu hit Huatuo, with 3 burn damage!
2020-10-05 19:20:50.950143+0800 hw1[7828:678305] Huatuo (blood: 108 -> 97) :"Damn it, you cheat!"
2020-10-05 19:20:50.950282+0800 hw1[7828:678305] 
2020-10-05 19:20:50.950396+0800 hw1[7828:678305] <<< Round 2 >>>
2020-10-05 19:20:50.950509+0800 hw1[7828:678305] Huatuo ate a peach :"Kill me, you loser"
2020-10-05 19:20:50.950613+0800 hw1[7828:678305] Huatuo blood : 95 -> 105
2020-10-05 19:20:50.950711+0800 hw1[7828:678305] 
2020-10-05 19:20:50.950818+0800 hw1[7828:678305] Zhouyu set fire on Huatuo's boat
2020-10-05 19:20:50.950956+0800 hw1[7828:678305] Zhouyu hit Huatuo, with 6 burn damage!
2020-10-05 19:20:50.952602+0800 hw1[7828:678305] Huatuo (blood: 105 -> 91) :"Damn it, you cheat!"
2020-10-05 19:20:50.952679+0800 hw1[7828:678305] 
2020-10-05 19:20:50.952744+0800 hw1[7828:678305] <<< Round 3 >>>
2020-10-05 19:20:50.952799+0800 hw1[7828:678305] Huatuo ate a peach :"Kill me, you loser"
2020-10-05 19:20:50.952848+0800 hw1[7828:678305] Huatuo blood : 89 -> 99
2020-10-05 19:20:50.952913+0800 hw1[7828:678305] 
2020-10-05 19:20:50.952969+0800 hw1[7828:678305] Zhouyu set fire on Huatuo's boat
2020-10-05 19:20:50.953038+0800 hw1[7828:678305] Zhouyu hit Huatuo, with 9 burn damage!
2020-10-05 19:20:50.953227+0800 hw1[7828:678305] Huatuo (blood: 99 -> 82) :"Damn it, you cheat!"
2020-10-05 19:20:50.953359+0800 hw1[7828:678305] 
2020-10-05 19:20:50.953498+0800 hw1[7828:678305] <<< Round 4 >>>
2020-10-05 19:20:50.953646+0800 hw1[7828:678305] Huatuo ate a peach :"Kill me, you loser"
2020-10-05 19:20:50.953805+0800 hw1[7828:678305] Huatuo blood : 80 -> 90
2020-10-05 19:20:50.953946+0800 hw1[7828:678305] 
2020-10-05 19:20:50.954099+0800 hw1[7828:678305] Zhouyu set fire on Huatuo's boat
2020-10-05 19:20:50.954267+0800 hw1[7828:678305] Zhouyu hit Huatuo, with 12 burn damage!
2020-10-05 19:20:50.954442+0800 hw1[7828:678305] Huatuo (blood: 90 -> 70) :"Damn it, you cheat!"
2020-10-05 19:20:50.954583+0800 hw1[7828:678305] 
2020-10-05 19:20:50.954745+0800 hw1[7828:678305] <<< Round 5 >>>
2020-10-05 19:20:50.954879+0800 hw1[7828:678305] Huatuo ate a peach :"Kill me, you loser"
2020-10-05 19:20:50.955010+0800 hw1[7828:678305] Huatuo blood : 68 -> 78
2020-10-05 19:20:50.955122+0800 hw1[7828:678305] 
2020-10-05 19:20:50.955287+0800 hw1[7828:678305] Zhouyu set fire on Huatuo's boat
2020-10-05 19:20:50.955475+0800 hw1[7828:678305] Zhouyu hit Huatuo, with 15 burn damage!
2020-10-05 19:20:50.955607+0800 hw1[7828:678305] Huatuo (blood: 78 -> 55) :"Damn it, you cheat!"
2020-10-05 19:20:50.955742+0800 hw1[7828:678305] 
2020-10-05 19:20:50.955885+0800 hw1[7828:678305] <<< Round 6 >>>
2020-10-05 19:20:50.956030+0800 hw1[7828:678305] Huatuo ate a peach :"Kill me, you loser"
2020-10-05 19:20:50.956189+0800 hw1[7828:678305] Huatuo blood : 53 -> 63
2020-10-05 19:20:50.956358+0800 hw1[7828:678305] 
2020-10-05 19:20:50.956524+0800 hw1[7828:678305] Zhouyu set fire on Huatuo's boat
2020-10-05 19:20:50.956698+0800 hw1[7828:678305] Zhouyu hit Huatuo, with 18 burn damage!
2020-10-05 19:20:50.956856+0800 hw1[7828:678305] Huatuo (blood: 63 -> 37) :"Damn it, you cheat!"
2020-10-05 19:20:50.957025+0800 hw1[7828:678305] 
2020-10-05 19:20:50.957187+0800 hw1[7828:678305] <<< Round 7 >>>
2020-10-05 19:20:50.957366+0800 hw1[7828:678305] Huatuo ate a peach :"Kill me, you loser"
2020-10-05 19:20:50.957532+0800 hw1[7828:678305] Huatuo blood : 35 -> 45
2020-10-05 19:20:50.957697+0800 hw1[7828:678305] 
2020-10-05 19:20:50.957877+0800 hw1[7828:678305] Zhouyu set fire on Huatuo's boat
2020-10-05 19:20:50.958026+0800 hw1[7828:678305] Zhouyu hit Huatuo, with 21 burn damage!
2020-10-05 19:20:50.958189+0800 hw1[7828:678305] Huatuo (blood: 45 -> 16) :"Damn it, you cheat!"
2020-10-05 19:20:50.958320+0800 hw1[7828:678305] 
2020-10-05 19:20:50.958469+0800 hw1[7828:678305] <<< Round 8 >>>
2020-10-05 19:20:50.958626+0800 hw1[7828:678305] Huatuo ate a peach :"Kill me, you loser"
2020-10-05 19:20:50.958733+0800 hw1[7828:678305] Huatuo blood : 14 -> 24
2020-10-05 19:20:50.958874+0800 hw1[7828:678305] 
2020-10-05 19:20:50.959020+0800 hw1[7828:678305] Zhouyu set fire on Huatuo's boat
2020-10-05 19:20:50.959167+0800 hw1[7828:678305] Zhouyu hit Huatuo, with 24 burn damage!
2020-10-05 19:20:50.959318+0800 hw1[7828:678305] Huatuo (blood: 24 -> 0) :"Damn it, you cheat!"
2020-10-05 19:20:50.959477+0800 hw1[7828:678305] Zhouyu won the fight!
```

### 2.2 Polymorphism

Take an example: the action method of class Hero : 

```objc
- (BOOL)action:(Hero *)target;
```

The **action** method presets the behaviors of a hero in a fight. This method was designed to be like a virtual function in JAVA or C++, meaning it is not implemented in the Hero interface, 

```objc
@implementation Hero

...

- (BOOL)action:(Hero *)target
{
    // no implementation in Hero class
    return NO;
}

...

@end
```

Meanwhile, each subInterface of Hero (each specific hero) will have his/her own version of action method. For example, Zhangfei:

```objc
@implementation Zhangfei : Hero

...

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

...

@end

```



Except action method, other methods of interface Hero using polymorphism:

- (void)init
- (void)hit:(Hero *)target;

### 2.3 OO design

You simply can't manage to write code without OO design in your mind.
Here's about mine:

1. Encapsulation : for each kind of data in Hero interface and its subInterfaces, a getter was provided, and all data enquiries, apart from enquiring oneself, are through those getters.

```objc
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
```

2. Inheritance

Obvious inheritance relationships:
```objc
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
```

3. Polymorphism

Above in 2.2


### 2.4 Hero and skill designs

|Hero Name|Skill|Description|
|:--|:--|:--|
|Zhangfei|heavyStrike| Use energy, cause direct damage|
|Zhangfei|shoutTo| Use energy, reduce enemy's energy|
|Lvbu|getPower|Use energy, improve damage|
|Diaochan|lure|Use energy, steal blood|
|Kongming|energySteal|steal energy|
|Kongming|curse|Use energy, cause direct damage|
|Huatuo|cure|gain blood|
|Guanyu|no|Pure high damage|
|Zhouyu|burn|stack burn damage|
|Caocao|blackMail|Use energy, steal damage|
|Simayi|thunderStrike|Use energy, cause direct damage|
|Liubei|exchange|exchange blood when blood is much lower than enemy|
|Xiahoudun|no|Pure high damage with self damage|





