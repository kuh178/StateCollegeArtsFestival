//
//  EventDetailViewController.m
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 3/4/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import "EventDetailViewController.h"
#import "UserListViewController.h"
#import "UserInputDetailViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "AFHTTPRequestOperationManager.h"
#import "AddUserInputViewController.h"
#import "ArtistsWebPageViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "ProfileViewController.h"
#import "MeetupCreateViewController.h"

#define ADD_ATTEND 0;
#define REMOVE_ATTEND 1;
#define ADD_FAVORITE 0;
#define REMOVE_FAVORITE 1;

#define SEE_ATTEND 0;
#define SEE_FAVORITE 1;

@interface EventDetailViewController ()
@property (nonatomic, assign) BOOL statusBarHidden;
@end

@implementation EventDetailViewController

@synthesize eventImage, eventButtonImage, eventName, eventDatetime, eventGoingBtn, eventButton, eventWebPageBtn, moreBtn, eventGoingAddBtn, eventUserInputBtn, eventLikeBtn, eventLocationName, eventDescription, eventMap, latitude, longitude, isOfficial, eventView1, eventWebImage, eventRemoveBtn, eventEditBtn, eventAttendLabel, eventFavoriteLabel;
@synthesize view1, view2, view3, view4;
@synthesize eventID;
@synthesize eventAttendImage, eventFavoriteImage;
@synthesize userID, userImage, userName;
@synthesize myLocationBtn;

int photo_cnt = 0;
int attend_flag = ADD_ATTEND;
int favorite_flag = ADD_FAVORITE;
int type;
NSMutableDictionary *item;
UIActivityIndicatorView *indicator;
NSUserDefaults *userDefault;

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
    
    // button rounded corner
    eventImage.layer.borderColor = [[UIColor blackColor] CGColor];
    eventImage.layer.borderWidth = 1.0;
    eventImage.layer.cornerRadius = 5;
    
    eventEditBtn.layer.borderColor = [[UIColor blackColor] CGColor];
    eventEditBtn.layer.borderWidth = 1.0;
    eventEditBtn.layer.cornerRadius = 5;
    
    eventRemoveBtn.layer.borderColor = [[UIColor blackColor] CGColor];
    eventRemoveBtn.layer.borderWidth = 1.0;
    eventRemoveBtn.layer.cornerRadius = 5;

    eventMap.layer.cornerRadius = 5;
    
    eventDescription.layer.cornerRadius = 5;
    
    eventView1.layer.cornerRadius = 5;
    
    view1.layer.borderColor = [[UIColor blackColor] CGColor];
    view1.layer.cornerRadius = 5;
    view1.layer.borderWidth = 1.0;
    
    view2.layer.borderColor = [[UIColor blackColor] CGColor];
    view2.layer.cornerRadius = 5;
    view2.layer.borderWidth = 1.0;
    
    view3.layer.borderColor = [[UIColor blackColor] CGColor];
    view3.layer.cornerRadius = 5;
    view3.layer.borderWidth = 1.0;
    
    view4.layer.borderColor = [[UIColor blackColor] CGColor];
    view4.layer.cornerRadius = 5;
    view4.layer.borderWidth = 1.0;
    
    // hide the more button if this item is official event
    if (isOfficial) {
        moreBtn.style = UIBarButtonItemStylePlain;
        moreBtn.enabled = false;
    }
    else {
        // hide the more button if this meetup item is not created by this user
        if ([[userDefault objectForKey:@"user_id"] intValue] == userID) {
            moreBtn.style = UIBarButtonItemStyleBordered;
            moreBtn.enabled = true;
            
        } else {
            moreBtn.style = UIBarButtonItemStylePlain;
            moreBtn.enabled = false;
        }
    }
    
    
    // set up location manager
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    _startLocation = nil;
    
    // show indicator
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    indicator.center = self.view.center;
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    [indicator startAnimating];
    
    // userDefault
    userDefault = [NSUserDefaults standardUserDefaults];
}

- (void) tapGestureRecognizer {
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDetected)];
    singleTap.numberOfTapsRequired = 1;
    [eventButton setUserInteractionEnabled:YES];
    [eventButton addGestureRecognizer:singleTap];
}

