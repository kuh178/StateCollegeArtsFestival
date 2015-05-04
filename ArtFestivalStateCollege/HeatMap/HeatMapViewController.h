//
//  HeatMapViewController.h
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 6/18/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "HeatMap.h"
#import "HeatMapView.h"
#import "GAITrackedViewController.h"

@interface HeatMapViewController : GAITrackedViewController <MKMapViewDelegate> {
    NSMutableArray              *photoList;
    NSMutableArray              *updatedPhotoList;
    NSMutableArray              *jsonArray;
    NSMutableArray              *annotations;
   
    IBOutlet MKMapView          *mapView;
    IBOutlet UISegmentedControl *segmentControl;
}

@property (nonatomic, retain) NSMutableArray                *photoList;
@property (nonatomic, retain) NSMutableArray                *updatedPhotoList;
@property (nonatomic, retain) NSMutableArray                *jsonArray;
@property (nonatomic, retain) IBOutlet MKMapView            *mapView;

@property (nonatomic, retain) IBOutlet UISegmentedControl   *segmentControl;

-(IBAction)segmentPressed:(id)sender;


@end
