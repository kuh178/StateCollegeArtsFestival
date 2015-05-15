//
//  MyActivitiesViewController.h
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 3/20/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface MyActivitiesViewController : GAITrackedViewController <UITableViewDelegate, UITableViewDataSource> {
    
    NSMutableArray              *myList;
    NSMutableArray              *jsonArray;
    
    IBOutlet UITableView        *tableViewList;
    IBOutlet UISegmentedControl *myListSegment;
    
    IBOutlet UIBarButtonItem    *refreshBtn;
}

@property (nonatomic, retain) NSMutableArray                *myList;
@property (nonatomic, retain) NSMutableArray                *jsonArray;
@property (nonatomic, retain) IBOutlet UITableView          *tableViewList;
@property (nonatomic, retain) IBOutlet UISegmentedControl   *myListSegment;
@property (nonatomic, retain) IBOutlet UIBarButtonItem      *refreshBtn;

-(IBAction)myListSegmentSelected:(id)sender;
-(IBAction)refreshBtnPressed:(id)sender;

@end
