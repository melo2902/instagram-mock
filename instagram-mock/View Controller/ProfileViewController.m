//
//  ProfileViewController.m
//  instagram-mock
//
//  Created by mwen on 7/8/21.
//

#import "ProfileViewController.h"
#import "Parse/Parse.h"
#import "CollectionPostCell.h"
#import "Post.h"
//#import "InstaUser.h"

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *numberPostsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePictureView;
@property (strong, nonatomic) NSArray *ownPostsArray;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self getPosts];
    
    NSLog(@"%@", PFUser.currentUser[@"pfp"]);
    if (PFUser.currentUser[@"pfp"]) {
        PFFileObject *pfp = PFUser.currentUser[@"pfp"];
        
        [pfp getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                self.profilePictureView.image = [UIImage imageWithData:imageData];
            }
        }];
    }
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 1;
    
    CGFloat postersPerLine = 3;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (postersPerLine - 1)) / postersPerLine;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

- (void)getPosts {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    // to make this generalizable, can't use PFUser.currentUser (will pass in the metric)
    [query whereKey:@"author" equalTo:PFUser.currentUser];
    [query orderByDescending:@"createdAt"];
//    query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.ownPostsArray = posts;
            self.numberPostsLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)posts.count];
            self.username.text = PFUser.currentUser.username;
            [self.collectionView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (IBAction)addPFP:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;

    // The Xcode simulator does not support taking pictures, so let's first check that the camera is indeed supported on the device before trying to present it.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    self.profilePictureView.image = [self resizeImage:editedImage withSize: CGSizeMake(5, 5)];
    PFUser.currentUser[@"pfp"] = [self getPFFileFromImage:self.profilePictureView.image];
//    InstaUser.currentUser.pfp = [self getPFFileFromImage:self.profilePictureView.image];
    [PFUser.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Did not save correctly");
        }
    }];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
 
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithData:imageData];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CollectionPostCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionPostCell" forIndexPath:indexPath];
    
    Post *post = self.ownPostsArray[indexPath.row];
    
    PFFileObject *postPicture = post[@"image"];
    [postPicture getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            cell.imageView.image = [UIImage imageWithData:imageData];
        }
    }];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.ownPostsArray.count;
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
