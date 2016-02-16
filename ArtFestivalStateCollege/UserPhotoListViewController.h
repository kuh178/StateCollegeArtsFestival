//
//  UserPhotoListViewController.h
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 5/4/15.
//  Copyright (c) 2015 Kyungsik Han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface UserPhotoListViewController : GAITrackedViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    NSMutableArray *photoList;
    NSString *username;
    int type;
}

@property (nonatomic, retain) NSMutableArray *photoList;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, assign) int type;

@end
