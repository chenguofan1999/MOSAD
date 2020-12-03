//
//  PostViewController.h
//  mid
//
//  Created by itlab on 11/26/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostViewController : UITableViewController
@property (nonatomic) NSString *userID;
@property (nonatomic) NSString *userName;
@property (nonatomic) NSString *contentType;
- (instancetype)initWithType:(NSString *)contentType
                      UserID:(NSString *)userID;
@end

NS_ASSUME_NONNULL_END
