//
//  DetailViewController.h
//  hw2
//
//  Created by itlab on 2020/11/9.
//  Copyright © 2020 itlab. All rights reserved.
//

#ifndef DetailViewController_h
#define DetailViewController_h

@interface DetailViewController : UIViewController

- (instancetype)initWithIndex:(int)index;
@property (nonatomic, strong) UIView *textView;
@property (nonatomic, strong) UIView *picView;
@end
#endif /* DetailViewController_h */
