//
//  PopularMainViewController.m
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 6/17/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import "PopularMainViewController.h"
#import "LoginViewController.h"
#import "JSON.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "EventDetailViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "EventMapViewViewController.h"
#import "UserInputDetailedViewController.h"
#import "UserInputDetailViewController.h"
#import "MyPhotoViewController.h"

#define PERFORMANCE 0
#define USERPHOTO 1
#define USER 2

@interface PopularMainViewController ()

@end

@implementation PopularMainViewController

@synthesize eventList, photoList, userList, jsonArray, tableViewList, segmentControl; //refreshBtn

int popular_flag = PERFORMANCE;
UIActivityIndicatorView *indicator;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    eventList = [NSMutableArray arrayWithCapacity:0];
    photoList = [NSMutableArray arrayWithCapacity:0];
    userList  = [NSMutableArray arrayWithCapacity:0];
    
    // ios7 handling navigationBar
    // ref : http://stackoverflow.com/questions/19029833/ios-7-navigation-bar-text-and-arrow-color
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:51.0/255.0 green:164.0/255.0 blue:192.0/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    indicator.center = self.view.center;
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    
    [self downloadContent];
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
    self.screenName = @"PopularMainViewController";
    self.navigationItem.backBarButtonItem.title = @"Back";
}

