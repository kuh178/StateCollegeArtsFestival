//
//  GoingDetailViewController.m
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 3/4/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import "GoingDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AFHTTPRequestOperationManager.h"
#import "JSON.h"

@interface GoingDetailViewController ()

@end

@implementation GoingDetailViewController

@synthesize collectionView, userList, goingBtn, eventID;

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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.screenName = @"GoingDetailViewController";
    self.navigationItem.backBarButtonItem.title = @"Back";
    [self downloadEventGoing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return [userList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    NSMutableDictionary *item = [userList objectAtIndex:indexPath.row];
    
    UIImageView *userImage  = (UIImageView *)[cell viewWithTag:100];
    UILabel *userName       = (UILabel *)[cell viewWithTag:101];
    
    [userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [item objectForKey:@"user_image"]]]];
    userImage.layer.cornerRadius = 4.0f;
    userImage.clipsToBounds = YES;
    
    userName.text = [item objectForKey:@"user_name"];
    
    return cell;
}

-(IBAction)goingBtnPressed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Are you going this event?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Going", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Going"]){ // Going
        
    }
    else {
        
    }
}


- (void) downloadEventGoing {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"event_id"    :[NSString stringWithFormat:@"%d", eventID]};
    
    [manager POST:@"http://community.ist.psu.edu/Festival/download_event_going_details.php" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        
        if([[responseObject objectForKey:@"success"] boolValue] == TRUE) {
            userList = [NSMutableArray arrayWithCapacity:0];
            [userList addObjectsFromArray:[responseObject objectForKey:@"results"]];
            
            [collectionView reloadData];
        }
        else {
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


@end
