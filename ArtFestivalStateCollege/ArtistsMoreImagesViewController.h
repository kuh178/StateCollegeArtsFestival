//
//  ArtistsMoreImagesViewController.h
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 6/23/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArtistsMoreImagesViewController :  UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    NSMutableArray *photoList;
}

@property (nonatomic, retain) NSMutableArray *photoList;

@end