// Table view property
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (popular_flag == PERFORMANCE)
        return [eventList count];
    else if (popular_flag == USERPHOTO)
        return [photoList count];
    else
        return [userList count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    if(popular_flag == PERFORMANCE) {
        // Display items
        NSMutableDictionary *item       = [eventList objectAtIndex:indexPath.row];
        UIImageView *eventImage         = (UIImageView *)[cell viewWithTag:100];
        UILabel *eventName              = (UILabel *)[cell viewWithTag:101];
        UILabel *eventCount             = (UILabel *)[cell viewWithTag:102];
        UIImageView *userBadge          = (UIImageView *)[cell viewWithTag:103];
        //UIImageView *eventButton        = (UIImageView *)[cell viewWithTag:102];
        //UILabel *eventDate              = (UILabel *)[cell viewWithTag:103];
        
        // hide badges
        [userBadge setHidden:YES];
        
        // event image
        [eventImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [item objectForKey:@"image_url"]]]];
        eventImage.layer.cornerRadius = eventImage.frame.size.width / 2;
        eventImage.clipsToBounds = YES;
        
        // event name
        eventName.text = [item objectForKey:@"name"];
        
        // event count
        if ([[item objectForKey:@"going_cnt"] intValue] <= 1) {
            if ([[item objectForKey:@"photo_cnt"] intValue] <= 1) {
                eventCount.text = [NSString stringWithFormat:@"%d attend, %d photo", [[item objectForKey:@"going_cnt"] intValue], [[item objectForKey:@"photo_cnt"] intValue]];
            }
            else {
                eventCount.text = [NSString stringWithFormat:@"%d attend, %d photos", [[item objectForKey:@"going_cnt"] intValue], [[item objectForKey:@"photo_cnt"] intValue]];
            }
        }
        else {
            if ([[item objectForKey:@"photo_cnt"] intValue] <= 1) {
                eventCount.text = [NSString stringWithFormat:@"%d attends, %d photo", [[item objectForKey:@"going_cnt"] intValue], [[item objectForKey:@"photo_cnt"] intValue]];
            }
            else {
                eventCount.text = [NSString stringWithFormat:@"%d attends, %d photos", [[item objectForKey:@"going_cnt"] intValue], [[item objectForKey:@"photo_cnt"] intValue]];
            }
        }
        
        
        
        // plan date
        /*
         NSTimeInterval _interval=[[item objectForKey:@"datetime"] doubleValue];
         NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
         NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
         [_formatter setLocale:[NSLocale currentLocale]];
         [_formatter setDateFormat:@"MMM-dd-yyyy"]
         NSString *_date=[_formatter stringFromDate:date];
         eventDate.text = _date;
         */
    }
    else if (popular_flag == USERPHOTO) { // flag == USERPHOTO
        // Display items
        NSMutableDictionary *item       = [photoList objectAtIndex:indexPath.row];
        UIImageView *eventImage         = (UIImageView *)[cell viewWithTag:100];
        UILabel *eventDescription       = (UILabel *)[cell viewWithTag:101];
        UILabel *eventCount             = (UILabel *)[cell viewWithTag:102];
        UIImageView *userBadge          = (UIImageView *)[cell viewWithTag:103];
        
        // hide badges
        [userBadge setHidden:YES];
        
        // event image
        [eventImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [item objectForKey:@"image_url"]]]];
        eventImage.layer.cornerRadius = eventImage.frame.size.width / 2;
        eventImage.clipsToBounds = YES;
        
        // event name
        eventDescription.text = [item objectForKey:@"comment"];
        
        // event count
        if ([[item objectForKey:@"like_cnt"] intValue] <= 1) {
            if ([[item objectForKey:@"comment_cnt"] intValue] <= 1) {
                eventCount.text = [NSString stringWithFormat:@"%d like %d comment", [[item objectForKey:@"like_cnt"] intValue], [[item objectForKey:@"comment_cnt"] intValue]];
            }
            else {
                eventCount.text = [NSString stringWithFormat:@"%d like %d comments", [[item objectForKey:@"like_cnt"] intValue], [[item objectForKey:@"comment_cnt"] intValue]];
            }
        }
        else {
            if ([[item objectForKey:@"comment_cnt"] intValue] <= 1) {
                eventCount.text = [NSString stringWithFormat:@"%d likes %d comment", [[item objectForKey:@"like_cnt"] intValue], [[item objectForKey:@"comment_cnt"] intValue]];
            }
            else {
                eventCount.text = [NSString stringWithFormat:@"%d likes %d comments", [[item objectForKey:@"like_cnt"] intValue], [[item objectForKey:@"comment_cnt"] intValue]];
            }
        }
    }
    else { // flag == USER
        
        NSLog(@"%lu", (unsigned long)[userList count]);
        
        // Display items
        NSMutableDictionary *item       = [userList objectAtIndex:indexPath.row];
        UIImageView *userImage          = (UIImageView *)[cell viewWithTag:100];
        UILabel *userDescription        = (UILabel *)[cell viewWithTag:101];
        UILabel *userCount              = (UILabel *)[cell viewWithTag:102];
        UIImageView *userBadge          = (UIImageView *)[cell viewWithTag:103];
        
        // userImage
        [userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [item objectForKey:@"user_image"]]]];
        userImage.layer.cornerRadius = userImage.frame.size.width / 2;
        userImage.clipsToBounds = YES;
        
        // user name
        userDescription.text = [item objectForKey:@"user_name"];
        
        // user activity
        if ([[item objectForKey:@"total_cnt"] intValue] <= 1) {
            if ([[item objectForKey:@"photo_cnt"] intValue] <= 1) {
                userCount.text = [NSString stringWithFormat:@"%d activity (%d photo)", [[item objectForKey:@"total_cnt"] intValue], [[item objectForKey:@"photo_cnt"] intValue]];
            }
            else {
                userCount.text = [NSString stringWithFormat:@"%d activity (%d photos)", [[item objectForKey:@"total_cnt"] intValue], [[item objectForKey:@"photo_cnt"] intValue]];
            }
            
        }
        else {
            if ([[item objectForKey:@"photo_cnt"] intValue] <= 1) {
                userCount.text = [NSString stringWithFormat:@"%d activities (%d photo)", [[item objectForKey:@"total_cnt"] intValue], [[item objectForKey:@"photo_cnt"] intValue]];
            }
            else {
                userCount.text = [NSString stringWithFormat:@"%d activities (%d photos)", [[item objectForKey:@"total_cnt"] intValue], [[item objectForKey:@"photo_cnt"] intValue]];
            }
        }
        
        if (indexPath.row == 0) {
            [userBadge setHidden:NO];
            [userBadge setImage:[UIImage imageNamed:@"medal_gold"]];
        }
        else if (indexPath.row == 1) {
            [userBadge setHidden:NO];
            [userBadge setImage:[UIImage imageNamed:@"medal_silver"]];
        }
        else if (indexPath.row == 2) {
            [userBadge setHidden:NO];
            [userBadge setImage:[UIImage imageNamed:@"medal_bronze"]];
        }
        else {
            [userBadge setHidden:YES];
        }
        
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if(popular_flag == PERFORMANCE) {
        NSMutableDictionary *item = [eventList objectAtIndex:indexPath.row];
        EventDetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EventDetailViewController"];
        [viewController setEventID:[[item objectForKey:@"id"] intValue]];
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
        //[self presentViewController:viewController animated:YES completion:nil];
    }
    else if(popular_flag == USERPHOTO) {
        NSMutableDictionary *item = [photoList objectAtIndex:indexPath.row];
        UserInputDetailedViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserInputDetailedViewController"];
        viewController.hidesBottomBarWhenPushed = YES;
        [viewController setItem:item];
        [self.navigationController pushViewController:viewController animated:YES];
        //[self presentViewController:viewController animated:YES completion:nil];
    }
    else {
        // move to the photo pages
        NSMutableDictionary *item = [userList objectAtIndex:indexPath.row];
        if ([[item objectForKey:@"photo_cnt"] intValue] == 0) {
            UIAlertView *dialog = [[UIAlertView alloc]init];
            [dialog setDelegate:nil];
            [dialog setTitle:@"Message"];
            [dialog setMessage:@"No photos from this user"];
            [dialog addButtonWithTitle:@"OK"];
            [dialog show];
        }
        else {
            NSMutableDictionary *item = [userList objectAtIndex:indexPath.row];
            MyPhotoViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyPhotoViewController"];
            viewController.hidesBottomBarWhenPushed = YES;
            [viewController setUserID:[[item objectForKey:@"user_id"] intValue]];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        
    }
}

