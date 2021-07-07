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

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDate *dateString = self.post.createdAt;
    self.timestampLabel.text = dateString.shortTimeAgoSinceNow;
    NSLog(@"return%@", self.post);

    PFFileObject *postPicture = self.post[@"image"];
    [postPicture getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            self.userProfile.image = [UIImage imageWithData:imageData];
        }
    }];
    
    self.captionLabel.text = self.post[@"caption"];
    
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
