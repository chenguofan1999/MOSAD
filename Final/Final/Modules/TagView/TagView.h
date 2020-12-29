//
//  TagView.h
//  Final
//
//  Created by itlab on 12/23/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TagView : UIScrollView
//@property (nonatomic) CGFloat height;
@property (nonatomic, retain) NSArray *tagArray;
@property (nonatomic,strong) NSMutableArray *buttons;

- (instancetype)initWithTagArray:(NSArray*)tagArray;
- (instancetype)initWithFrame:(CGRect)frame tagArray:(NSArray*)tagArray;
@end

NS_ASSUME_NONNULL_END
