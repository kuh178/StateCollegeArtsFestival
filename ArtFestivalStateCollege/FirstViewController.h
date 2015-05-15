//
//  FirstViewController.h
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 3/4/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface FirstViewController : GAITrackedViewController <UITableViewDelegate, UITableViewDataSource> {
    
    NSMutableArray              *eventList;
    NSMutableArray              *eventListDay;
    NSMutableArray              *jsonArray;
    
    IBOutlet UITableView        *tableViewList;
    IBOutlet UIBarButtonItem    *refreshBtn;
    IBOutlet UIBarButtonItem    *cameraBtn;
    IBOutlet UISegmentedControl *segmentControl;
}

@property (nonatomic, retain) NSMutableArray                *eventList;
@property (nonatomic, retain) NSMutableArray                *eventListDay;
@property (nonatomic, retain) NSMutableArray                *jsonArray;

@property (nonatomic, retain) IBOutlet UITableView          *tableViewList;
@property (nonatomic, retain) IBOutlet UIBarButtonItem      *refreshBtn;
@property (nonatomic, retain) IBOutlet UIBarButtonItem      *cameraBtn;
@property (nonatomic, retain) IBOutlet UISegmentedControl   *segmentControl;

-(IBAction)refreshBtnPressed:(id)sender;
-(IBAction)segmentPressed:(id)sender;

@end
