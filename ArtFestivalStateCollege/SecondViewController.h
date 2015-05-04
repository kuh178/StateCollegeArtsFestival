//
//  SecondViewController.h
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 3/4/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface SecondViewController : GAITrackedViewController <UITableViewDelegate, UITableViewDataSource> {
    
    NSMutableArray              *artistList;
    NSMutableArray              *artistBoothList;
    NSMutableArray              *jsonArray;
    
    IBOutlet UITableView        *tableViewList;
    
    IBOutlet UIBarButtonItem    *refreshBtn;
    IBOutlet UISegmentedControl *segmentControl;
}

@property (nonatomic, retain) NSMutableArray                *artistList;
@property (nonatomic, retain) NSMutableArray                *artistBoothList;
@property (nonatomic, retain) NSMutableArray                *jsonArray;
@property (nonatomic, retain) IBOutlet UITableView          *tableViewList;
@property (nonatomic, retain) IBOutlet UIBarButtonItem      *refreshBtn;
@property (nonatomic, retain) IBOutlet UISegmentedControl   *segmentControl;

-(IBAction)refreshBtnPressed:(id)sender;
-(IBAction)segmentPressed:(id)sender;

@end

