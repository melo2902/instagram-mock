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
//    [query whereKey:@"likesCount" greaterThan:@100];
    [query includeKey:@"author"];
    query.limit = 20;

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
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
//    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
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
        cell.captionField.text = [NSString stringWithFormat:@"%@: %@", user.username,  post[@"caption"]];
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
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
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
       
        NSLog(@"%@", post);
       DetailViewController *detailsViewController = [segue destinationViewController];
       detailsViewController.post = post;
    }
}

@end
