//
//  SocialNewsViewController.m
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 3/20/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import "SocialNewsViewController.h"
#import "JSON.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "EventDetailViewController.h"
#import "AFHTTPRequestOperationManager.h"

@interface SocialNewsViewController ()

@end

@implementation SocialNewsViewController

@synthesize newsList, jsonArray, tableViewList;

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
	// Do any additional setup after loading the view, typically from a nib.
    
    [self downloadContent];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"SocialNewsViewController";
    self.navigationItem.backBarButtonItem.title = @"Back";
}

// Table view property
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [newsList count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Display items
    NSMutableDictionary *item   = [newsList objectAtIndex:indexPath.row];
    UIImageView *tweetImage     = (UIImageView *)[cell viewWithTag:100];
    UITextView *tweetText       = (UITextView *)[cell viewWithTag:101];
    
    // plan image
    [tweetImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [item objectForKey:@"profile_image"]]]];
    tweetImage.layer.cornerRadius = 4.0f;
    tweetImage.clipsToBounds = YES;
    
    // plan question
    tweetText.text = [item objectForKey:@"message"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSMutableDictionary *item = [newsList objectAtIndex:indexPath.row];
    
    //[self performSegueWithIdentifier:@"EventDetailViewController" sender:item];
    
    //EventDetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EventDetailViewController"];
    //viewController.hidesBottomBarWhenPushed = YES;
    //[viewController setItem:item];
    //[self.navigationController pushViewController:viewController animated:YES];
    //[self presentViewController:viewController animated:YES completion:nil];
}

- (void) downloadContent {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://heounsuk.com/festival/download_tweets.php" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        if ([[responseObject objectForKey:@"success"]boolValue] == TRUE) {
            jsonArray = [NSMutableArray arrayWithCapacity:0];
            newsList = [NSMutableArray arrayWithCapacity:0];
            [jsonArray addObjectsFromArray:[responseObject objectForKey:@"results"]];
            
            if ([jsonArray count] > 0) {
                // insert new items into table
                for (int i = 0; i < [jsonArray count]; i++) {
                    
                    // get an item
                    NSDictionary *item = [jsonArray objectAtIndex:i];
                    [newsList addObject:item];
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
        NSLog(@"Error: %@", error);
    }];
}

@end
