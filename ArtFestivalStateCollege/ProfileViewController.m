//
//  ProfileViewController.m
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 4/6/15.
//  Copyright (c) 2015 Kyungsik Han. All rights reserved.
//

#import "ProfileViewController.h"
#import "LoginViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "UserPhotoListViewController.h"
#import "ChooseInterestViewController.h"
#import "AppDelegate.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

@synthesize profileImage, logoutBtn, seePhotosBtn, updateBtn, userNameLabel;
@synthesize changeProfilePhotoBtn;
@synthesize photosLabel, commentsLabel, likesLabel, uniqueUsersLabel;
@synthesize userID;

@synthesize interestBtn1, interestBtn2, interestBtn3, interestBtn4, interestBtn5, interestBtn6, interestBtn7;
@synthesize photosTextLabel, commentsTextLabel, likesTextLabel, uniqueUsersTextLabel;

#define PROFILE_PAGE 2

NSString *username;
NSString *email;
NSString *profileImageLink;

NSMutableArray *userPhotoArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // button rounded corner
    logoutBtn.layer.cornerRadius = 5;
    logoutBtn.layer.borderWidth = 1;

    seePhotosBtn.layer.cornerRadius = 5;
    seePhotosBtn.layer.borderWidth = 1;
    
    updateBtn.layer.cornerRadius = 5;
    updateBtn.layer.borderWidth = 1;

    changeProfilePhotoBtn.layer.cornerRadius = 5;
    changeProfilePhotoBtn.layer.borderWidth = 1;
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (userID == [[userDefault objectForKey:@"user_id"]intValue]) {
        updateBtn.hidden = NO;
        updateBtn.enabled = YES;
        logoutBtn.hidden = NO;
        logoutBtn.enabled = YES;
    }
    else {
        updateBtn.hidden = YES;
        updateBtn.enabled = NO;
        logoutBtn.hidden = YES;
        logoutBtn.enabled = NO;
    }
    
    [self downloadProfile];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"ProfileViewController";
    self.navigationItem.backBarButtonItem.title = @"Back";
    self.hidesBottomBarWhenPushed = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) downloadProfile {
    
    //NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user_id"     :[NSString stringWithFormat:@"%d", userID]};
    
    [manager POST:@"http://heounsuk.com/festival/download_user_profile.php" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);

        if([[responseObject objectForKey:@"success"] boolValue] == TRUE) {
            NSMutableArray *jsonArray = [NSMutableArray arrayWithCapacity:0];
            userPhotoArray = [NSMutableArray arrayWithCapacity:0];
            [jsonArray addObjectsFromArray:[responseObject objectForKey:@"results"]];
            
            NSMutableDictionary *item = [jsonArray objectAtIndex:0];
            
            username = [item objectForKey:@"name"];
            email = [item objectForKey:@"email"];
            profileImageLink = [item objectForKey:@"image"];
            
            userPhotoArray = [item objectForKey:@"user_content"];
            
            NSLog(@"%@", profileImage);
            
            // update the UI
            // user name
            userNameLabel.text = username;
            // profile image
            [profileImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", profileImageLink]]];
            profileImage.layer.cornerRadius = 4.0f;
            profileImage.clipsToBounds = YES;
            // other stats
            
            int userCommentsCnt = [[item objectForKey:@"user_comments_cnt"] intValue];
            int userLikesCnt = [[item objectForKey:@"user_likes_cnt"] intValue];
            int userPhotosCnt = [[item objectForKey:@"user_content"] count];
            int userTaggedUsersCnt = [[item objectForKey:@"tagged_user"]count];
            
            if (userCommentsCnt <= 1) {
                commentsLabel.text = [NSString stringWithFormat:@"%d", userCommentsCnt];
                commentsTextLabel.text = @"comment";
            }
            else {
                commentsLabel.text = [NSString stringWithFormat:@"%d", userCommentsCnt];
                commentsTextLabel.text = @"comments";
            }
            
            if (userLikesCnt <= 1) {
                likesLabel.text = [NSString stringWithFormat:@"%d", userLikesCnt];
                likesTextLabel.text = @"like";
            }
            else {
                likesLabel.text = [NSString stringWithFormat:@"%d", userLikesCnt];
                likesTextLabel.text = @"likes";
            }
            
            if (userPhotosCnt <= 1) {
                photosLabel.text = [NSString stringWithFormat:@"%d", userPhotosCnt];
                photosTextLabel.text = @"photo";
            }
            else {
                photosLabel.text = [NSString stringWithFormat:@"%d", userPhotosCnt];
                photosTextLabel.text = @"photos";
            }
            
            if (userTaggedUsersCnt <= 1) {
                uniqueUsersLabel.text = [NSString stringWithFormat:@"%d", userTaggedUsersCnt];
                uniqueUsersTextLabel.text = @"unique user";
            }
            else {
                uniqueUsersLabel.text = [NSString stringWithFormat:@"%d", userTaggedUsersCnt];
                uniqueUsersTextLabel.text = @"unique users";
            }

            
            // preferences
            // change the alpha value of interest btn depending on its value
            NSMutableDictionary *preferences = [item objectForKey:@"user_preferences"];
            int interest1 = [[preferences objectForKey:@"interest_1"] intValue];
            int interest2 = [[preferences objectForKey:@"interest_2"] intValue];
            int interest3 = [[preferences objectForKey:@"interest_3"] intValue];
            int interest4 = [[preferences objectForKey:@"interest_4"] intValue];
            int interest5 = [[preferences objectForKey:@"interest_5"] intValue];
            int interest6 = [[preferences objectForKey:@"interest_6"] intValue];
            int interest7 = [[preferences objectForKey:@"interest_7"] intValue];
            
            if (interest1 == 0) {
                interestBtn1.alpha = 0.3;
            }
            if (interest2 == 0) {
                interestBtn2.alpha = 0.3;
            }
            if (interest3 == 0) {
                interestBtn3.alpha = 0.3;
            }
            if (interest4 == 0) {
                interestBtn4.alpha = 0.3;
            }
            if (interest5 == 0) {
                interestBtn5.alpha = 0.3;
            }
            if (interest6 == 0) {
                interestBtn6.alpha = 0.3;
            }
            if (interest7 == 0) {
                interestBtn7.alpha = 0.3;
            }

        }
        else {
            UIAlertView *dialog = [[UIAlertView alloc]init];
            [dialog setDelegate:nil];
            [dialog setTitle:@"Message"];
            [dialog setMessage:[responseObject objectForKey:@"message"]];
            [dialog addButtonWithTitle:@"OK"];
            [dialog show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // Logout
        
        // remove all keys in NSUserDefaults
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString *deviceToken = [userDefault objectForKey:@"device_token"];
        
        NSDictionary * dict = [userDefault dictionaryRepresentation];
        for (id key in dict) {
            [userDefault removeObjectForKey:key];
        }
        [userDefault synchronize];
        
        // add a device token again to userDefault
        // this device token should be removed
        [userDefault setObject:deviceToken forKey:@"device_token"];
        
        // move to the login page
        LoginViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        //[self presentViewController:viewController animated:NO completion:nil];
        viewController.hidesBottomBarWhenPushed = YES;
        [viewController.navigationController setNavigationBarHidden:YES];
        [self.navigationController pushViewController:viewController animated:YES];
        [self removeFromParentViewController];
        // [self.navigationController pushViewController:viewController animated:YES];
        
    }
    else { // Cancel
        
    }
}

- (IBAction)logoutBtnPressed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Proceed to logout?" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Logout", nil];
    [alert show];
}

- (IBAction)updateBtnPressed:(id)sender {
    
}

- (IBAction)seePhotosBtnPressed:(id)sender {
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString: @"UserPhotoListViewController"]) {
        
        UserPhotoListViewController *viewController = (UserPhotoListViewController *)[segue destinationViewController];
        viewController.photoList = userPhotoArray;
        viewController.username = username;
    }
    else if ([[segue identifier] isEqualToString: @"ChooseInterestViewController"]) {
        
        ChooseInterestViewController *viewController = (ChooseInterestViewController *)[segue destinationViewController];
        viewController.previousViewController = PROFILE_PAGE;
    }
    else {
        
    }
}

- (IBAction)changeProfilePhotoBtnPressed:(id)sender {
    
}

@end
