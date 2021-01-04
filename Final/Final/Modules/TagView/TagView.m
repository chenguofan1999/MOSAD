//
//  TagView.m
//  Final
//
//  Created by itlab on 12/23/20.
//

#import "TagView.h"
#import "UserInfo.h"
#import "AppConfig.h"


@interface TagView()
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic) TagViewType viewType;

@property (nonatomic,retain) UIColor* textColorSelected;
@property (nonatomic,retain) UIColor* textColorNormal;
@property (nonatomic,retain) UIColor* backgroundColorSelected;
@property (nonatomic,retain) UIColor* backgroundColorNormal;
@end

@implementation TagView

- (instancetype)initWithTagArray:(NSMutableArray *)tagArray viewType:(TagViewType)type
{
    CGFloat w = [[UIScreen mainScreen] bounds].size.width;
    self = [super initWithFrame:CGRectMake(0, 0, w, 50)];
    _tagArray = tagArray;
    _viewType = type;
    [self setColors];
    [self updateTagButtons];
    [self setShowsHorizontalScrollIndicator:NO];
    [self setBounces:NO];
    return self;
}


- (void)setColors
{
    [self setBackgroundColor:[UIColor whiteColor]];
    _textColorNormal = [UIColor darkGrayColor];
    _textColorSelected = [UIColor whiteColor];
    _backgroundColorSelected = [UIColor darkGrayColor];
    _backgroundColorNormal = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
}

- (void)updateTagButtons
{
    // 清空
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
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
    
    // 'All' button
    if(self.viewType == UserTagView)
    {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.frame = CGRectMake(toLeft, toTop, 100, btnH);
        btn.tag = 50;
        [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [btn setTitle:@"All" forState:UIControlStateNormal];
        [btn setTitle:@"All" forState:UIControlStateSelected];
        [btn setTitleColor:self.textColorNormal forState:UIControlStateNormal];
        [btn setTitleColor:self.textColorSelected forState:UIControlStateSelected];
        [btn setBackgroundImage:[self imageWithColor:self.backgroundColorNormal] forState:UIControlStateNormal];
        [btn setBackgroundImage:[self imageWithColor:self.backgroundColorSelected] forState:UIControlStateSelected];
        
        [self buttonSizeToFit:btn fontMargin:fontMargin];
        
        // 圆角
        btn.layer.cornerRadius = btn.frame.size.height / 2.f;
        btn.layer.masksToBounds = YES;
        
        // 边框
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        btn.layer.borderWidth = 0;
        
        // 事件
        [btn addTarget:self action:@selector(selectAllButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
        [_buttons addObject:btn];
        
        toLeft += btn.frame.size.width + marginX;
        if(toLeft > w) [self setContentSize:CGSizeMake(toLeft, h)];
    }
    
    // tag button & + button
    for(int i = 0; i <= [self.tagArray count]; i++)
    {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        NSString *tagString;
        if(i == [self.tagArray count]) tagString = @"+";
        else tagString = self.tagArray[i];
        
        btn.frame = CGRectMake(toLeft, toTop, 100, btnH);
        btn.tag = 100 + i;

        /* ---------- 通用样式 ------------*/
        [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        
        /* ---------- 未选中样式 -----------*/
        [btn setTitle:tagString forState:UIControlStateNormal];
        [btn setBackgroundImage:[self imageWithColor:self.backgroundColorNormal] forState:UIControlStateNormal];
        if(i == [self.tagArray count]) [btn setTitleColor:[AppConfig getMainColor] forState:UIControlStateNormal];
        else [btn setTitleColor:self.textColorNormal forState:UIControlStateNormal];

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
        if(i < [self.tagArray count]) btn.layer.borderWidth = 0;
        
        if(i < [self.tagArray count])
        {
            // 事件
            [btn addTarget:self action:@selector(selectdButton:) forControlEvents:UIControlEventTouchUpInside];
            [btn addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressButton:)]];
        }
        else
        {
            [btn addTarget:self action:@selector(addTagButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [self addSubview:btn];
        [_buttons addObject:btn];
        
        toLeft += btn.frame.size.width + marginX;
        if(toLeft > w) [self setContentSize:CGSizeMake(toLeft, h)];
    }
}

// 设置按钮的边距、间隙
- (void)buttonSizeToFit:(UIButton*)btn fontMargin:(CGFloat)fontMargin
{
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
    UIGraphicsBeginImageContext(rect.size);
    [color set];
    UIRectFill(CGRectMake(0, 0, rect.size.width, rect.size.height));
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)clearSelect
{
    for(int i = 0; i < [_buttons count]; i++)
    {
        [_buttons[i] setSelected:NO];
    }
}

#pragma mark 触发代理
// 标签按钮点击事件
- (void)selectdButton:(UIButton*)btn
{
    if(self.viewType == UserTagView)
    {
        if([btn isSelected]) return;
        
        [btn setSelected:YES];
        for(int i = 0; i < [_buttons count]; i++)
        {
            if(_buttons[i] != btn && [_buttons[i] isSelected])
            {
                [_buttons[i] setSelected:NO];
            }
        }
    }
    
    // 调用代理
    if([self.tagDelegate respondsToSelector:@selector(tagBtnClick:)])
    {
        [self.tagDelegate tagBtnClick:btn];
    }
    else
    {
        NSLog(@"no delegate yet");
    }
    
}

- (void)addTagButton:(UIButton*)btn
{
//    [self clearSelect];
    // 调用代理
    if([self.tagDelegate respondsToSelector:@selector(addBtnClick:)])
    {
        [self.tagDelegate addBtnClick:btn];
    }
    else
    {
        NSLog(@"no delegate yer");
    }
}

- (void)longPressButton:(UILongPressGestureRecognizer *)longGes
{
    UIView* view = longGes.view;
    CGPoint loc = [longGes locationInView:view];
    UIButton* btn = (UIButton *)[view hitTest:loc withEvent:nil];
    
    // 调用代理
    if([self.tagDelegate respondsToSelector:@selector(longPressBtn:)])
    {
        [self.tagDelegate longPressBtn:btn];
    }
    else
    {
        NSLog(@"no delegate yer");
    }
}

- (void)selectAllButton:(UIButton *)btn
{
    if([btn isSelected]) return;
    
    [btn setSelected:YES];
    for(int i = 0; i < [_buttons count]; i++)
    {
        if(_buttons[i] != btn && [_buttons[i] isSelected])
        {
            [_buttons[i] setSelected:NO];
        }
    }
    // 调用代理
    if([self.tagDelegate respondsToSelector:@selector(allBtnClick:)])
    {
        [self.tagDelegate allBtnClick:btn];
    }
    else
    {
        NSLog(@"no delegate yer");
    }
}



@end
