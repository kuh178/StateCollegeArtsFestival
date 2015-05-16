//
//  HeatMapViewController.m
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 6/18/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import "HeatMapViewController.h"
#import "JSON.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AFHTTPRequestOperationManager.h"
#import "MapPhotosViewController.h"
#import "UserInputDetailedViewController.h"
#import "CCHMapClusterAnnotation.h"
#import "CCHMapClusterController.h"
#import "CCHMapClusterControllerDelegate.h"
#import "CCHCenterOfMassMapClusterer.h"
#import "CCHNearCenterMapClusterer.h"
#import "CCHFadeInOutMapAnimator.h"
#import "MapViewAnnotation.h"

#define DELAY_BETWEEN_BATCHES 0.3

#define YEAR_2014 1
#define YEAR_2013_2010 2
#define YEAR_2009 3

@interface HeatMapViewController () <CCHMapClusterControllerDelegate>

@property (strong, nonatomic) CCHMapClusterController *mapClusterController;
@property (nonatomic, retain) NSMutableArray *annotations;
@property (nonatomic) id<CCHMapClusterer> mapClusterer;
@property (nonatomic) id<CCHMapAnimator> mapAnimator;
@property (nonatomic) NSOperationQueue *operationQueue;

@end

@implementation HeatMapViewController

@synthesize mapView, photoList, updatedPhotoList, jsonArray, segmentControl, annotations;

int flag_type = YEAR_2014;

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
    
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    
    flag_type = YEAR_2014;

    [self downloadContent];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"HeatMapViewController";
    self.navigationItem.backBarButtonItem.title = @"Back";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) downloadContent {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://heounsuk.com/festival/download_all_years_photos.php" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        if ([[responseObject objectForKey:@"success"]boolValue] == TRUE) {
            photoList = [NSMutableArray arrayWithCapacity:0];
            jsonArray = [NSMutableArray arrayWithCapacity:0];
            [jsonArray addObjectsFromArray:[responseObject objectForKey:@"results"]];
  
            if ([jsonArray count] > 0) {
                // insert new items into table
                for (int i = 0; i < [jsonArray count]; i++) {
                    
                    // get an item
                    NSDictionary *item = [jsonArray objectAtIndex:i];
                    [photoList addObject:item];
                }
            }
            else {
                NSLog(@"No data available");
            }
            
            [self updateMapView:flag_type];
        }
        else {
            UIAlertView *dialog = [[UIAlertView alloc]init];
            [dialog setDelegate:self];
            [dialog setTitle:@"Message"];
            [dialog setMessage:@"No results found"];
            [dialog addButtonWithTitle:@"OK"];
            [dialog show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    return [[HeatMapView alloc] initWithOverlay:overlay];
}
 
- (IBAction)segmentPressed:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    if (selectedSegment == 0) { // YEAR_2014
        flag_type = YEAR_2014;
        [self updateMapView:flag_type];
    }
    else if (selectedSegment == 1){ // YEAR_2010_2013
        flag_type = YEAR_2013_2010;
        [self updateMapView:flag_type];
    }
    else { // YEAR_2009
        flag_type = YEAR_2009;
        [self updateMapView:flag_type];
    }
}

