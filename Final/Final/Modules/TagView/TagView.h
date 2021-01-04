//
//  TagView.h
//  Final
//
//  Created by itlab on 12/23/20.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TagViewType) {
    UserTagView,
    VideoTagView
};

@protocol tagBtnDelegate <NSObject>

- (void) allBtnClick:(UIButton *)btn;
- (void) tagBtnClick:(UIButton *)btn;
- (void) addBtnClick:(UIButton *)btn;
- (void) longPressBtn:(UIButton *)btn;

@end

@interface TagView : UIScrollView
@property (nonatomic, retain) NSMutableArray *tagArray;
@property (weak, nonatomic) id<tagBtnDelegate> tagDelegate;
- (instancetype)initWithTagArray:(NSMutableArray *)tagArray viewType:(TagViewType)type;
- (void)updateTagButtons;
- (void)clearSelect;
@end

NS_ASSUME_NONNULL_END
