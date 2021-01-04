//
//  PostContentViewController.m
//  Final
//
//  Created by itlab on 12/28/20.
//

#import "PostContentViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <MaterialComponents/MDCButton+MaterialTheming.h>

@interface PostContentViewController ()
@property (nonatomic, strong) MDCButton *chooseCoverImageButton;
@property (nonatomic, strong) MDCButton *chooseVideoButton;
@property (nonatomic, strong) MDCButton *sendButton;
@end

@implementation PostContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor grayColor]];
    // Do any additional setup after loading the view.
    
}



@end
