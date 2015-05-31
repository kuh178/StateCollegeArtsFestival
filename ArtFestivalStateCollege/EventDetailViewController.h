//
//  EventDetailViewController.h
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 3/4/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GAITrackedViewController.h"

@interface EventDetailViewController : GAITrackedViewController <CLLocationManagerDelegate> {
    IBOutlet UIImageView        *eventImage;
    IBOutlet UIImageView        *eventButtonImage;
    IBOutlet UIImageView        *eventWebImage;
    
    IBOutlet UILabel            *eventName;
    IBOutlet UILabel            *eventDatetime;
    IBOutlet UILabel            *eventButton;
    IBOutlet UILabel            *eventLocationName;
    IBOutlet UILabel            *eventAttendLabel;
    IBOutlet UILabel            *eventFavoriteLabel;
    
    IBOutlet UIButton           *eventGoingBtn;
    IBOutlet UIButton           *eventUserInputBtn;
    IBOutlet UIButton           *eventWebPageBtn;
    IBOutlet UIButton           *eventGoingAddBtn;
    IBOutlet UIButton           *eventLikeBtn;
    
    IBOutlet UIButton           *eventRemoveBtn;
    IBOutlet UIButton           *eventEditBtn;
    
    IBOutlet UIView             *eventView1;
    
    IBOutlet UIView             *view1;
    IBOutlet UIView             *view2;
    IBOutlet UIView             *view3;
    IBOutlet UIView             *view4;
    
    IBOutlet UITextView         *eventDescription;
    
    IBOutlet MKMapView          *eventMap;
    
    IBOutlet UIBarButtonItem    *eventUserInputAddBtn;
    
    BOOL isOfficial;
    double latitude;
    double longitude;
    
    int                         eventID;
}

@property (nonatomic, retain) IBOutlet UIImageView        *eventImage;
@property (nonatomic, retain) IBOutlet UIImageView        *eventButtonImage;
@property (nonatomic, retain) IBOutlet UIImageView        *eventWebImage;

@property (nonatomic, retain) IBOutlet UILabel            *eventName;
@property (nonatomic, retain) IBOutlet UILabel            *eventDatetime;
@property (nonatomic, retain) IBOutlet UILabel            *eventLocationName;
@property (nonatomic, retain) IBOutlet UILabel            *eventButton;
@property (nonatomic, retain) IBOutlet UILabel            *eventAttendLabel;
@property (nonatomic, retain) IBOutlet UILabel            *eventFavoriteLabel;

@property (nonatomic, retain) IBOutlet UIButton           *eventGoingBtn;
@property (nonatomic, retain) IBOutlet UIButton           *eventUserInputBtn;
@property (nonatomic, retain) IBOutlet UIButton           *eventLikeBtn;
@property (nonatomic, retain) IBOutlet UIButton           *eventRemoveBtn;
@property (nonatomic, retain) IBOutlet UIButton           *eventEditBtn;

@property (nonatomic, retain) IBOutlet UIView             *eventView1;
@property (nonatomic, retain) IBOutlet UIView             *view1;
@property (nonatomic, retain) IBOutlet UIView             *view2;
@property (nonatomic, retain) IBOutlet UIView             *view3;
@property (nonatomic, retain) IBOutlet UIView             *view4;


@property (nonatomic, retain) IBOutlet UIButton           *eventWebPageBtn;
@property (nonatomic, retain) IBOutlet UIButton           *eventGoingAddBtn;

@property (nonatomic, retain) IBOutlet UITextView         *eventDescription;
@property (nonatomic, retain) IBOutlet MKMapView          *eventMap;

@property (nonatomic, retain) IBOutlet UIBarButtonItem    *eventUserInputAddBtn;

@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) BOOL isOfficial;

@property (nonatomic, assign) int                         eventID;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *startLocation;

- (IBAction)eventGoingBtnPressed:(id)sender;
- (IBAction)eventUserInputBtnPressed:(id)sender;
- (IBAction)eventGoingAddBtnPressed:(id)sender;
- (IBAction)eventLikeBtnPressed:(id)sender;
//- (IBAction)eventUserInputAddBtnPressed:(id)sender;

- (IBAction)eventRemoveBtnPressed:(id)sender;

@end
