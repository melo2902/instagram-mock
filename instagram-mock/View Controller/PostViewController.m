//
//  PostViewController.m
//  instagram-mock
//
//  Created by mwen on 7/6/21.
//

#import "PostViewController.h"
#import <Parse/Parse.h>
#import "Post.h"

@interface PostViewController ()
@property (weak, nonatomic) IBOutlet UITextField *caption;

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)cancelPost:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)sharePost:(id)sender {
    
//    [postUserImage self.caption];
    
    [self dismissViewControllerAnimated:true completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)caption:(id)sender {
}
@end
