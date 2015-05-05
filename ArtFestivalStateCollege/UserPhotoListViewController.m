//
//  UserPhotoListViewController.m
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 5/4/15.
//  Copyright (c) 2015 Kyungsik Han. All rights reserved.
//

#import "UserPhotoListViewController.h"
#import "NHLinearPartition.h"
#import "UIImage+Decompression.h"
#import "NHBalancedFlowLayout.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AFHTTPRequestOperationManager.h"
#import "UserInputDetailedViewController.h"

@interface UserPhotoListViewController () <NHBalancedFlowLayoutDelegate>

@end

@implementation UserPhotoListViewController

@synthesize photoList, username;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [NSString stringWithFormat:@"%@'s photos", username];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"UserPhotoListViewController";
    self.navigationItem.backBarButtonItem.title = @"Back";
    
    if ([photoList count] == 0) {
        UIAlertView *dialog = [[UIAlertView alloc]init];
        [dialog setDelegate:nil];
        [dialog setTitle:@"Message"];
        [dialog setMessage:@"No photos"];
        [dialog addButtonWithTitle:@"Close"];
        [dialog show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    
    // display the number of likes
    likeCnt.text = [NSString stringWithFormat:@"%d like(s)", [[item objectForKey:@"like_cnt"] intValue]];
    
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

@end
