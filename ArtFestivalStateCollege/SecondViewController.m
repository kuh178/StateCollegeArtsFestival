//
//  SecondViewController.m
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 3/4/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import "SecondViewController.h"
#import "JSON.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ArtistsDetailViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "UserInputDetailViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

@synthesize artistList, artistBoothList, jsonArray, tableViewList, refreshBtn, segmentControl;

NSString *booth_flag = @"A";

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:59.0/255.0 green:89.0/255.0 blue:152.0/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
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
    self.screenName = @"SecondViewController";
    self.navigationItem.backBarButtonItem.title = @"Back";
}

// Table view property
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"number of rows : %lu", (unsigned long)[artistBoothList count]);
    
    return [artistBoothList count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Display items
    NSMutableDictionary *item    = [artistBoothList objectAtIndex:indexPath.row];
    UIImageView *artistImage     = (UIImageView *)[cell viewWithTag:100];
    UILabel *artistName          = (UILabel *)[cell viewWithTag:101];
    UILabel *artistBooth         = (UILabel *)[cell viewWithTag:102];
    
    NSMutableArray *imageArr     = [item objectForKey:@"image_url"];
    
    // plan image
    [artistImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", imageArr[0]]]];
    artistImage.layer.cornerRadius = 4.0f;
    artistImage.clipsToBounds = YES;
    
    artistBooth.text = [item objectForKey:@"booth"];
    
    // plan question
    artistName.text = [item objectForKey:@"name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *item = [artistBoothList objectAtIndex:indexPath.row];
    
    ArtistsDetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ArtistsDetailViewController"];
    viewController.hidesBottomBarWhenPushed = YES;
    [viewController setItem:item];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void) downloadContent {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://community.ist.psu.edu/Festival/download_artists.php" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        if ([[responseObject objectForKey:@"success"]boolValue] == TRUE) {
            jsonArray = [NSMutableArray arrayWithCapacity:0];
            artistList = [NSMutableArray arrayWithCapacity:0];
            artistBoothList = [NSMutableArray arrayWithCapacity:0];
            [jsonArray addObjectsFromArray:[responseObject objectForKey:@"results"]];
            
            if ([jsonArray count] > 0) {
                // insert new items into table
                for (int i = 0; i < [jsonArray count]; i++) {
                    
                    // get an item
                    NSDictionary *item = [jsonArray objectAtIndex:i];
                    [artistList addObject:item];
                }
            }
            else {
                NSLog(@"No data available");
            }
            
            
            for(int i = 0 ; i < [artistList count] ; i++) {
                NSMutableDictionary *item = [artistList objectAtIndex:i];
                if ([[[item objectForKey:@"booth"] substringToIndex:1] isEqualToString:@"A"]) {
                    [artistBoothList addObject:item];
                }
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
        NSLog(@"Error: %@", error);
    }];
}

-(IBAction)refreshBtnPressed:(id)sender {
    [self downloadContent];
}

-(IBAction)segmentPressed:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    artistBoothList = [NSMutableArray arrayWithCapacity:0];
    
    if (selectedSegment == 0) { // A
        booth_flag = @"A";
    }
    else if (selectedSegment == 1){ // B
        booth_flag = @"B";
    }
    else if (selectedSegment == 2){ // M
        booth_flag = @"M";
    }
    else if (selectedSegment == 3){ // O
        booth_flag = @"O";
    }
    else if (selectedSegment == 4){ // P
        booth_flag = @"P";
    }
    else if (selectedSegment == 5) { // R
        booth_flag = @"R";
    }
    
    
    // get the items based on the day
    for (int i = 0 ; i < [artistList count] ; i++) {
        
        NSMutableDictionary *item = [artistList objectAtIndex:i];
        
        if ([[[item objectForKey:@"booth"] substringToIndex:1] isEqualToString:booth_flag]) {
            [artistBoothList addObject:item];
        }

    }
    
    [tableViewList reloadData];
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