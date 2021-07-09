//
//  EditSettingsViewController.h
//  instagram-mock
//
//  Created by mwen on 7/9/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class EditSettingsViewController;

@protocol EditSettingsViewControllerDelegate <NSObject>
- (void)ProfileViewController:(EditSettingsViewController *)controller finishedUpdating:(NSString *)description;
@end

@interface EditSettingsViewController : UIViewController

@property (nonatomic, weak) id <EditSettingsViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
