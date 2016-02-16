//
//  UserAttendViewController.h
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 7/2/15.
//  Copyright (c) 2015 Kyungsik Han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface UserAttendViewController : GAITrackedViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    NSMutableArray *eventList;
    NSString *username;
}

@property (nonatomic, retain) NSMutableArray *eventList;
@property (nonatomic, retain) NSString *username;

@end

