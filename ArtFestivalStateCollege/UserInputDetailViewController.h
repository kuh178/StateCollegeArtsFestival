//
//  UserInputDetailViewController.h
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 3/4/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInputDetailViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
//    IBOutlet UICollectionView *collectionView;
    IBOutlet UIBarButtonItem            *addContentBtn;
    IBOutlet UIActivityIndicatorView    *indicatorView;
    NSMutableArray *photoList;
    int eventID;
}

//@property (nonatomic, retain) IBOutlet UICollectionView *collectionView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem              *addContentBtn;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView      *indicatorView;
@property (nonatomic, retain) NSMutableArray *photoList;
@property (nonatomic, assign) int eventID;

@end
