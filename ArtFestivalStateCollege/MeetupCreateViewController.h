//
//  MeetupCreateViewController.h
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 5/4/15.
//  Copyright (c) 2015 Kyungsik Han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GAITrackedViewController.h"
#import <MapKit/MKAnnotation.h>
#import "LocationAnnotation.h"

@interface MeetupCreateViewController : GAITrackedViewController <MKMapViewDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    IBOutlet UITextField        *meetupWhatText;
    IBOutlet UIDatePicker       *meetupWhenPicker;
    IBOutlet MKMapView          *mapView;
    IBOutlet UIBarButtonItem    *submitBtn;
    IBOutlet UIImageView        *addPhotoImage;
    IBOutlet UIButton           *myLocationBtn;
    
    LocationAnnotation *annotation;
    CLLocationManager *locationManager;
    
    double selectedLocLatitude;
    double selectedLocLongitude;

    NSString *meetupDatetime;
    NSString *meetupDescription;
    NSString *meetupPhoto;
    
    int meetupID;
    int type; // type 0: new meetup / type 1: edit meetup
}

@property (nonatomic, retain) IBOutlet UITextField          *meetupWhatText;
@property (nonatomic, retain) IBOutlet UIDatePicker         *meetupWhenPicker;
@property (nonatomic, retain) IBOutlet MKMapView            *mapView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem      *submitBtn;
@property (nonatomic, retain) IBOutlet UIImageView          *addPhotoImage;
@property (nonatomic, retain) IBOutlet UIButton             *myLocationBtn;

@property (nonatomic, assign) double selectedLocLatitude;
@property (nonatomic, assign) double selectedLocLongitude;

@property (nonatomic, retain) NSString *meetupDatetime;
@property (nonatomic, retain) NSString *meetupDescription;
@property (nonatomic, retain) NSString *meetupPhoto;

@property (nonatomic, assign) int meetupID;
@property (nonatomic, assign) int type;


-(IBAction)submitBtnPressed:(id)sender;
-(IBAction)myLocationBtnPressed:(id)sender;


@end
