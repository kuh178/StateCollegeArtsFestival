//
//  MyActivitiesViewController.m
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 3/20/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import "MyActivitiesViewController.h"
#import "JSON.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "EventDetailViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "UserInputDetailViewController.h"
#import "UserPhotoListViewController.h"
#import "UserInputDetailedViewController.h"
#import "MyActivityQuestionViewController.h"
#import "ProfileViewController.h"

@interface MyActivitiesViewController ()

@end

@implementation MyActivitiesViewController

@synthesize myList, jsonArray, tableViewList, myListSegment, refreshBtn;

#define MY_UPDATES 1
#define MY_EVENTS 2
#define MY_PHOTOS 3
#define PEOPLE_LIKE_ME 4

#define ACTION_NOTHING 0
#define ACTION_EVENT 1
#define ACTION_SURVEY 2
#define ACTION_USER_PHOTO 3
#define ACTION_YO 4

int myType = MY_UPDATES;
UIActivityIndicatorView *indicator;

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
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:51.0/255.0 green:164.0/255.0 blue:192.0/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    // show download indicator
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    indicator.center = self.view.center;
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    
    [self downloadMyUpdates];
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"MyActivitiesViewController";
    self.navigationItem.backBarButtonItem.title = @"Back";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

// Table view property
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [myList count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Display items
    NSMutableDictionary *item    = [myList objectAtIndex:indexPath.row];
    UIImageView *eventImage      = (UIImageView *)[cell viewWithTag:100];
    UILabel *eventName           = (UILabel *)[cell viewWithTag:101];
    UILabel *eventDate           = (UILabel *)[cell viewWithTag:102];
    UIImageView *yoImage         = (UIImageView *)[cell viewWithTag:103];
    
    if (myType == MY_UPDATES) {
        // my update
        eventName.text = [item objectForKey:@"message"];
        eventImage.image = [UIImage imageNamed:@"2015_button_faceonly.png"];
        
        double timestamp = [[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] doubleValue];
        eventDate.text = [self dailyLanguage:(timestamp-[[item objectForKey:@"datetime"] doubleValue])];
        
        if ([[item objectForKey:@"action"] intValue] == ACTION_YO) {
            yoImage.hidden = NO;
        }
        else {
            yoImage.hidden = YES;
        }
    }
    else if (myType == MY_EVENTS) {
        // event image
        [eventImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [item objectForKey:@"image_url"]]]];
        eventImage.layer.cornerRadius = 4.0f;
        eventImage.clipsToBounds = YES;
        
        // event question
        eventName.text = [item objectForKey:@"name"];
        
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
        eventDate.text = _date;
        
        // if it is a meet-up event, show a small icon
        if ([[item objectForKey:@"is_meetup"] intValue] == 1) {
            yoImage.hidden = NO;
        }
        else {
            yoImage.hidden = YES;
        }
    }
    else if (myType == MY_PHOTOS) { // MY_PHOTOS
        // event image
        [eventImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [item objectForKey:@"image_url"]]]];
        eventImage.layer.cornerRadius = 4.0f;
        eventImage.clipsToBounds = YES;
        
        // event question
        eventName.text = [item objectForKey:@"comment"];
        
        // event count
        if ([[item objectForKey:@"like_cnt"] intValue] <= 1) {
            if ([[item objectForKey:@"comment_cnt"] intValue] <= 1) {
                eventDate.text = [NSString stringWithFormat:@"%d like %d comment", [[item objectForKey:@"like_cnt"] intValue], [[item objectForKey:@"comment_cnt"] intValue]];
            }
            else {
                eventDate.text = [NSString stringWithFormat:@"%d like %d comments", [[item objectForKey:@"like_cnt"] intValue], [[item objectForKey:@"comment_cnt"] intValue]];
            }
        }
        else {
            if ([[item objectForKey:@"comment_cnt"] intValue] <= 1) {
                eventDate.text = [NSString stringWithFormat:@"%d likes %d comment", [[item objectForKey:@"like_cnt"] intValue], [[item objectForKey:@"comment_cnt"] intValue]];
            }
            else {
                eventDate.text = [NSString stringWithFormat:@"%d likes %d comments", [[item objectForKey:@"like_cnt"] intValue], [[item objectForKey:@"comment_cnt"] intValue]];
            }
        }
        
        // hide yo image
        yoImage.hidden = YES;
    }
    else if (myType == PEOPLE_LIKE_ME) { // PEOPLE_LIKE_ME
        // user_image
        [eventImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [item objectForKey:@"image"]]]];
        eventImage.layer.cornerRadius = 4.0f;
        eventImage.clipsToBounds = YES;
    
        // user name
        eventName.text = [item objectForKey:@"name"];
        
        // hide datetime
        eventDate.text = [NSString stringWithFormat:@"%3.1f%% matching", [[item objectForKey:@"matching_result"] doubleValue] * 100.0];
        
        // hide yo image
        yoImage.hidden = YES;
    }
    else {
        
    }
    
    return cell;
}

