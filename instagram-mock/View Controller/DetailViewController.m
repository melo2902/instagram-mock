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
    
    //        Pull this into a different function
    NSUInteger usernameLength = [user.username length];
    
    NSMutableAttributedString *caption = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", user.username,  self.post[@"caption"]]];
    NSRange selectedRange = NSMakeRange(0, usernameLength);
    
    [caption beginEditing];
    
    [caption addAttribute:NSFontAttributeName
                    value:[UIFont fontWithName:@"Helvetica-Bold" size:17.0]
                    range:selectedRange];
    
    [caption endEditing];
    
    self.captionLabel.attributedText = caption;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