- (void) tapGestureRecognizerOfficial {
    UITapGestureRecognizer *eventImageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(eventImageTapDetected)];
    eventImageTap.numberOfTapsRequired = 1;
    [eventImage setUserInteractionEnabled:YES];
    [eventImage addGestureRecognizer:eventImageTap];
}

- (void) tapGestureRecognizerEventAttend {
    UITapGestureRecognizer *eventImageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(eventAttendImageDetected)];
    eventImageTap.numberOfTapsRequired = 1;
    [eventAttendImage setUserInteractionEnabled:YES];
    [eventAttendImage addGestureRecognizer:eventImageTap];
}

- (void) tapGestureRecognizerEventFavorite {
    UITapGestureRecognizer *eventImageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(eventFavoriteImageDetected)];
    eventImageTap.numberOfTapsRequired = 1;
    [eventFavoriteImage setUserInteractionEnabled:YES];
    [eventFavoriteImage addGestureRecognizer:eventImageTap];
}

- (void) tapDetected {
    ProfileViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    viewController.hidesBottomBarWhenPushed = YES;
    [viewController setUserID:userID];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void) eventImageTapDetected {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 150, 150)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [item objectForKey:@"image_url"]]]];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                        message:[item objectForKey:@"name"]
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Close", nil];
    [alertView setValue:imageView forKey:@"accessoryView"];
    [alertView show];
}

- (void) eventAttendImageDetected {
    [self uploadMyAttend];
}

