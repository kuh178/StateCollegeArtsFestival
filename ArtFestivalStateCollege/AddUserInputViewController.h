//
//  AddUserInputViewController.h
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 3/4/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddUsersViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "GAITrackedViewController.h"

@interface AddUserInputViewController : GAITrackedViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate, AddUsersViewControllerDelegate, CLLocationManagerDelegate> {
    IBOutlet UIImageView        *imageView;
    IBOutlet UIBarButtonItem    *takePhotoBtn;

    IBOutlet UIButton           *uploadBtn;
    IBOutlet UIButton           *tagUsersBtn;
    
    IBOutlet UITextField        *commentText;
    IBOutlet UILabel            *imageText;
    
    double latitude;
    double longitude;
    
    int eventID;
    int fromEvent;
}

@property (nonatomic, retain) IBOutlet UIImageView      *imageView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem  *takePhotoBtn;
@property (nonatomic, retain) IBOutlet UIButton         *uploadBtn;
@property (nonatomic, retain) IBOutlet UIButton         *tagUsersBtn;

@property (nonatomic, retain) IBOutlet UITextField      *commentText;
@property (nonatomic, retain) IBOutlet UILabel          *imageText;

@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) int eventID;
@property (nonatomic, assign) int fromEvent;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *startLocation;

-(IBAction)takePhotoBtnPress:(id)sender;
-(IBAction)addVoiceBtnPress:(id)sender;
-(IBAction)uploadBtnPress:(id)sender;
-(IBAction)tagUsersBtnPress:(id)sender;

@end
