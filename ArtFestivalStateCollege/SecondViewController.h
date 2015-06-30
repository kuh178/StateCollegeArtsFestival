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
    
    IBOutlet UIButton           *location1Btn;
    IBOutlet UIButton           *location2Btn;
    IBOutlet UIButton           *location3Btn;
    IBOutlet UIButton           *location4Btn;
    IBOutlet UIButton           *location5Btn;
    IBOutlet UIButton           *location6Btn;
    
    IBOutlet UIBarButtonItem    *refreshBtn;
}

@property (nonatomic, retain) NSMutableArray                *artistList;
@property (nonatomic, retain) NSMutableArray                *artistBoothList;
@property (nonatomic, retain) NSMutableArray                *jsonArray;
@property (nonatomic, retain) IBOutlet UITableView          *tableViewList;
@property (nonatomic, retain) IBOutlet UIBarButtonItem      *refreshBtn;

@property (nonatomic, retain) IBOutlet UIButton             *location1Btn;
@property (nonatomic, retain) IBOutlet UIButton             *location2Btn;
@property (nonatomic, retain) IBOutlet UIButton             *location3Btn;
@property (nonatomic, retain) IBOutlet UIButton             *location4Btn;
@property (nonatomic, retain) IBOutlet UIButton             *location5Btn;
@property (nonatomic, retain) IBOutlet UIButton             *location6Btn;

-(IBAction)refreshBtnPressed:(id)sender;
-(IBAction)location1BtnPressed:(id)sender;
-(IBAction)location2BtnPressed:(id)sender;
-(IBAction)location3BtnPressed:(id)sender;
-(IBAction)location4BtnPressed:(id)sender;
-(IBAction)location5BtnPressed:(id)sender;
-(IBAction)location6BtnPressed:(id)sender;

@end

