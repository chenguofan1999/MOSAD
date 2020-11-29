//
//  UIResponder+Scene.m
//  mid
//
//  Created by itlab on 11/29/20.
//

#import "UIResponder+Scene.h"

@implementation UIResponder (Scene)

- (UIScene *)scene {
    return nil;
}

@end

@implementation UIScene (Scene)

- (UIScene *)scene {
    return self;
}

@end

@implementation UIView (Scene)

- (UIScene *)scene {
    if (self.window) {
        return self.window.windowScene;
    } else {
        return self.nextResponder.scene;
    }
}

@end

@implementation UIViewController (Scene)

- (UIScene *)scene {
    UIScene *res = self.nextResponder.scene;
    if (!res) {
        res = self.parentViewController.scene;
    }
    if (!res) {
        res = self.presentingViewController.scene;
    }

    return res;
}

@end
