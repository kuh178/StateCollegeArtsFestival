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

@synthesize artistList, artistBoothList, jsonArray, tableViewList, refreshBtn, location1Btn, location2Btn, location3Btn, location4Btn, location5Btn, location6Btn;

NSString *booth_flag = @"A";

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:51.0/255.0 green:164.0/255.0 blue:192.0/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    self.title = @"Allen Street (A)";
    
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
    
    NSLog(@"%@", imageArr[0]);
    
    // plan image
    [artistImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", imageArr[0]]]];
    artistImage.layer.cornerRadius = artistImage.frame.size.width / 2;
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
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    indicator.center = self.view.center;
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    
    [indicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:@"http://heounsuk.com/festival/download_artists.php" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                    if ([[[item objectForKey:@"booth"] substringToIndex:1] isEqualToString:booth_flag]) {
                        [artistBoothList addObject:item];
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
            // ui update
        });
    });

}

-(IBAction)refreshBtnPressed:(id)sender {
    [self downloadContent];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   if ([[segue identifier] isEqualToString: @"UserInputDetailViewController"]) {
        UserInputDetailViewController *viewController = (UserInputDetailViewController *)[segue destinationViewController];
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.eventID = -1;
    }
}

- (void) updateArtist {
    artistBoothList = [NSMutableArray arrayWithCapacity:0];
    
    // get the items based on the day
    for (int i = 0 ; i < [artistList count] ; i++) {
        
        NSMutableDictionary *item = [artistList objectAtIndex:i];
        
        if ([[[item objectForKey:@"booth"] substringToIndex:1] isEqualToString:booth_flag]) {
            [artistBoothList addObject:item];
        }
    }
    
    [tableViewList reloadData];
}


-(IBAction)location1BtnPressed:(id)sender {
    booth_flag = @"A";
    self.title = @"Allen Street (A)";
    
    [self updateArtist];
}

-(IBAction)location2BtnPressed:(id)sender {
    booth_flag = @"O";
    self.title = @"Fairmount Ave (O)";
    
    [self updateArtist];
}

-(IBAction)location3BtnPressed:(id)sender {
    booth_flag = @"R";
    self.title = @"Fraser Street (R)";
    
    [self updateArtist];
}

-(IBAction)location4BtnPressed:(id)sender {
    booth_flag = @"M";
    self.title = @"Old Main Mall (M)";
    
    [self updateArtist];
}

-(IBAction)location5BtnPressed:(id)sender {
    booth_flag = @"P";
    self.title = @"Pollock Road (P)";
    
    [self updateArtist];
}

-(IBAction)location6BtnPressed:(id)sender {
    booth_flag = @"B";
    self.title = @"Burrows Road (B)";
    
    [self updateArtist];
}


@end
