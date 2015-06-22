//
//  GoingDetailViewController.h
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 3/4/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface UserListViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    
    NSMutableArray *userList;
    int eventID;
    int type; // 0: attend, 1: favorite
}

@property (nonatomic, retain) NSMutableArray *userList;

@property (nonatomic, assign) int eventID;
@property (nonatomic, assign) int type;

@end
