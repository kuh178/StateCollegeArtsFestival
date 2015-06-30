//
//  CommunityConnectionQuestionsViewController.h
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 6/23/15.
//  Copyright (c) 2015 Kyungsik Han. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommunityConnectionQuestionsViewController : UIViewController {
    IBOutlet UIButton *submitBtn;
    IBOutlet UISegmentedControl *answer1Segment;
    IBOutlet UISegmentedControl *answer2Segment;
    IBOutlet UISegmentedControl *answer3Segment;
    
    int interest1;
    int interest2;
    int interest3;
    int interest4;
    int interest5;
    int interest6;
    int interest7;
    NSString *gender;
    int age;
}

@property (nonatomic, retain) IBOutlet UIButton *submitBtn;
@property (nonatomic, retain) IBOutlet UISegmentedControl *answer1Segment;
@property (nonatomic, retain) IBOutlet UISegmentedControl *answer2Segment;
@property (nonatomic, retain) IBOutlet UISegmentedControl *answer3Segment;

@property (nonatomic, assign) int interest1;
@property (nonatomic, assign) int interest2;
@property (nonatomic, assign) int interest3;
@property (nonatomic, assign) int interest4;
@property (nonatomic, assign) int interest5;
@property (nonatomic, assign) int interest6;
@property (nonatomic, assign) int interest7;
@property (nonatomic, retain) NSString *gender;
@property (nonatomic, assign) int age;

- (IBAction)submitBtnPressed:(id)sender;

@end
