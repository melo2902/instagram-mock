//
//  PostCell.h
//  instagram-mock
//
//  Created by mwen on 7/6/21.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *captionField;
@property (weak, nonatomic) IBOutlet UILabel *creationField;
@property (weak, nonatomic) IBOutlet UIImageView *postPicture;
@property (weak, nonatomic) IBOutlet UIImageView *pfpView;
@property (strong, nonatomic) Post *post;
@end

NS_ASSUME_NONNULL_END
