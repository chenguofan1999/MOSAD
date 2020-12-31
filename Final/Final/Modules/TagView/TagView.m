//
//  TagView.m
//  Final
//
//  Created by itlab on 12/23/20.
//

#import "TagView.h"
#import "UserInfo.h"

@interface TagView()
@property (nonatomic, retain) NSArray *tagArray;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic) NSString *currentTag;
// 选中标签文字颜色
@property (nonatomic,retain) UIColor* textColorSelected;
// 默认标签文字颜色
@property (nonatomic,retain) UIColor* textColorNormal;
// 选中标签背景颜色
@property (nonatomic,retain) UIColor* backgroundColorSelected;
// 默认标签背景颜色
@property (nonatomic,retain) UIColor* backgroundColorNormal;
@end

@implementation TagView

- (instancetype)initWithTagArray:(NSArray *)tagArray
{
    CGFloat w = [[UIScreen mainScreen] bounds].size.width;
    return [[TagView alloc]initWithFrame:CGRectMake(0, 0, w, 50) tagArray:tagArray];
}

- (instancetype)initWithFrame:(CGRect)frame tagArray:(NSArray *)tagArray
{
    self = [super initWithFrame:frame];
    if (self) {
        _tagArray = tagArray;
        [self setColors];
        [self updateTagButtons];
        [self setShowsHorizontalScrollIndicator:NO];
        [self setBounces:NO];
        [[UserInfo sharedUser] addObserver: self
                                forKeyPath:@"userTags"
                                   options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                   context:@"userTags changed"];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"监听到%@的%@属性值改变了 - %@ - %@", object, keyPath, change, context);
    [self updateTagButtons];
}

- (void)setColors
{
    [self setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1]];
    _textColorNormal = [UIColor blackColor];
    _textColorSelected = [UIColor whiteColor];
    _backgroundColorSelected = [UIColor darkGrayColor];
    _backgroundColorNormal = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
}

- (void)updateTagButtons
{
    // update tags first
    self.tagArray = [UserInfo sharedUser].userTags;
    
    if([_buttons count] == [_tagArray count]) return;
    
    _buttons = [NSMutableArray new];
    // 屏幕宽度
    CGFloat w = self.frame.size.width;
    // 区域高度
    CGFloat h = self.frame.size.height;
    // 按钮高度
    CGFloat btnH = h - 12;
    // 距离左边距
    CGFloat toLeft = 6;
    // 距离上边距
    CGFloat toTop = 10;
    // 按钮左右间隙
    CGFloat marginX = 10;
    // 文字左右间隙
    CGFloat fontMargin = 14;
    
    [self setContentSize:CGSizeMake(w, h)];
    
    for(int i = 0; i < [self.tagArray count]; i++)
    {
        NSString *tagString = self.tagArray[i];
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(toLeft, toTop, 100, btnH);
        btn.tag = 100 + i;
        
        /* ---------- 通用样式 ------------*/
        [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        
        /* ---------- 未选中样式 -----------*/
        [btn setTitle:tagString forState:UIControlStateNormal];
        [btn setBackgroundImage:[self imageWithColor:self.backgroundColorNormal] forState:UIControlStateNormal];
        [btn setTitleColor:self.textColorNormal forState:UIControlStateNormal];

        
        /* ---------- 选中样式 -----------*/
        [btn setTitle:tagString forState:UIControlStateSelected];
        [btn setTitleColor:self.textColorSelected forState:UIControlStateSelected];
        [btn setBackgroundImage:[self imageWithColor:self.backgroundColorSelected] forState:UIControlStateSelected];
        
    
        // 大小自适应
        [self buttonSizeToFit:btn fontMargin:fontMargin];
        
        // 圆角
        btn.layer.cornerRadius = btn.frame.size.height / 2.f;
        btn.layer.masksToBounds = YES;
        
        // 边框
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        btn.layer.borderWidth = 1;
        
        // 事件
        [btn addTarget:self action:@selector(selectdButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
        [_buttons addObject:btn];
        
        toLeft += btn.frame.size.width + marginX;
        if(toLeft > w) [self setContentSize:CGSizeMake(toLeft, h)];
    }
    
    
}

// 设置按钮的边距、间隙
- (void)buttonSizeToFit:(UIButton*)btn fontMargin:(CGFloat)fontMargin
{
    // 按钮自适应
    [btn sizeToFit];
    CGRect frame = btn.frame;
    frame.size.height += 12;
    frame.size.width += fontMargin * 2;
    if (frame.size.width < frame.size.height) frame.size.width = frame.size.height;
    btn.frame = frame;
}


// 根据颜色生成UIImage
- (UIImage*)imageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    // 开始画图的上下文
    UIGraphicsBeginImageContext(rect.size);
    
    // 设置背景颜色
    [color set];
    // 设置填充区域
    UIRectFill(CGRectMake(0, 0, rect.size.width, rect.size.height));
    
    // 返回UIImage
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    return image;
}

// 标签按钮点击事件
- (void)selectdButton:(UIButton*)btn
{
    if([btn isSelected]) return;
    else
    {
        [btn setSelected:YES];
        for(int i = 0; i < [_buttons count]; i++)
        {
            if(_buttons[i] != btn && [_buttons[i] isSelected])
            {
                [_buttons[i] setSelected:NO];
            }
        }
        
        // 调用代理
        if([self.tagDelegate respondsToSelector:@selector(tagBtnClick:)])
        {
            [self.tagDelegate tagBtnClick:btn];
        }
        else
        {
            NSLog(@"no delegate yer");
        }
        
    }
}






@end
