//
//  MeetupCreateViewController.m
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 5/4/15.
//  Copyright (c) 2015 Kyungsik Han. All rights reserved.
//

#import "MeetupCreateViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface MeetupCreateViewController ()

@end

@implementation MeetupCreateViewController

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@synthesize meetupWhatText, meetupWhenPicker, mapView, submitBtn, addPhotoImage;
@synthesize selectedLocLatitude, selectedLocLongitude;
@synthesize meetupDatetime, meetupDescription, meetupPhoto;
@synthesize type, meetupID;
@synthesize myLocationBtn;

NSData      *imageData;
UIImage     *chosenImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // set-up
    meetupWhenPicker.layer.borderColor = [[UIColor blackColor] CGColor];
    meetupWhenPicker.layer.cornerRadius = 5;
    meetupWhenPicker.layer.borderWidth = 1;
    meetupWhenPicker.timeZone = [NSTimeZone localTimeZone];
    
    mapView.layer.borderColor = [[UIColor blackColor] CGColor];
    mapView.layer.cornerRadius = 5;
    mapView.layer.borderWidth = 1;
    
    // set-up map
    [self setupMapView];
    
    if (type == 0) { // type == 0 (new)
        
    }
    else { // type == 1 (edit)
        
        NSLog(@"passed data: %f %f %@ %@ %@", selectedLocLatitude, selectedLocLongitude, meetupDescription, meetupPhoto, meetupDatetime);
        
        // show a push pin
        CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(selectedLocLatitude, selectedLocLongitude);
        annotation = [[LocationAnnotation alloc]initWithCoordinate:loc];
        [mapView removeAnnotations:[mapView annotations]];
        [mapView addAnnotation:annotation];
        
        // description
        [meetupWhatText setText:meetupDescription];
        
        // image
        [addPhotoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", meetupPhoto]]];
        imageData = UIImageJPEGRepresentation(addPhotoImage.image, 0.8);
        
        // datetime
        NSTimeInterval _interval=[meetupDatetime doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
        
        NSTimeInterval timeZoneOffset = [[NSTimeZone defaultTimeZone] secondsFromGMT]; // You could also use the systemTimeZone method
        NSTimeInterval gmtTimeInterval = [date timeIntervalSinceReferenceDate] - timeZoneOffset;
        NSDate *gmtDate = [NSDate dateWithTimeIntervalSinceReferenceDate:gmtTimeInterval];
        [meetupWhenPicker setDate:gmtDate];
    }
    
    // tap-gesture recognizer
    [self tapGestureRecognizer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationItem.backBarButtonItem.title = @"Back";
    //self.hidesBottomBarWhenPushed = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)submitBtnPressed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Post this meet-up?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (void) tapGestureRecognizer {
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDetected)];
    singleTap.numberOfTapsRequired = 1;
    [addPhotoImage setUserInteractionEnabled:YES];
    [addPhotoImage addGestureRecognizer:singleTap];
}

