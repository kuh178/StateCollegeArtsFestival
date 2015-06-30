//
//  MyActivityQuestionViewController.h
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 5/25/15.
//  Copyright (c) 2015 Kyungsik Han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface MyActivityQuestionViewController : GAITrackedViewController <UITextViewDelegate> {
    IBOutlet UILabel                *questionMainLabel;
    IBOutlet UILabel                *question1Label;
    IBOutlet UILabel                *question2Label;
    IBOutlet UILabel                *question3Label;
    IBOutlet UILabel                *question4Label;
    
    IBOutlet UISegmentedControl     *segmentQuestion1;
    IBOutlet UISegmentedControl     *segmentQuestion2;
    IBOutlet UISegmentedControl     *segmentQuestion3;
    IBOutlet UISegmentedControl     *segmentQuestion4;
    IBOutlet UIButton               *submitBtn;
    
    int surveyID;
    NSArray *qAry;
    NSString *qMainQuestion;
}

@property (nonatomic, retain) IBOutlet UILabel                *questionMainLabel;
@property (nonatomic, retain) IBOutlet UILabel                *question1Label;
@property (nonatomic, retain) IBOutlet UILabel                *question2Label;
@property (nonatomic, retain) IBOutlet UILabel                *question3Label;
@property (nonatomic, retain) IBOutlet UILabel                *question4Label;

@property (nonatomic, retain) IBOutlet UISegmentedControl     *segmentQuestion1;
@property (nonatomic, retain) IBOutlet UISegmentedControl     *segmentQuestion2;
@property (nonatomic, retain) IBOutlet UISegmentedControl     *segmentQuestion3;
@property (nonatomic, retain) IBOutlet UISegmentedControl     *segmentQuestion4;
@property (nonatomic, retain) IBOutlet UIButton               *submitBtn;
@property (nonatomic, assign) int surveyID;
@property (nonatomic, retain) NSArray *qAry;
@property (nonatomic, retain) NSString *qMainQuestion;

-(IBAction)submitBtnPressed:(id)sender;

@end
