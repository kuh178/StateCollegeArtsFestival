//
//  GoingDetailViewController.h
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 3/4/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface GoingDetailViewController : GAITrackedViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    
    IBOutlet UICollectionView *collectionView;
    IBOutlet UIBarButtonItem *goingBtn;
    
    NSMutableArray *userList;
    
    int eventID;
}


@property (nonatomic, retain) IBOutlet UICollectionView *collectionView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *goingBtn;
@property (nonatomic, retain) NSMutableArray *userList;

@property (nonatomic, assign) int eventID;

-(IBAction)goingBtnPressed:(id)sender;

@end
