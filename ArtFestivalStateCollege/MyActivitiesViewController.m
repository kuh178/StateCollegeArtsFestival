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

@interface MyActivitiesViewController ()

@end

@implementation MyActivitiesViewController

@synthesize myList, jsonArray, tableViewList, myListSegment, refreshBtn;

#define MY_UPDATES 1
#define MY_EVENTS 2
#define MY_PHOTOS 3
#define PEOPLE_LIKE_ME 4

int myType = MY_UPDATES;

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
    
    [self downloadContent];
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
    
    if (myType == MY_UPDATES) {
        
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
    }
    else { // people like me
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *item = [myList objectAtIndex:indexPath.row];
    
    if (myType == MY_EVENTS) {
        EventDetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EventDetailViewController"];
        viewController.hidesBottomBarWhenPushed = YES;
        [viewController setItem:item];
        [viewController setIsOfficial:YES];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else {
        UserInputDetailedViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserInputDetailedViewController"];
        viewController.hidesBottomBarWhenPushed = YES;
        [viewController setItem:item];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void) downloadContent {

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user_id"     :[userDefault objectForKey:@"user_id"]};

    [manager POST:@"http://community.ist.psu.edu/Festival/download_my_activities.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

- (void) downloadMyPhotos {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user_id"     :[userDefault objectForKey:@"user_id"]};
    
    [manager POST:@"http://community.ist.psu.edu/Festival/download_user_photos.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    
}

- (void) downloadPeopleLikeMe {
    
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

@end
