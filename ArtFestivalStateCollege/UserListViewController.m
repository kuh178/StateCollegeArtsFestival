//
//  GoingDetailViewController.m
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 3/4/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import "UserListViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AFHTTPRequestOperationManager.h"
#import "NHBalancedFlowLayout.h"
#import "ProfileViewController.h"
#import "JSON.h"

@interface UserListViewController () <NHBalancedFlowLayoutDelegate>

@end

@implementation UserListViewController

@synthesize userList, eventID, type;

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
    
    if (type == 0) {
        self.title = @"Attends";
    }
    else {
        self.title = @"Favorites";
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationItem.backBarButtonItem.title = @"Back";
    [self downloadUserList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Datasource
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(NHBalancedFlowLayout *)collectionViewLayout preferredSizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [[userList objectAtIndex:indexPath.item] size];
}

#pragma mark - UICollectionView data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return [userList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    NSMutableDictionary *item = [userList objectAtIndex:indexPath.row];
    
    UIImageView *userImage  = (UIImageView *)[cell viewWithTag:100];
    UILabel *userName       = (UILabel *)[cell viewWithTag:101];
    
    [userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [item objectForKey:@"user_image"]]]];
    userImage.layer.cornerRadius = userImage.frame.size.width / 2;
    userImage.clipsToBounds = YES;
    userImage.hidden = NO;
    
    userName.text = [item objectForKey:@"user_name"];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *item = [userList objectAtIndex:indexPath.row];
    
    ProfileViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    viewController.hidesBottomBarWhenPushed = YES;
    [viewController setUserID:[[item objectForKey:@"user_id"] intValue]];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void) downloadUserList {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"event_id"    :[NSString stringWithFormat:@"%d", eventID],
                             @"type"        :[NSString stringWithFormat:@"%d", type]};
    
    // change url
    [manager POST:@"http://heounsuk.com/festival/download_user_lists.php" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        
        if([[responseObject objectForKey:@"success"] boolValue] == TRUE) {
            userList = [NSMutableArray arrayWithCapacity:0];
            [userList addObjectsFromArray:[responseObject objectForKey:@"results"]];
            
            [self.collectionView reloadData];
        }
        else {
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


@end
