//
//  InstaUser.h
//  instagram-mock
//
//  Created by mwen on 7/8/21.
//

#import "PFUser.h"
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface InstaUser : PFUser <PFSubclassing>
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) PFFileObject *pfp;

+ (InstaUser *)user;

@end

NS_ASSUME_NONNULL_END