- (void) updateMapView:(int)type {
    // remove all overlays and annotations
    NSMutableArray *annotationsToRemove = [mapView.annotations mutableCopy];
    //[annotationsToRemove removeObject:mapView.userLocation];
    NSMutableArray *overLaysToRemove = [mapView.overlays mutableCopy];
    [mapView removeAnnotations:annotationsToRemove];
    [mapView removeOverlays:overLaysToRemove];
    
    NSMutableDictionary *locDic = [[NSMutableDictionary alloc] init];
    annotations = [NSMutableArray arrayWithCapacity:0];
    updatedPhotoList = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0 ; i < [photoList count] ; i++) {
        NSMutableDictionary *item = [photoList objectAtIndex:i];

        if (type == [[item objectForKey:@"year"] intValue]) {
            
            [updatedPhotoList addObject:item];
            
            MKMapPoint point = MKMapPointForCoordinate(CLLocationCoordinate2DMake([[item objectForKey:@"latitude"] doubleValue],
                                                                                  [[item objectForKey:@"longitude"] doubleValue]));
            NSValue *pointValue = [NSValue value:&point withObjCType:@encode(MKMapPoint)];
            [locDic setObject:[NSNumber numberWithInteger:1] forKey:pointValue];
            
            
            MapViewAnnotation *annotation = [[MapViewAnnotation alloc]initWithCoordinate:CLLocationCoordinate2DMake([[item objectForKey:@"latitude"] doubleValue],
                                                                                                                    [[item objectForKey:@"longitude"] doubleValue]) andMarkTitle:[item objectForKey:@"comment"] andMarkSubTitle:[item objectForKey:@"post_id"]];
            
            // datetime
            /*
            NSTimeInterval _interval=[[item objectForKey:@"datetime"] doubleValue];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
            NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
            [_formatter setLocale:[NSLocale currentLocale]];
            [_formatter setDateFormat:@"YYYY, MMM dd"];
            NSString *_date=[_formatter stringFromDate:date];
            */
            //annotation.subtitle = _date;
            
            // add annotation to array
            [annotations addObject:annotation];
        }
    }
    
    HeatMap *hm = [[HeatMap alloc] initWithData:locDic];
    [mapView addOverlay:hm];
    [mapView setVisibleMapRect:[hm boundingMapRect] animated:YES];
    [mapView addAnnotations:annotations];

    //MKCoordinateRegion region;
    //CLLocationCoordinate2D location = CLLocationCoordinate2DMake(40.793395, -77.860001);
    //region = MKCoordinateRegionMakeWithDistance(location, 5000, 5000);
    //self.mapView.region = region;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView_ viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *identifier = @"MapViewAnnotation";
    
    if ([annotation isKindOfClass:[MapViewAnnotation class]]) {
        
        MKPinAnnotationView *annotationView =
        (MKPinAnnotationView *)[mapView_ dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc]
                              initWithAnnotation:annotation
                              reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        
        // Create a UIButton object to add on the
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton setTitle:annotation.title forState:UIControlStateNormal];
        [annotationView setRightCalloutAccessoryView:rightButton];
        
        //UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
        //[leftButton setTitle:annotation.title forState:UIControlStateNormal];
        //[annotationView setLeftCalloutAccessoryView:leftButton];
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSMutableDictionary *passingItem = [[NSMutableDictionary alloc]init];
    
    for (int i = 0; i < [photoList count]; i++) {
        NSMutableDictionary *item = [photoList objectAtIndex:i];
        if ([item objectForKey:@"post_id"] == view.annotation.subtitle) {
            passingItem = item;
            break;
        }
    }
    
    UserInputDetailedViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserInputDetailedViewController"];
    viewController.hidesBottomBarWhenPushed = YES;
    [viewController setItem:passingItem];
    [self.navigationController pushViewController:viewController animated:YES];
}

/*
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSMutableDictionary *passingItem = [[NSMutableDictionary alloc]init];
    
    for (int i = 0; i < [photoList count]; i++) {
        NSMutableDictionary *item = [photoList objectAtIndex:i];
        if ([item objectForKey:@"post_id"] == view.annotation.subtitle) {
            passingItem = item;
            break;
        }
    }
    
    UserInputDetailedViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserInputDetailedViewController"];
    viewController.hidesBottomBarWhenPushed = YES;
    [viewController setItem:passingItem];
    [self.navigationController pushViewController:viewController animated:YES];
}
*/

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString: @"MapPhotosViewController"]) {
        MapPhotosViewController *viewController = (MapPhotosViewController *)[segue destinationViewController];
        viewController.photoList = updatedPhotoList;
    }
}


@end