- (void) eventFavoriteImageDetected {
    [self uploadMyFavorite];
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
    NSDictionary *params = @{@"event_id"    :[NSString stringWithFormat:@"%d", eventID]};
    
    [manager POST:@"http://heounsuk.com/festival/download_event_details_all.php" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        
        if([[responseObject objectForKey:@"success"] boolValue] == TRUE) {
            NSMutableArray *eventInfoItem = [NSMutableArray arrayWithCapacity:0];
            [eventInfoItem addObjectsFromArray:[responseObject objectForKey:@"results"]];
            
            item = [eventInfoItem objectAtIndex:0];
            
            // get a list of going users
            NSMutableArray *goingArray = [NSMutableArray arrayWithCapacity:0];
        
            attend_flag = ADD_ATTEND;
            goingArray = [item objectForKey:@"going_user_ary"];
            for (int i = 0; i < [goingArray count]; i++) {
                NSDictionary *goingItem = [goingArray objectAtIndex:i];
                
                // if this user already added "attend" to this event, change the color and text of button
                if ([[goingItem objectForKey:@"user_id"] intValue] == [[userDefault objectForKey:@"user_id"] intValue]) {
                    attend_flag = REMOVE_ATTEND;
                    break;
                }
            }
            if (attend_flag == 0) { // ADD_ATTEND
                [eventAttendImage setImage:[UIImage imageNamed:@"running_normal.png"]];
            }
            else { // REMOVE_ATTEND
                [eventAttendImage setImage:[UIImage imageNamed:@"running_selected.png"]];
            }
            // end going
            
            // get a list of favorite users
            NSMutableArray *favArray = [NSMutableArray arrayWithCapacity:0];
            
            favorite_flag = ADD_FAVORITE;
            favArray = [item objectForKey:@"favorite_user_ary"];
            for (int i = 0; i < [favArray count]; i++) {
                NSDictionary *favItem = [favArray objectAtIndex:i];
                
                // if this user already added "favorite" to this event, change the color and text of button
                if ([[favItem objectForKey:@"user_id"] intValue] == [[userDefault objectForKey:@"user_id"] intValue]) {
                    favorite_flag = REMOVE_FAVORITE;
                    break;
                }
            }
            if (favorite_flag == 0) { // ADD_FAVORITE
                [eventFavoriteImage setImage:[UIImage imageNamed:@"star_normal.png"]];
            }
            else { // REMOVE_FAVORITE
                [eventFavoriteImage setImage:[UIImage imageNamed:@"star_selected.png"]];
            }
            // end favorite
            
            // get counts for attends, favorites, and photos
            int attendCnt = (int)[[item objectForKey:@"going_user_ary"] count];
            int favoriteCtn = [[item objectForKey:@"favorite_cnt"] intValue];
            int photoCnt = [[item objectForKey:@"user_content_cnt"] intValue];

            // update the going and userinput btn texts
            if (attendCnt <= 1) {
                [eventGoingBtn setTitle:[NSString stringWithFormat:@"%d attend", attendCnt] forState:UIControlStateNormal];
            }
            else {
                [eventGoingBtn setTitle:[NSString stringWithFormat:@"%d attends", attendCnt] forState:UIControlStateNormal];
            }
            
            if (favoriteCtn <= 1) {
                [eventLikeBtn setTitle:[NSString stringWithFormat:@"%d favorite", favoriteCtn] forState:UIControlStateNormal];
            }
            else {
                [eventLikeBtn setTitle:[NSString stringWithFormat:@"%d favorites", favoriteCtn] forState:UIControlStateNormal];
            }
            
            if (photoCnt <= 1) {
                [eventUserInputBtn setTitle:[NSString stringWithFormat:@"%d photo", photoCnt] forState:UIControlStateNormal];
            }
            else {
                [eventUserInputBtn setTitle:[NSString stringWithFormat:@"%d photos", photoCnt] forState:UIControlStateNormal];
            }
            
            // name and description
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
            
            [eventImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [item objectForKey:@"image_url"]]]];
            eventImage.contentMode = UIViewContentModeScaleAspectFill;
            eventImage.layer.cornerRadius = 4.0f;
            eventImage.clipsToBounds = YES;
            
            // add a push pin on the map
            CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(
                                                                    [[item objectForKey:@"latitude"] doubleValue],
                                                                    [[item objectForKey:@"longitude"] doubleValue]);
            
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            [annotation setCoordinate:loc];
            [eventMap removeAnnotations:[eventMap annotations]];
            [eventMap addAnnotation:annotation];
            
            MKCoordinateRegion adjustedRegion = [eventMap regionThatFits:MKCoordinateRegionMakeWithDistance(loc, 800, 800)];
            adjustedRegion.span.longitudeDelta  = 0.01;
            adjustedRegion.span.latitudeDelta  = 0.01;
            [eventMap setRegion:adjustedRegion animated:YES];
            
            // start touchGestureEvent
            [self tapGestureRecognizerOfficial];
            [self tapGestureRecognizerEventAttend];
            [self tapGestureRecognizerEventFavorite];
            
            // check if the event is official one
            if (isOfficial) {
                if ([[item objectForKey:@"button"] intValue] == 1) {
                    eventButton.text = @"Button required";
                    eventButtonImage.hidden = NO;
                }
                else {
                    eventButton.text = @"Free event";
                    eventButtonImage.hidden = NO;
                    eventButtonImage.alpha = 0.2;
                    
                    eventEditBtn.hidden = YES;
                    eventRemoveBtn.hidden = YES;
                }
            }
            else { // if not official use eventButton text for displaying user_name who posted the event
                eventButton.text = userName;
                eventButton.textColor = [UIColor colorWithRed:59.0/255.0 green:89.0/255.0 blue:152.0/255.0 alpha:1.0];
                
                [eventButtonImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", userImage]]];
                eventButtonImage.layer.cornerRadius = eventButtonImage.frame.size.width / 2;
                eventButtonImage.clipsToBounds = YES;
                eventButtonImage.hidden = NO;
                
                [self tapGestureRecognizer];
            }
            
            // set location name; if null, just Location
            if ([[item objectForKey:@"location_name"] isEqual:[NSNull null]]) {
                eventLocationName.text = @"Location";
                eventLocationName.hidden = NO;
            }
            else {
                eventLocationName.text = [item objectForKey:@"location_name"];
                eventLocationName.hidden = NO;
            }
            
            // hide website btn if nothing exists
            if ([[item objectForKey:@"website"] isEqualToString:@"none"] ||
                [[item objectForKey:@"website"] isEqual:[NSNull null]] ||
                [[item objectForKey:@"website"] length] == 0) {
                eventWebPageBtn.enabled = NO;
                eventWebImage.alpha = 0.2;
                eventWebPageBtn.alpha = 0.2;
            }
        }
        else {
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [indicator stopAnimating];
}

- (void) uploadMyAttend {
    
    NSString *timeStampValue = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user_id"     :[userDefault objectForKey:@"user_id"],
                             @"event_id"    :[item objectForKey:@"id"],
                             @"datetime"    :[NSString stringWithFormat:@"%@", timeStampValue],
                             @"latitude"    :[NSString stringWithFormat:@"%f", latitude],
                             @"longitude"   :[NSString stringWithFormat:@"%f", longitude],
                             @"flag"        :[NSString stringWithFormat:@"%d", attend_flag]};
    
    [manager POST:@"http://heounsuk.com/festival/upload_my_going.php" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        
        if([[responseObject objectForKey:@"success"] boolValue] == TRUE) {
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

- (void) uploadMyFavorite {
    
    NSString *timeStampValue = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user_id"     :[userDefault objectForKey:@"user_id"],
                             @"event_id"    :[item objectForKey:@"id"],
                             @"datetime"    :[NSString stringWithFormat:@"%@", timeStampValue],
                             @"latitude"    :[NSString stringWithFormat:@"%f", latitude],
                             @"longitude"   :[NSString stringWithFormat:@"%f", longitude],
                             @"flag"        :[NSString stringWithFormat:@"%d", favorite_flag]};
    
    [manager POST:@"http://heounsuk.com/festival/upload_my_favorite_events.php" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        
        if([[responseObject objectForKey:@"success"] boolValue] == TRUE) {
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

- (void) removeEvent {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user_id"     :[userDefault objectForKey:@"user_id"],
                             @"event_id"    :[item objectForKey:@"id"]};
    
    [manager POST:@"http://heounsuk.com/festival/remove_meetup.php" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        
        if([[responseObject objectForKey:@"success"] boolValue] == TRUE) {
            // when succeed, dismiss the current view controller
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Operation: %@, Error: %@", operation, error);
    }];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Attending"]){ // Attending
        [self uploadMyAttend];
    }
    else if ([title isEqualToString:@"Favorite"]){ // Favorite
        [self uploadMyFavorite];
    }
    else if ([title isEqualToString:@"Remove this event"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Are you sure you want to remove this event?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Remove", nil];
        [alert show];
    }
    else if ([title isEqualToString:@"Remove"]) {
        [self removeEvent];
    }
    else if ([title isEqualToString:@"Edit this event"]) {
        
        MeetupCreateViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MeetupCreateViewController"];
        viewController.hidesBottomBarWhenPushed = YES;
        [viewController setType:1];
        [viewController setMeetupDatetime:[item objectForKey:@"datetime"]];
        [viewController setMeetupDescription:[item objectForKey:@"description"]];
        [viewController setMeetupPhoto:[item objectForKey:@"image_url"]];
        [viewController setSelectedLocLatitude:[[item objectForKey:@"latitude"] doubleValue]];
        [viewController setSelectedLocLongitude:[[item objectForKey:@"longitude"] doubleValue]];
        [viewController setMeetupID:(int)[[item objectForKey:@"id"] integerValue]];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}


- (IBAction)eventGoingBtnPressed:(id)sender {
    type = SEE_ATTEND;
}

- (IBAction)eventLikeBtnPressed:(id)sender {
    type = SEE_FAVORITE;
}

- (IBAction)eventUserInputBtnPressed:(id)sender {
}

- (IBAction)eventRemoveBtnPressed:(id)sender {
    
}

- (IBAction)moreBtnPressed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Choose the option"
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Edit this event", @"Remove this event", nil];
    [alert show];
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
    else if ([[segue identifier] isEqualToString: @"UserListViewController"]) {
        UserListViewController *viewController = (UserListViewController *)[segue destinationViewController];
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.eventID = [[item objectForKey:@"id"] intValue];
        viewController.type = type;
    }
    
}

- (IBAction)myLocationBtn:(id)sender {
    [eventMap setCenterCoordinate:eventMap.userLocation.location.coordinate animated:YES];
}

@end
