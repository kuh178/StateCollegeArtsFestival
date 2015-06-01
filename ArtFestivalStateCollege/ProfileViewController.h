//
//  ProfileViewController.h
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 4/6/15.
//  Copyright (c) 2015 Kyungsik Han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface ProfileViewController : GAITrackedViewController {
    IBOutlet UIImageView *profileImage;
    IBOutlet UIButton *logoutBtn;
    IBOutlet UIButton *seePhotosBtn;
    IBOutlet UIButton *updateBtn;
    
    IBOutlet UIButton *changeProfilePhotoBtn;

    IBOutlet UILabel *photosLabel;
    IBOutlet UILabel *commentsLabel;
    IBOutlet UILabel *likesLabel;
    IBOutlet UILabel *uniqueUsersLabel;
    IBOutlet UILabel *userNameLabel;
    
    IBOutlet UILabel *photosTextLabel;
    IBOutlet UILabel *commentsTextLabel;
    IBOutlet UILabel *likesTextLabel;
    IBOutlet UILabel *uniqueUsersTextLabel;
    
    IBOutlet UIButton *interestBtn1;
    IBOutlet UIButton *interestBtn2;
    IBOutlet UIButton *interestBtn3;
    IBOutlet UIButton *interestBtn4;
    IBOutlet UIButton *interestBtn5;
    IBOutlet UIButton *interestBtn6;
    IBOutlet UIButton *interestBtn7;
    
    IBOutlet UIView   *viewGraph1;
    IBOutlet UIView   *viewGraph2;
    
    IBOutlet UIBarButtonItem *moreBtn;
    IBOutlet UIButton *yoBtn;
    
    
    int userID;
}

@property (nonatomic, retain) IBOutlet UIImageView *profileImage;
@property (nonatomic, retain) IBOutlet UIButton *logoutBtn;
@property (nonatomic, retain) IBOutlet UIButton *seePhotosBtn;
@property (nonatomic, retain) IBOutlet UIButton *updateBtn;
@property (nonatomic, retain) IBOutlet UIButton *changeProfilePhotoBtn;

@property (nonatomic, retain) IBOutlet UILabel *userNameLabel;

@property (nonatomic, retain) IBOutlet UILabel *photosLabel;
@property (nonatomic, retain) IBOutlet UILabel *commentsLabel;
@property (nonatomic, retain) IBOutlet UILabel *likesLabel;
@property (nonatomic, retain) IBOutlet UILabel *uniqueUsersLabel;

@property (nonatomic, retain) IBOutlet UILabel *photosTextLabel;
@property (nonatomic, retain) IBOutlet UILabel *commentsTextLabel;
@property (nonatomic, retain) IBOutlet UILabel *likesTextLabel;
@property (nonatomic, retain) IBOutlet UILabel *uniqueUsersTextLabel;

@property (nonatomic, retain) IBOutlet UIButton *interestBtn1;
@property (nonatomic, retain) IBOutlet UIButton *interestBtn2;
@property (nonatomic, retain) IBOutlet UIButton *interestBtn3;
@property (nonatomic, retain) IBOutlet UIButton *interestBtn4;
@property (nonatomic, retain) IBOutlet UIButton *interestBtn5;
@property (nonatomic, retain) IBOutlet UIButton *interestBtn6;
@property (nonatomic, retain) IBOutlet UIButton *interestBtn7;

@property (nonatomic, retain) IBOutlet UIView   *viewGraph1;
@property (nonatomic, retain) IBOutlet UIView   *viewGraph2;

@property (nonatomic, retain) IBOutlet UIButton *yoBtn;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *moreBtn;

@property (nonatomic, assign) int userID;

- (IBAction)changeProfilePhotoBtnPressed:(id)sender;
- (IBAction)updateBtnPressed:(id)sender;
- (IBAction)seePhotosBtnPressed:(id)sender;
- (IBAction)logoutBtnPressed:(id)sender;
- (IBAction)moreBtnPressed:(id)sender;
- (IBAction)yoBtnPressed:(id)sender;

@end
