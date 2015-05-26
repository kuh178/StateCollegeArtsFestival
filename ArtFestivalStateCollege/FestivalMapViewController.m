//
//  FestivalMapViewController.m
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 4/6/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import "FestivalMapViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AFHTTPRequestOperationManager.h"
#import "MapViewAnnotation.h"

@interface FestivalMapViewController ()

@end

@implementation FestivalMapViewController
@synthesize mapView, locationList, annotations;

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    mapView.layer.borderColor = [[UIColor blackColor] CGColor];
    mapView.layer.cornerRadius = 5;
    mapView.layer.borderWidth = 1;
    
    // download location first
    [self downloadContent];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"FestivalMapViewController";
    self.navigationItem.backBarButtonItem.title = @"Back";
    self.hidesBottomBarWhenPushed = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupMapView {
    
    // set annotation.
    mapView.showsUserLocation = YES;
    mapView.mapType = MKMapTypeStandard;
    mapView.delegate = self;
    CLLocationCoordinate2D location;
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 1;
    span.longitudeDelta = 1;
    
    region.span = span;
    region.center = location;
    
    [mapView setRegion:region animated:FALSE];
    [mapView regionThatFits:region];
    
    // initialize locationManager
    locationManager = [[CLLocationManager alloc] init];
    
    // assign this page as a delegate
    locationManager.delegate = self;
    
    if(IS_OS_8_OR_LATER) {
        
        NSLog(@"this is iOS 8");
        // Use one or the other, not both. Depending on what you put in info.plist
        [locationManager requestWhenInUseAuthorization];
        [locationManager requestAlwaysAuthorization];
    }
    
    // ask LocationManager to give accurate location info as much as possible.
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    
    // disable the 'Sleep mode'
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    // start tracking the path, call didUpdateToLocation callback
    [locationManager startUpdatingLocation];
    
    mapView.showsUserLocation = YES;
    mapView.showsPointsOfInterest = YES;
    
    MKUserLocation *userLocation = mapView.userLocation;
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
    
    [mapView setCenterCoordinate:coordinate animated:YES];
    
    annotations = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i < [locationList count]; i++) {
        
        NSMutableDictionary *locItem = [locationList objectAtIndex:i];
        
        MapViewAnnotation *annotation = [[MapViewAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake([[locItem objectForKey:@"latitude"] doubleValue],[[locItem objectForKey:@"longitude"] doubleValue]) andMarkTitle:[locItem objectForKey:@"name"] andMarkSubTitle:@""];
        
        [mapView addAnnotation:annotation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    // do something below here, if we need user location data.
    NSLog(@"%f, %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 1500, 1500);
    //MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    [mapView setRegion:viewRegion animated:YES];
    
    [locationManager stopUpdatingLocation];
}

- (void) downloadContent {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://heounsuk.com/festival/download_map_locations.php" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        if ([[responseObject objectForKey:@"success"]boolValue] == TRUE) {
            locationList = [NSMutableArray arrayWithCapacity:0];
            [locationList addObjectsFromArray:[responseObject objectForKey:@"results"]];

            [self setupMapView];
        }
        else {
            UIAlertView *dialog = [[UIAlertView alloc]init];
            [dialog setDelegate:self];
            [dialog setTitle:@"Message"];
            [dialog setMessage:@"No locations found"];
            [dialog addButtonWithTitle:@"OK"];
            [dialog show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


@end
