//
//  EventDetailViewController.m
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 3/4/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import "EventDetailViewController.h"
#import "GoingDetailViewController.h"
#import "UserInputDetailViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "AFHTTPRequestOperationManager.h"
#import "AddUserInputViewController.h"
#import "ArtistsWebPageViewController.h"
#import "QuartzCore/QuartzCore.h"


@interface EventDetailViewController ()
@property (nonatomic, assign) BOOL statusBarHidden;
@end

@implementation EventDetailViewController

@synthesize eventImage, eventButtonImage, eventName, eventDatetime, eventGoingBtn, eventButton, eventWebPageBtn, eventUserInputAddBtn, eventGoingAddBtn, eventUserInputBtn, eventLocationName, eventDescription, eventMap, item, latitude, longitude;

int photo_cnt = 0;

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
    
    // set up location manager
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    _startLocation = nil;
    
    // display information
    eventName.text          = [item objectForKey:@"name"];
    eventDescription.text   = [item objectForKey:@"description"];
    
    // event datetime
    // ref: http://stackoverflow.com/questions/1862905/nsdate-convert-date-to-gmt
    NSTimeInterval _interval=[[item objectForKey:@"datetime"] doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    
    NSTimeInterval timeZoneOffset = [[NSTimeZone defaultTimeZone] secondsFromGMT]; // You could also use the systemTimeZone method
    NSTimeInterval gmtTimeInterval = [date timeIntervalSinceReferenceDate] - timeZoneOffset;
    NSDate *gmtDate = [NSDate dateWithTimeIntervalSinceReferenceDate:gmtTimeInterval];
    
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setLocale:[NSLocale currentLocale]];
    [_formatter setDateFormat:@"MMM dd, hh:mm a"];
    NSString *_date=[_formatter stringFromDate:gmtDate];
    eventDatetime.text = _date;
    
    //[eventGoingBtn setTitle:[NSString stringWithFormat:@"Going (%d)", [[item objectForKey:@"going_user_ary"] count]] forState:UIControlStateNormal];
    //[eventUserInputBtn setTitle:[NSString stringWithFormat:@"Photos (%d)", [[item objectForKey:@"user_content_cnt"] intValue]] forState:UIControlStateNormal];
    
    //self.mediaFocusManager = [[ASMediaFocusManager alloc] init];
    //self.mediaFocusManager.delegate = self;
    // Tells which views need to be focusable. You can put your image views in an array and give it to the focus manager.
    //[self.mediaFocusManager installOnViews:self.imageViews];
    //[self.mediaFocusManager installOnView:eventImage];
    
    [eventImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [item objectForKey:@"image_url"]]]];
    eventImage.layer.cornerRadius = 4.0f;
    eventImage.clipsToBounds = YES;
    
    // add a push pin on the map
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake([[item objectForKey:@"latitude"] doubleValue], [[item objectForKey:@"longitude"] doubleValue]);
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:loc];
    //[annotation setTitle:@"Title"]; //You can set the subtitle too
    [eventMap addAnnotation:annotation];
    
    MKCoordinateRegion adjustedRegion = [eventMap regionThatFits:MKCoordinateRegionMakeWithDistance(loc, 800, 800)];
    adjustedRegion.span.longitudeDelta  = 0.01;
    adjustedRegion.span.latitudeDelta  = 0.01;
    [eventMap setRegion:adjustedRegion animated:YES];
    
    if ([[item objectForKey:@"button"] intValue] == 1) {
        eventButton.text = @"Button required";
        eventButtonImage.hidden = NO;
    }
    else {
        eventButton.text = @"No button required";
        eventButtonImage.hidden = YES;
    }
    
    eventLocationName.text = [item objectForKey:@"location_name"];
    
    // hide website btn if nothing exists
    if ([[item objectForKey:@"website"] isEqualToString:@"none"]) {
        eventWebPageBtn.hidden = YES;
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSString *currentLatitude = [[NSString alloc]
                                 initWithFormat:@"%+.6f",
                                 newLocation.coordinate.latitude];
    latitude = [currentLatitude doubleValue];
    
    NSString *currentLongitude = [[NSString alloc]
                                  initWithFormat:@"%+.6f",
                                  newLocation.coordinate.longitude];
    longitude = [currentLongitude doubleValue];
    
    if (latitude != 0.0 && longitude != 0.0) {
        [_locationManager stopUpdatingLocation];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"EventDetailViewController";
    self.navigationItem.backBarButtonItem.title = @"Back";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // load event updates everytime the view is opened
    [self downloadEventUpdates];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) downloadEventUpdates {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"event_id"    :[NSString stringWithFormat:@"%d", [[item objectForKey:@"id"] intValue]]};
    
    [manager POST:@"http://community.ist.psu.edu/Festival/download_event_details.php" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        
        if([[responseObject objectForKey:@"success"] boolValue] == TRUE) {
            NSMutableArray *eventInfoItem = [NSMutableArray arrayWithCapacity:0];
            [eventInfoItem addObjectsFromArray:[responseObject objectForKey:@"results"]];
            
            NSMutableDictionary *eventItem = [eventInfoItem objectAtIndex:0];
            
            // update the going and userinput btn texts
            [eventGoingBtn setTitle:[NSString stringWithFormat:@"Attending (%lu)", (unsigned long)[[eventItem objectForKey:@"going_user_ary"] count]] forState:UIControlStateNormal];
            [eventUserInputBtn setTitle:[NSString stringWithFormat:@"Photos (%d)", [[eventItem objectForKey:@"user_content_cnt"] intValue]] forState:UIControlStateNormal];
            
            photo_cnt = [[eventItem objectForKey:@"user_content_cnt"] intValue];
        }
        else {
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void) uploadMyGoing {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString *timeStampValue = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user_id"     :[userDefault objectForKey:@"user_id"],
                             @"event_id"    :[item objectForKey:@"id"],
                             @"datetime"    :[NSString stringWithFormat:@"%@", timeStampValue],
                             @"latitude"    :[NSString stringWithFormat:@"%f", latitude],
                             @"longitude"   :[NSString stringWithFormat:@"%f", longitude]};
    
    [manager POST:@"http://community.ist.psu.edu/Festival/upload_my_going.php" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        
        if([[responseObject objectForKey:@"success"] boolValue] == TRUE) {
            //UIAlertView *dialog = [[UIAlertView alloc]init];
            //[dialog setDelegate:self];
            //[dialog setTitle:@"Message"];
            //[dialog setMessage:@"Succesfully added"];
            //[dialog addButtonWithTitle:@"OK"];
            //[dialog show];
            
            [self downloadEventUpdates];
        }
        else {
            UIAlertView *dialog = [[UIAlertView alloc]init];
            [dialog setDelegate:self];
            [dialog setTitle:@"Message"];
            [dialog setMessage:[responseObject objectForKey:@"message"]];
            [dialog addButtonWithTitle:@"OK"];
            [dialog show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Going"]){ // Going
        [self uploadMyGoing];
    }
    else {
        
    }
}


- (IBAction)eventGoingBtnPressed:(id)sender {
    
    //GoingDetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GoingDetailViewController"];
    //viewController.hidesBottomBarWhenPushed = YES;
    //[viewController setUserList:[item objectForKey:@"going_user_ary"]];
    //[viewController setEventID:[[item objectForKey:@"id"] intValue]];
    //[self.navigationController pushViewController:viewController animated:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Attending this event?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Going", nil];
    [alert show];
}

- (IBAction)eventUserInputBtnPressed:(id)sender {
    
    //UserInputDetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserInputDetailViewController"];
    //viewController.hidesBottomBarWhenPushed = YES;
    //[viewController setEventID:[[item objectForKey:@"id"] intValue]];
    //[self.navigationController pushViewController:viewController animated:YES];
    //[self performSegueWithIdentifier:@"UserInputDetailViewController" sender:[item objectForKey:@"id"]];
}

- (IBAction)eventGoingAddBtnPressed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Attending this event?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Going", nil];
    [alert show];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString: @"UserInputDetailViewController"]) {
        
        if (photo_cnt == 0) {
            UIAlertView *dialog = [[UIAlertView alloc]init];
            [dialog setDelegate:nil];
            [dialog setTitle:@"Message"];
            [dialog setMessage:@"No photos available"];
            [dialog addButtonWithTitle:@"OK"];
            [dialog show];
            
            return NO;
        }
        else {
            return YES;
        }
    }
    else {
        return YES;
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString: @"UserInputDetailViewController"]) {
        UserInputDetailViewController *viewController = (UserInputDetailViewController *)[segue destinationViewController];
        viewController.eventID = [[item objectForKey:@"id"] intValue];
    }
    else if ([[segue identifier] isEqualToString: @"AddUserInputViewController"]) {
        AddUserInputViewController *viewController = (AddUserInputViewController *)[segue destinationViewController];
        viewController.eventID = [[item objectForKey:@"id"] intValue];
    }
    else if ([[segue identifier] isEqualToString: @"ArtistsWebPageViewController"]) {
        ArtistsWebPageViewController *viewController = (ArtistsWebPageViewController *)[segue destinationViewController];
        viewController.hidesBottomBarWhenPushed = YES;
        [viewController setWebLink:[item objectForKey:@"website"]];
    }
}

@end
