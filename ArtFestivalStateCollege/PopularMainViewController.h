//
//  PopularMainViewController.h
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 6/17/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface PopularMainViewController : GAITrackedViewController <UITableViewDelegate, UITableViewDataSource> {
    
    NSMutableArray              *eventList;
    NSMutableArray              *photoList;
    NSMutableArray              *userList;
    
    NSMutableArray              *jsonArray;
    
    IBOutlet UITableView        *tableViewList;
    
    //IBOutlet UIBarButtonItem    *refreshBtn;
    
    IBOutlet UISegmentedControl *segmentControl;
}

@property (nonatomic, retain) NSMutableArray                *eventList;
@property (nonatomic, retain) NSMutableArray                *photoList;
@property (nonatomic, retain) NSMutableArray                *userList;

@property (nonatomic, retain) NSMutableArray                *jsonArray;
@property (nonatomic, retain) IBOutlet UITableView          *tableViewList;

//@property (nonatomic, retain) IBOutlet UIBarButtonItem      *refreshBtn;

@property (nonatomic, retain) IBOutlet UISegmentedControl   *segmentControl;

//-(IBAction)refreshBtnPressed:(id)sender;
-(IBAction)segmentPressed:(id)sender;

@end
