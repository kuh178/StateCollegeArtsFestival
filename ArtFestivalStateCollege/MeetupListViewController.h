//
//  MeetupListViewController.h
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 5/4/15.
//  Copyright (c) 2015 Kyungsik Han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface MeetupListViewController : GAITrackedViewController <UITableViewDelegate, UITableViewDataSource> {
    
    NSMutableArray              *eventList;
    IBOutlet UITableView        *tableViewList;
    IBOutlet UIBarButtonItem    *refreshBtn;
    IBOutlet UISegmentedControl *filterSegment;
}

@property (nonatomic, retain) NSMutableArray                *eventList;
@property (nonatomic, retain) IBOutlet UITableView          *tableViewList;
@property (nonatomic, retain) IBOutlet UIBarButtonItem      *refreshBtn;
@property (nonatomic, retain) IBOutlet UISegmentedControl   *filterSegment;

-(IBAction)refreshBtnPressed:(id)sender;
-(IBAction)filterSegmentSelected:(id)sender;

@end

