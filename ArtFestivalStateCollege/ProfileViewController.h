//
//  ProfileViewController.h
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 4/6/15.
//  Copyright (c) 2015 Kyungsik Han. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController {
    IBOutlet UIImageView *profileImage;
    IBOutlet UIButton *logoutBtn;
    IBOutlet UIButton *seePhotosBtn;
    IBOutlet UIButton *updateBtn;

    IBOutlet UILabel *photosLabel;
    IBOutlet UILabel *commentsLabel;
    IBOutlet UILabel *likesLabel;
    IBOutlet UILabel *uniqueUsersLabel;
    IBOutlet UILabel *userNameLabel;
    
    int userID;
}

@property (nonatomic, retain) IBOutlet UIImageView *profileImage;
@property (nonatomic, retain) IBOutlet UIButton *logoutBtn;
@property (nonatomic, retain) IBOutlet UIButton *seePhotosBtn;
@property (nonatomic, retain) IBOutlet UIButton *updateBtn;
@property (nonatomic, retain) IBOutlet UILabel *userNameLabel;

@property (nonatomic, retain) IBOutlet UILabel *photosLabel;
@property (nonatomic, retain) IBOutlet UILabel *commentsLabel;
@property (nonatomic, retain) IBOutlet UILabel *likesLabel;
@property (nonatomic, retain) IBOutlet UILabel *uniqueUsersLabel;

@property (nonatomic, assign) int userID;

- (IBAction)updateBtnPressed:(id)sender;
- (IBAction)seePhotosBtnPressed:(id)sender;
- (IBAction)logoutBtnPressed:(id)sender;

@end
