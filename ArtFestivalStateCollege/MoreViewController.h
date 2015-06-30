//
//  MoreViewController.h
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 3/4/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface MoreViewController : GAITrackedViewController {
    IBOutlet UIButton *logoutBtn;
    
    IBOutlet UIButton *homepageBtn;
    
    IBOutlet UIButton *event1Btn;
    IBOutlet UIButton *event2Btn;
    IBOutlet UIButton *event3Btn;
    IBOutlet UIButton *event4Btn;
}

@property (nonatomic, retain) IBOutlet UIButton *logoutBtn;
@property (nonatomic, retain) IBOutlet UIButton *homepageBtn;
@property (nonatomic, retain) IBOutlet UIButton *event1Btn;
@property (nonatomic, retain) IBOutlet UIButton *event2Btn;
@property (nonatomic, retain) IBOutlet UIButton *event3Btn;
@property (nonatomic, retain) IBOutlet UIButton *event4Btn;

- (IBAction)logoutBtnPressed:(id)sender;

- (IBAction)homepageBtnPressed:(id)sender;
- (IBAction)event1BtnPressed:(id)sender;
- (IBAction)event2BtnPressed:(id)sender;
- (IBAction)event3BtnPressed:(id)sender;
- (IBAction)event4BtnPressed:(id)sender;

@end
