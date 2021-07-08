//
//  InstaUser.m
//  instagram-mock
//
//  Created by mwen on 7/8/21.
//

#import "InstaUser.h"

@implementation InstaUser
@dynamic username;
@dynamic password;
@dynamic pfp;

+ (InstaUser *)user {
    return (InstaUser *)[PFUser user];
}

@end
