//
//  EditSettingsViewController.m
//  instagram-mock
//
//  Created by mwen on 7/9/21.
//

#import "EditSettingsViewController.h"
#import "Parse/Parse.h"
@interface EditSettingsViewController ()
@property (weak, nonatomic) IBOutlet UITextView *updateBioField;

@end

@implementation EditSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.updateBioField.text = PFUser.currentUser[@"description"];
}

- (IBAction)cancelUpdates:(id)sender {
    [super.navigationController popViewControllerAnimated:YES];
}

- (IBAction)updated:(id)sender {
    PFUser.currentUser[@"description"] = self.updateBioField.text;
    [PFUser.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Did not save correctly");
        }
    }];
    
    [self.delegate ProfileViewController:self finishedUpdating:self.updateBioField.text];
    [super.navigationController popViewControllerAnimated:YES];
}

@end
