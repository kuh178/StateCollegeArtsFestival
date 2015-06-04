//
//  FirstViewController.m
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 3/4/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import "FirstViewController.h"
#import "LoginViewController.h"
#import "JSON.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "EventDetailViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "EventMapViewViewController.h"
#import "UserInputDetailViewController.h"

#define firstDay    1
#define secondDay   2
#define thirdDay    3
#define fourthDay   4

@interface FirstViewController ()

@end

@implementation FirstViewController

@synthesize eventList, eventListDay, jsonArray, tableViewList, segmentControl, refreshBtn, cameraBtn;

int flag = firstDay;
NSUserDefaults *userDefault;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSLog(@"111is_loggedin? : %@", [userDefault objectForKey:@"is_loggedin"]);
    
    // ios7 handling navigationBar
    // ref : http://stackoverflow.com/questions/19029833/ios-7-navigation-bar-text-and-arrow-color
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:51.0/255.0 green:164.0/255.0 blue:192.0/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    //
    userDefault = [NSUserDefaults standardUserDefaults];

    // show content
    [self downloadContent:firstDay];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"FirstViewController";
    self.navigationItem.backBarButtonItem.title = @"Back";
}

// Table view property
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [eventListDay count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    // Display items
    NSMutableDictionary *item       = [eventListDay objectAtIndex:indexPath.row];
    UIImageView *eventImage         = (UIImageView *)[cell viewWithTag:100];
    UILabel *eventName              = (UILabel *)[cell viewWithTag:101];
    UIImageView *eventButton        = (UIImageView *)[cell viewWithTag:102];
    UILabel *eventDate              = (UILabel *)[cell viewWithTag:103];
    UIImageView *eventFavorite      = (UIImageView *)[cell viewWithTag:104];
    UIImageView *eventAttend        = (UIImageView *)[cell viewWithTag:105];
    
    // event image
    [eventImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [item objectForKey:@"image_url"]]]];
    eventImage.layer.cornerRadius = 4.0f;
    eventImage.clipsToBounds = YES;
    
    // event question
    eventName.text = [item objectForKey:@"name"];
    
    // event date
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
    
    // event button
    if ([[item objectForKey:@"button"] intValue] == 1) {
        eventButton.hidden = NO;
    }
    else {
        eventButton.hidden = YES;
    }
    
    // favorite or going
    NSArray *favoriteArray = [item objectForKey:@"favorite_user_ary"];
    NSArray *attendArray = [item objectForKey:@"going_user_ary"];
    
    // checking favorite
    BOOL isFavorite = NO;
    
    for (int i = 0; i < [favoriteArray count]; i++) {
        NSDictionary *fItem = [favoriteArray objectAtIndex:i];
        if ([[fItem objectForKey:@"user_id"] intValue] == [[userDefault objectForKey:@"user_id"] intValue]) {
            isFavorite = YES;
            break;
        }
    }
    
    if (isFavorite) {
        eventFavorite.hidden = NO;
    }
    else {
        eventFavorite.hidden = YES;
    }
    
    // checking attend
    BOOL isAttend = NO;
    
    for (int i = 0; i < [attendArray count]; i++) {
        NSDictionary *aItem = [attendArray objectAtIndex:i];
        if ([[aItem objectForKey:@"user_id"] intValue] == [[userDefault objectForKey:@"user_id"] intValue]) {
            isAttend = YES;
            break;
        }
    }
    
    if (isAttend) {
        eventAttend.hidden = NO;
    }
    else {
        eventAttend.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *item = [eventListDay objectAtIndex:indexPath.row];
    
    //[self performSegueWithIdentifier:@"EventDetailViewController" sender:item];
    
    EventDetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EventDetailViewController"];
    viewController.hidesBottomBarWhenPushed = YES;
    [viewController setEventID:[[item objectForKey:@"id"]intValue]];
    [viewController setIsOfficial:YES];
    [self.navigationController pushViewController:viewController animated:YES];
    //[self presentViewController:viewController animated:YES completion:nil];
}

- (void) downloadContent:(int)flag {
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    indicator.center = self.view.center;
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    
    [indicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:@"http://heounsuk.com/festival/download_events.php" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            
            if ([[responseObject objectForKey:@"success"]boolValue] == TRUE) {
                jsonArray = [NSMutableArray arrayWithCapacity:0];
                eventList = [NSMutableArray arrayWithCapacity:0];
                eventListDay = [NSMutableArray arrayWithCapacity:0];
                [jsonArray addObjectsFromArray:[responseObject objectForKey:@"results"]];
                
                if ([jsonArray count] > 0) {
                    // insert new items into table
                    for (int i = 0; i < [jsonArray count]; i++) {
                        
                        // get an item
                        NSDictionary *item = [jsonArray objectAtIndex:i];
                        [eventList addObject:item];
                    }
                }
                else {
                    NSLog(@"No data available");
                }
                
                // default is the 1st day
                for (int i = 0 ; i < [eventList count] ; i++) {
                    
                    NSMutableDictionary *item = [eventList objectAtIndex:i];
                    
                    if ([[item objectForKey:@"day"] intValue] == flag) {
                        [eventListDay addObject:item];
                    }
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
            NSLog(@"Error: %@", error);
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // run UI updates
        });
    });
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString: @"EventMapViewViewController"]) {
        EventMapViewViewController *viewController = (EventMapViewViewController *)[segue destinationViewController];
        viewController.hidesBottomBarWhenPushed = YES;
        [viewController setList:eventList];
    }
    else if ([[segue identifier] isEqualToString: @"UserInputDetailViewController"]) {
        UserInputDetailViewController *viewController = (UserInputDetailViewController *)[segue destinationViewController];
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.eventID = -1;
    }
}

-(IBAction)refreshBtnPressed:(id)sender {
    [self downloadContent:flag];
}


-(IBAction)segmentPressed:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    eventListDay = [NSMutableArray arrayWithCapacity:0];
    
    if (selectedSegment == 0) { // 1st
        flag = firstDay;
    }
    else if (selectedSegment == 1){ // 2nd
        flag = secondDay;
    }
    else if (selectedSegment == 2){ // 3nd
        flag = thirdDay;
    }
    else { // 4th
        flag = fourthDay;
    }
    
    // get the items based on the day
    for (int i = 0 ; i < [eventList count] ; i++) {
        
        NSMutableDictionary *item = [eventList objectAtIndex:i];
        
        if ([[item objectForKey:@"day"] intValue] == flag) {
            [eventListDay addObject:item];
        }
    }
    
    [tableViewList reloadData];
}

@end