- (void) downloadContent {
    
    [indicator startAnimating];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://heounsuk.com/festival/download_events_popular.php" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        if ([[responseObject objectForKey:@"success"]boolValue] == TRUE) {
            jsonArray = [NSMutableArray arrayWithCapacity:0];
            eventList = [NSMutableArray arrayWithCapacity:0];
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
}

- (void) downloadUserContent {
    
    [indicator startAnimating];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://heounsuk.com/festival/download_photos_popular.php" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        if ([[responseObject objectForKey:@"success"]boolValue] == TRUE) {
            jsonArray = [NSMutableArray arrayWithCapacity:0];
            photoList = [NSMutableArray arrayWithCapacity:0];
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
}

- (void) downloadUsers {
    
    [indicator startAnimating];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://heounsuk.com/festival/download_users_popular.php" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        if ([[responseObject objectForKey:@"success"]boolValue] == TRUE) {
            jsonArray = [NSMutableArray arrayWithCapacity:0];
            userList = [NSMutableArray arrayWithCapacity:0];
            [jsonArray addObjectsFromArray:[responseObject objectForKey:@"results"]];
            
            if ([jsonArray count] > 0) {
                // insert new items into table
                for (int i = 0; i < [jsonArray count]; i++) {
                    
                    // get an item
                    NSDictionary *item = [jsonArray objectAtIndex:i];
                    [userList addObject:item];
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
        NSLog(@"Error: %@", error);
    }];
}


/*
-(IBAction)refreshBtnPressed:(id)sender {
    
    if(popular_flag == PERFORMANCE) {
        [self downloadContent];
    }
    else if(popular_flag == USERPHOTO){
        [self downloadUserContent];
    }
    else {
        [self downloadUsers];
    }
}
*/
 
- (IBAction)segmentPressed:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    if (selectedSegment == 0) { // events
        
        popular_flag = PERFORMANCE;
        
        if (eventList.count > 0) {
            [tableViewList reloadData];
        }
        else {
            [self downloadContent];
        }
    }
    else if (selectedSegment == 1){ // user photos
        
        popular_flag = USERPHOTO;
        
        if (photoList.count > 0) {
            [tableViewList reloadData];
        }
        else {
            [self downloadUserContent];
        }
    }
    else { // user
        popular_flag = USER;
        
        if (userList.count > 0) {
            [tableViewList reloadData];
        }
        else {
            [self downloadUsers];
        }
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString: @"UserInputDetailViewController"]) {
        UserInputDetailViewController *viewController = (UserInputDetailViewController *)[segue destinationViewController];
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.eventID = -1;
    }
}

@end