-(NSString*)dailyLanguage:(NSTimeInterval) overdueTimeInterval{
    
    overdueTimeInterval = overdueTimeInterval -4*3600;
    
    if (overdueTimeInterval<0)
        overdueTimeInterval*=-1;
    
    NSInteger minutes = round(overdueTimeInterval)/60;
    NSInteger hours   = minutes/60;
    NSInteger days    = hours/24;
    NSInteger months  = days/30;
    NSInteger years   = months/12;
    
    NSString* overdueMessage;
    
    if (years>0){
        overdueMessage = [NSString stringWithFormat:@"%d %@", (years), (years==1?@"year ago":@"years ago")];
    }else if (months>0){
        overdueMessage = [NSString stringWithFormat:@"%d %@", (months), (months==1?@"month ago":@"months ago")];
    }else if (days>0){
        overdueMessage = [NSString stringWithFormat:@"%d %@", (days), (days==1?@"day ago":@"days ago")];
    }else if (hours>0){
        overdueMessage = [NSString stringWithFormat:@"%d %@", (hours), (hours==1?@"hour ago":@"hours ago")];
    }else if (minutes>0){
        overdueMessage = [NSString stringWithFormat:@"%d %@", (minutes), (minutes==1?@"minute ago":@"minutes ago")];
    }else if (overdueTimeInterval<60){
        overdueMessage = [NSString stringWithFormat:@"a few seconds ago"];
    }
    
    return overdueMessage;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *item = [myList objectAtIndex:indexPath.row];
    
    if (myType == MY_UPDATES) {
        if ([[item objectForKey:@"action"] intValue] == ACTION_EVENT) {
            EventDetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EventDetailViewController"];
            viewController.hidesBottomBarWhenPushed = YES;
            [viewController setEventID:[[item objectForKey:@"special_id"] intValue]];
            [viewController setIsOfficial:YES];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        else if ([[item objectForKey:@"action"] intValue] == ACTION_SURVEY) {
            MyActivityQuestionViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyActivityQuestionViewController"];
            [viewController setSurveyID:[[item objectForKey:@"id"] intValue]]; // passing the survey ID
            [viewController setQAry:[item objectForKey:@"survey_questions"]];
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }
        else if ([[item objectForKey:@"action"] intValue] == ACTION_USER_PHOTO) {
            UserInputDetailedViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserInputDetailedViewController"];
            viewController.hidesBottomBarWhenPushed = YES;
            [viewController setItem:[item objectForKey:@"photo_info"]];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        else if ([[item objectForKey:@"action"] intValue] == ACTION_YO) {
            ProfileViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
            viewController.hidesBottomBarWhenPushed = YES;
            [viewController setUserID:[[item objectForKey:@"special_id"]intValue]];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
    else if (myType == MY_EVENTS) {
        if ([[item objectForKey:@"is_meetup"] intValue] == 0) {
            EventDetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EventDetailViewController"];
            viewController.hidesBottomBarWhenPushed = YES;
            [viewController setEventID:[[item objectForKey:@"id"] intValue]];
            [viewController setIsOfficial:YES];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        else {
            // if it is A meetup item, pass meetup_user_id, meetup_user_name, meetup_user_image
            EventDetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EventDetailViewController"];
            viewController.hidesBottomBarWhenPushed = YES;
            [viewController setEventID:[[item objectForKey:@"id"] intValue]];
            [viewController setIsOfficial:NO];
            [viewController setUserID:[[item objectForKey:@"meetup_user_id"] intValue]];
            [viewController setUserName:[item objectForKey:@"meetup_user_name"]];
            [viewController setUserImage:[item objectForKey:@"meetup_user_image"]];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
    else if (myType == MY_PHOTOS){
        UserInputDetailedViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserInputDetailedViewController"];
        viewController.hidesBottomBarWhenPushed = YES;
        [viewController setItem:item];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (myType == PEOPLE_LIKE_ME) {
        ProfileViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        viewController.hidesBottomBarWhenPushed = YES;
        [viewController setUserID:[[item objectForKey:@"id"]intValue]];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void) downloadContent {
    
    [indicator startAnimating];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *params = @{@"user_id"     :[userDefault objectForKey:@"user_id"]};
        
        [manager POST:@"http://heounsuk.com/festival/download_my_activities.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            
            if ([[responseObject objectForKey:@"success"]boolValue] == TRUE) {
                jsonArray = [NSMutableArray arrayWithCapacity:0];
                myList = [NSMutableArray arrayWithCapacity:0];
                [jsonArray addObjectsFromArray:[responseObject objectForKey:@"results"]];
                
                if ([jsonArray count] > 0) {
                    // insert new items into table
                    for (int i = 0; i < [jsonArray count]; i++) {
                        
                        // get an item
                        NSDictionary *item = [jsonArray objectAtIndex:i];
                        [myList addObject:item];
        
                    }
                }
                else {
                    NSLog(@"No data available");
                }
                
                [indicator stopAnimating];
                [tableViewList reloadData];
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
            NSLog(@"Error: %@", operation);
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
    });
}

- (void) downloadMyPhotos {
    
    [indicator startAnimating];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user_id"     :[userDefault objectForKey:@"user_id"]};
    
    [manager POST:@"http://heounsuk.com/festival/download_user_photos.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        if ([[responseObject objectForKey:@"success"]boolValue] == TRUE) {
            jsonArray = [NSMutableArray arrayWithCapacity:0];
            myList = [NSMutableArray arrayWithCapacity:0];
            [jsonArray addObjectsFromArray:[responseObject objectForKey:@"results"]];
            
            if ([jsonArray count] > 0) {
                // insert new items into table
                for (int i = 0; i < [jsonArray count]; i++) {
                    
                    // get an item
                    NSDictionary *item = [jsonArray objectAtIndex:i];
                    [myList addObject:item];
                }
            }
            else {
                NSLog(@"No data available");
            }
            
            [indicator stopAnimating];
            [tableViewList reloadData];
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
        NSLog(@"Error: %@", operation);
    }];
}

- (void) downloadMyUpdates {
    
    [indicator startAnimating];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user_id"     :[userDefault objectForKey:@"user_id"]};
    
    NSLog(@"user_id: %@", [userDefault objectForKey:@"user_id"]);
    
    [manager POST:@"http://heounsuk.com/festival/download_user_updates.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        if ([[responseObject objectForKey:@"success"]boolValue] == TRUE) {
            jsonArray = [NSMutableArray arrayWithCapacity:0];
            myList = [NSMutableArray arrayWithCapacity:0];
            [jsonArray addObjectsFromArray:[responseObject objectForKey:@"results"]];
            
            if ([jsonArray count] > 0) {
                // insert new items into table
                for (int i = 0; i < [jsonArray count]; i++) {
                    
                    // get an item
                    NSDictionary *item = [jsonArray objectAtIndex:i];
                    [myList addObject:item];
                }
            }
            else {
                NSLog(@"No data available");
            }

            [indicator stopAnimating];
            [tableViewList reloadData];
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
        NSLog(@"Error: %@", operation);
    }];
}

- (void) downloadPeopleLikeMe {
    [indicator startAnimating];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user_id"     :[userDefault objectForKey:@"user_id"]};
    
    NSLog(@"user_id: %@", [userDefault objectForKey:@"user_id"]);
    
    [manager POST:@"http://heounsuk.com/festival/download_my_people.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        if ([[responseObject objectForKey:@"success"]boolValue] == TRUE) {
            jsonArray = [NSMutableArray arrayWithCapacity:0];
            myList = [NSMutableArray arrayWithCapacity:0];
            [jsonArray addObjectsFromArray:[responseObject objectForKey:@"results"]];
            
            if ([jsonArray count] > 0) {
                // insert new items into table
                for (int i = 0; i < [jsonArray count]; i++) {
                    
                    // get an item
                    NSDictionary *item = [jsonArray objectAtIndex:i];
                    [myList addObject:item];
                }
            }
            else {
                NSLog(@"No data available");
            }
            
            [indicator stopAnimating];
            [tableViewList reloadData];
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
        NSLog(@"Error: %@", operation);
    }];
}

- (IBAction)myListSegmentSelected:(id)sender {
    if (myListSegment.selectedSegmentIndex == 0) { // My Updates
        
        myType = MY_UPDATES;
        
        [self downloadMyUpdates];
    }
    else if (myListSegment.selectedSegmentIndex == 1) { // My Events
        
        myType = MY_EVENTS;
        
        [self downloadContent];
    }
    else if (myListSegment.selectedSegmentIndex == 2) { // My Photos
        
        myType = MY_PHOTOS;
        
        [self downloadMyPhotos];
    }
    else { // People Like Me
        
        myType = PEOPLE_LIKE_ME;
        
        [self downloadPeopleLikeMe];
    }
}

-(IBAction)refreshBtnPressed:(id)sender {
    if (myType == MY_UPDATES) { // My Updates
        [self downloadMyUpdates];
    }
    else if (myType == MY_EVENTS) { // My Events
        [self downloadContent];
    }
    else if (myType == MY_PHOTOS) { // My Photos
        [self downloadMyPhotos];
    }
    else if (myType == PEOPLE_LIKE_ME) { // People Like Me
        [self downloadPeopleLikeMe];
    }
}

@end
