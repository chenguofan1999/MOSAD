//
//  TagView.h
//  Final
//
//  Created by itlab on 12/23/20.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@protocol tagBtnDelegate <NSObject>

- (void) tagBtnClick:(UIButton *)btn;

@end

@interface TagView : UIScrollView
@property (weak, nonatomic) id<tagBtnDelegate> tagDelegate;
- (instancetype)initWithTagArray:(NSArray*)tagArray;
- (instancetype)initWithFrame:(CGRect)frame tagArray:(NSArray*)tagArray;
- (void)updateTagButtons;
@end

NS_ASSUME_NONNULL_END
