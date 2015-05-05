//
//  ArtistsDetailViewController.h
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 3/20/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GAITrackedViewController.h"

@interface ArtistsDetailViewController : GAITrackedViewController {

    IBOutlet UIImageView        *artistImage;
    IBOutlet UILabel            *artistName;
    IBOutlet UILabel            *artistBooth;
    IBOutlet UILabel            *artistCategory;
    IBOutlet UILabel            *artistDescription;
    
    IBOutlet UIButton           *artistMoreImageBtn;
    IBOutlet UIButton           *artistEmailBtn;

    IBOutlet MKMapView          *artistMap;

    NSMutableDictionary         *item;
}

@property (nonatomic, retain) IBOutlet UIImageView        *artistImage;
@property (nonatomic, retain) IBOutlet UILabel            *artistName;
@property (nonatomic, retain) IBOutlet UILabel            *artistBooth;
@property (nonatomic, retain) IBOutlet UILabel            *artistCategory;
@property (nonatomic, retain) IBOutlet UILabel            *artistDescription;
@property (nonatomic, retain) IBOutlet MKMapView          *artistMap;

@property (nonatomic, retain) IBOutlet UIButton           *artistMoreImageBtn;
@property (nonatomic, retain) IBOutlet UIButton           *artistEmailBtn;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *startLocation;


@property (nonatomic, retain) NSMutableDictionary         *item;

- (IBAction)artistEmailBtnPressed:(id)sender;

@end
