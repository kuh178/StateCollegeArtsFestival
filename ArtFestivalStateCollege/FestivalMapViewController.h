//
//  FestivalMapViewController.h
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 4/6/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GAITrackedViewController.h"
#import <MapKit/MKAnnotation.h>
#import "LocationAnnotation.h"


@interface FestivalMapViewController : GAITrackedViewController <MKMapViewDelegate, CLLocationManagerDelegate>{
    IBOutlet MKMapView          *mapView;
    
    CLLocationManager           *locationManager;
    
    NSMutableArray              *locationList;
    NSMutableArray              *annotations;
}

@property (nonatomic, retain) IBOutlet MKMapView    *mapView;
@property (nonatomic, retain) NSMutableArray        *locationList;
@property (nonatomic, retain) NSMutableArray        *annotations;


@end
