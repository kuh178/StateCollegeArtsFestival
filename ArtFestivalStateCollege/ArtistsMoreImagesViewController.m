//
//  ArtistsMoreImagesViewController.m
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 6/23/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import "ArtistsMoreImagesViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "UIImage+Decompression.h"
#import "NHBalancedFlowLayout.h"
#import "NHLinearPartition.h"
#import "JSON.h"

@interface ArtistsMoreImagesViewController () <NHBalancedFlowLayoutDelegate>

@end

@implementation ArtistsMoreImagesViewController

//@synthesize collectionView;
@synthesize photoList;

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
    
    NSLog(@"photoList: %@", photoList);
    
    //NHBalancedFlowLayout *layout = (NHBalancedFlowLayout *)self.collectionViewLayout;
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
    
    //NSMutableDictionary *item = [photoList objectAtIndex:indexPath.row];
    UIImageView *userImage  = (UIImageView *)[cell viewWithTag:100];
    
    /**
     * Decompress image on background thread before displaying it to prevent lag
     */
    NSInteger rowIndex = indexPath.row;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexPath *currentIndexPathForCell = [collectionView indexPathForCell:cell];
            if (currentIndexPathForCell.row == rowIndex) {
                [userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [photoList objectAtIndex:rowIndex]]]];
                userImage.layer.cornerRadius = 5.0f;
                userImage.clipsToBounds = YES;
            }
        });
    });
    
    return cell;
}

@end
