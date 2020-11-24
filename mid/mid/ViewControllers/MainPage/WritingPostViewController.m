//
//  PostViewController.m
//  mid
//
//  Created by itlab on 2020/11/23.
//

#import "WritingPostViewController.h"

@interface WritingPostViewController ()

@end

@implementation WritingPostViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithTitle:@"Post"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(postIt)];
    [self.navigationItem setRightBarButtonItem:postButton];
}

- (void)postIt
{
    
}


@end