- (void) tapDetected {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Pick one" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Camera",@"Gallery", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Gallery"]){ // Gallery
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
    else if ([title isEqualToString:@"Camera"]){ // Camera
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
    else if ([title isEqualToString:@"Yes"]){ // Going
        [self uploadMeetup];
    }
    else {
        
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    chosenImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    addPhotoImage.image = chosenImage;
    
    // update imageData value
    imageData = UIImageJPEGRepresentation(chosenImage, 0.8);
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void) uploadMeetup {
    
    // get what text
    NSString *meetUpWhat = meetupWhatText.text;
    // get date time
    NSLocale *usLocale = [[NSLocale alloc]
                          initWithLocaleIdentifier:@"en_US"];
    
    NSDate *pickerDate = [meetupWhenPicker date] ;
    NSLog(@"pickerDate %@", pickerDate);
    
    NSString *selectionString = [[NSString alloc]
                                 initWithFormat:@"%@",
                                 [pickerDate descriptionWithLocale:usLocale]];
    // Sunday, March 22, 2015 at 4:39:12 PM Eastern Daylight Time
    
    if(![meetUpWhat isEqual:[NSNull null]] ||
       selectedLocLatitude == 0.0 ||
       selectedLocLongitude == 0.0 ||
       [selectionString isEqual:[NSNull null]]) {
        
        if (imageData) {
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            
            NSString *timeStampValue = [NSString stringWithFormat:@"%ld",(long)[pickerDate timeIntervalSince1970]];
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSDictionary *params = @{@"user_id"     :[userDefault objectForKey:@"user_id"],
                                     @"datetime"    :[NSString stringWithFormat:@"%@", timeStampValue],
                                     @"description" :[NSString stringWithFormat:@"%@", meetUpWhat],
                                     @"latitude"    :[NSString stringWithFormat:@"%f", selectedLocLatitude],
                                     @"longitude"   :[NSString stringWithFormat:@"%f", selectedLocLongitude],
                                     @"type"        :[NSString stringWithFormat:@"%d", type], // type = 0 : new / type = 1 : edit
                                     @"id"          :[NSString stringWithFormat:@"%d", meetupID]};
            
            NSLog(@"size of file is %ld", (unsigned long)[imageData length]);
            
            [manager POST:@"http://heounsuk.com/festival/upload_meetup.php" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                [formData appendPartWithFileData:imageData name:@"image" fileName:@"temp_image.png" mimeType:@"image/jpeg"];
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"Success: %@", responseObject);
                // go to the previous page
                [self.navigationController popViewControllerAnimated:YES];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"operation : %@", operation.responseString);
                NSLog(@"Error: %@", error);
                
                UIAlertView *dialog = [[UIAlertView alloc]init];
                [dialog setDelegate:self];
                [dialog setTitle:@"Message"];
                [dialog setMessage:operation.responseString];
                [dialog addButtonWithTitle:@"OK"];
                [dialog show];
            }];
        }
        else {
            UIAlertView *dialog = [[UIAlertView alloc]init];
            [dialog setDelegate:nil];
            [dialog setTitle:@"Message"];
            [dialog setMessage:@"Please add an image of your event"];
            [dialog addButtonWithTitle:@"OK"];
            [dialog show];
        }
    }
    else {
        UIAlertView *dialog = [[UIAlertView alloc]init];
        [dialog setDelegate:nil];
        [dialog setTitle:@"Message"];
        [dialog setMessage:@"Check all fields"];
        [dialog addButtonWithTitle:@"OK"];
        [dialog show];
    }
}

- (void)setupMapView {
    
    // set annotation.
    annotation = [[LocationAnnotation alloc]init];
    
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
    
    // add the recognizer to the map
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.1; //user needs to press for 0.5 seconds
    [self.mapView addGestureRecognizer:lpgr];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    // do something below here, if we need user location data.
    NSLog(@"%f, %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 1500, 1500);
    //MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    [mapView setRegion:viewRegion animated:YES];
    
    [locationManager stopUpdatingLocation];
}

-(void)handleLongPress:(UITapGestureRecognizer *)tap{

    if (tap.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    // remove existing annotation first.
    [mapView removeAnnotation:annotation];
    
    // re-calculate annotation.
    CGPoint touchPoint = [tap locationInView:mapView];
    CLLocationCoordinate2D touchMapCoordinate = [mapView convertPoint:touchPoint toCoordinateFromView:mapView];
    
    selectedLocLatitude = touchMapCoordinate.latitude;
    selectedLocLongitude = touchMapCoordinate.longitude;
    
    annotation = [[LocationAnnotation alloc]initWithCoordinate:touchMapCoordinate];
    [mapView addAnnotation:annotation];
}

- (void)pinchGestureAction:(UIPinchGestureRecognizer *)pinch {
    float prevPinchScale = 1.0;
    float thisScale = 1 + (pinch.scale-prevPinchScale);
    prevPinchScale = pinch.scale;
    self.view.transform = CGAffineTransformScale(self.view.transform, thisScale, thisScale);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == meetupWhatText) {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

-(IBAction)myLocationBtnPressed:(id)sender {
    [mapView setCenterCoordinate:mapView.userLocation.location.coordinate animated:YES];
}



@end
