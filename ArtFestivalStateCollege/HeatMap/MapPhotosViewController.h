//
//  MapPhotosViewController.h
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 6/21/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapPhotosViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    //IBOutlet UIBarButtonItem *addContentBtn;
    NSMutableArray *photoList;
    int userID;
}

//@property (nonatomic, retain) IBOutlet UIBarButtonItem *addContentBtn;
@property (nonatomic, retain) NSMutableArray *photoList;
@property (nonatomic, assign) int userID;

@end
