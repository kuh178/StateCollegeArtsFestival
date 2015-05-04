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
    IBOutlet UILabel            *eventName;
    IBOutlet UILabel            *eventDatetime;
    IBOutlet UILabel            *eventButton;
    IBOutlet UILabel            *eventLocationName;
    IBOutlet UIButton           *eventGoingBtn;
    IBOutlet UIButton           *eventUserInputBtn;
    IBOutlet UIButton           *eventWebPageBtn;
    IBOutlet UIButton           *eventGoingAddBtn;
    
    IBOutlet UITextView         *eventDescription;
    
    IBOutlet MKMapView          *eventMap;
    
    IBOutlet UIBarButtonItem    *eventUserInputAddBtn;
    
    NSMutableDictionary         *item;
    
    double latitude;
    double longitude;
}

@property (nonatomic, retain) IBOutlet UIImageView        *eventImage;
@property (nonatomic, retain) IBOutlet UIImageView        *eventButtonImage;
@property (nonatomic, retain) IBOutlet UILabel            *eventName;
@property (nonatomic, retain) IBOutlet UILabel            *eventDatetime;
@property (nonatomic, retain) IBOutlet UILabel            *eventLocationName;
@property (nonatomic, retain) IBOutlet UIButton           *eventGoingBtn;
@property (nonatomic, retain) IBOutlet UIButton           *eventUserInputBtn;
@property (nonatomic, retain) IBOutlet UILabel            *eventButton;

@property (nonatomic, retain) IBOutlet UIButton           *eventWebPageBtn;
@property (nonatomic, retain) IBOutlet UIButton           *eventGoingAddBtn;

@property (nonatomic, retain) IBOutlet UITextView         *eventDescription;
@property (nonatomic, retain) IBOutlet MKMapView          *eventMap;

@property (nonatomic, retain) IBOutlet UIBarButtonItem    *eventUserInputAddBtn;

@property (nonatomic, retain) NSMutableDictionary         *item;

@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *startLocation;

- (IBAction)eventGoingBtnPressed:(id)sender;
- (IBAction)eventUserInputBtnPressed:(id)sender;

- (IBAction)eventGoingAddBtnPressed:(id)sender;
//- (IBAction)eventUserInputAddBtnPressed:(id)sender;

@end
