//
//  UserInputDetailViewController.m
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 3/4/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import "UserInputDetailViewController.h"
#import "AddUserInputViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "AFHTTPRequestOperationManager.h"
#import "UserInputDetailedViewController.h"
#import "JSON.h"

#import "NHLinearPartition.h"
#import "UIImage+Decompression.h"
#import "NHBalancedFlowLayout.h"

@interface UserInputDetailViewController () <NHBalancedFlowLayoutDelegate>

@end

@implementation UserInputDetailViewController

//@synthesize collectionView;
@synthesize photoList, eventID, addContentBtn, indicatorView;

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
    
    //NHBalancedFlowLayout *layout = (NHBalancedFlowLayout *)self.collectionViewLayout;
    //self.collectionView;
    
    [indicatorView startAnimating];
    
    [self downloadContent];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([[userDefault objectForKey:@"reload_view"] isEqualToString:@"true"]) {
        
        // reset reload_view
        [userDefault setObject:@"false" forKey:@"reload_view"];
        
        [self downloadContent];
    }
    else {
        
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.title = @"Details";
    self.navigationItem.backBarButtonItem.title = @"Back";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewFlowLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(NHBalancedFlowLayout *)collectionViewLayout preferredSizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [[photoList objectAtIndex:indexPath.item] size];
}

#pragma mark - UICollectionView data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return [photoList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSMutableDictionary *item = [photoList objectAtIndex:indexPath.row];
    UIImageView *userImage  = (UIImageView *)[cell viewWithTag:100];
    UILabel *likeCnt        = (UILabel *)[cell viewWithTag:101];
    
    NSLog(@"%@", [item objectForKey:@"image"]);
    
    // display the number of likes and comments
    likeCnt.text = [NSString stringWithFormat:@"%d like(s), %lu comment(s)", [[item objectForKey:@"like_cnt"] intValue], (unsigned long)[[item objectForKey:@"user_comments_array"] count]];
    
    /**
     * Decompress image on background thread before displaying it to prevent lag
     */
    NSInteger rowIndex = indexPath.row;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexPath *currentIndexPathForCell = [collectionView indexPathForCell:cell];
            if (currentIndexPathForCell.row == rowIndex) {
                [userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [item objectForKey:@"image_url"]]]];
                userImage.layer.cornerRadius = 5.0f;
                userImage.clipsToBounds = YES;
            }
        });
    });
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *item = [photoList objectAtIndex:indexPath.row];
    
    //[self performSegueWithIdentifier:@"EventDetailViewController" sender:item];
    
    UserInputDetailedViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserInputDetailedViewController"];
    viewController.hidesBottomBarWhenPushed = YES;
    [viewController setItem:item];
    [self.navigationController pushViewController:viewController animated:YES];
    //[self presentViewController:viewController animated:YES completion:nil];

}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    /*
    if ([[segue identifier] isEqualToString: @"AddUserInputViewController"]) {
        AddUserInputViewController *viewController = (AddUserInputViewController *)[segue destinationViewController];
        viewController.eventID = eventID;
    }
    */
}

- (void) downloadContent {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user_id"     :[userDefault objectForKey:@"user_id"],
                             @"event_id"    :[NSString stringWithFormat:@"%d", eventID]};
    
    [manager POST:@"http://heounsuk.com/festival/download_event_user_images.php" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        
        if ([[responseObject objectForKey:@"success"]boolValue] == TRUE) {
            photoList = [NSMutableArray arrayWithCapacity:0];
            [photoList addObjectsFromArray:[responseObject objectForKey:@"results"]];
            
            [self.collectionView reloadData];
            
            //[collectionView reloadData];
            
            [indicatorView stopAnimating];
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
        NSLog(@"operation : %@", operation.responseString);
        NSLog(@"Error: %@", error);
    }];
}


@end
