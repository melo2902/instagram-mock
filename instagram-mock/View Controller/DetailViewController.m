//
//  DetailViewController.m
//  instagram-mock
//
//  Created by mwen on 7/7/21.
//

#import "DetailViewController.h"
#import "DateTools.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userProfile;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userPFP;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDate *dateString = self.post.createdAt;
    self.timestampLabel.text = dateString.shortTimeAgoSinceNow;
    
    PFUser *user = self.post[@"author"];
    if (user[@"pfp"]) {
        PFFileObject *pfp = user[@"pfp"];
        
        [pfp getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                UIImage *originalImage = [UIImage imageWithData:imageData];
                self.userPFP.image = originalImage;
                self.userPFP.layer.cornerRadius = self.userPFP.frame.size.width / 2;
                self.userPFP.clipsToBounds = true;
            }
        }];
    }
    
    self.usernameLabel.text = user.username;
    
    PFFileObject *postPicture = self.post[@"image"];
    [postPicture getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            self.userProfile.image = [UIImage imageWithData:imageData];
        }
    }];
    
    self.captionLabel.attributedText = [self modifyUsername:user.username withCaption:self.post[@"caption"]];
}

-(NSMutableAttributedString *)modifyUsername:(NSString *)usernameString withCaption:(NSString *)postCaption {
    NSUInteger usernameLength = [usernameString length];

    NSMutableAttributedString *caption = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", usernameString, postCaption]];
    NSRange selectedRange = NSMakeRange(0, usernameLength);

    [caption beginEditing];
    
    [caption addAttribute:NSFontAttributeName
               value:[UIFont fontWithName:@"Helvetica-Bold" size:17.0]
               range:selectedRange];

    [caption endEditing];
    
    return caption;
}

@end
