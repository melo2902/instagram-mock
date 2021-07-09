//
//  HomeFeedViewController.m
//  instagram-mock
//
//  Created by mwen on 7/6/21.
//

#import "HomeFeedViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Parse/Parse.h"
#import "PostCell.h"
#import "Post.h"
#import "DetailViewController.h"
#import "DateTools.h"
#import "SceneDelegate.h"

@interface HomeFeedViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *posts;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation HomeFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self getPosts];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
}

- (void)getPosts {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query includeKey:@"author"];
    [query orderByDescending:@"createdAt"];
    //    query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = posts;
            
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    [self.refreshControl endRefreshing];
}

- (IBAction)onLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
    
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    sceneDelegate.window.rootViewController = loginViewController;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell" forIndexPath:indexPath];
    
    Post *post = self.posts[indexPath.row];
    NSDate *dateString = post.createdAt;
    cell.creationField.text = dateString.shortTimeAgoSinceNow;
    
    PFUser *user = post[@"author"];
    
    if (user != nil) {
        // User found! update username label with username
        cell.username.text = user.username;
        NSUInteger usernameLength = [user.username length];
        
//        Pull this into a different function
        NSMutableAttributedString *caption = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", user.username,  post[@"caption"]]];
        NSRange selectedRange = NSMakeRange(0, usernameLength);

        [caption beginEditing];
        
        [caption addAttribute:NSFontAttributeName
                   value:[UIFont fontWithName:@"Helvetica-Bold" size:17.0]
                   range:selectedRange];

        [caption endEditing];
        
        cell.captionField.attributedText = caption;
        
    } else {
        // No user found, set default username
        // This should not be hit
        cell.username.text = @"🤖";
        cell.captionField.text = post[@"caption"];
    }
    
    PFFileObject *postPicture = post[@"image"];
    [postPicture getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            cell.postPicture.image = [UIImage imageWithData:imageData];
        }
    }];
    
    if (user[@"pfp"]){
        PFFileObject *pfp = user[@"pfp"];
        [pfp getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                UIImage *originalImage = [UIImage imageWithData:imageData];
                cell.pfpView.image = originalImage;
                cell.pfpView.layer.cornerRadius = cell.pfpView.frame.size.width / 2;
                cell.pfpView.clipsToBounds = true;
            }
        }];
    }
    
    cell.post = post;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Deselect the row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqual:@"showDetailsSegue"]) {
        PostCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Post *post = self.posts[indexPath.row];
        
        DetailViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.post = post;
    }
}

@end
