//
//  ChooseInterestViewController.h
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 4/6/15.
//  Copyright (c) 2015 Kyungsik Han. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseInterestViewController : UIViewController {
    IBOutlet UIButton *submitBtn;
    
    IBOutlet UISegmentedControl *interestBtn1;
    IBOutlet UISegmentedControl *interestBtn2;
    IBOutlet UISegmentedControl *interestBtn3;
    IBOutlet UISegmentedControl *interestBtn4;
    IBOutlet UISegmentedControl *interestBtn5;
    
}

@property (nonatomic, retain) IBOutlet UIButton *submitBtn;
@property (nonatomic, retain) IBOutlet UISegmentedControl *interestBtn1;
@property (nonatomic, retain) IBOutlet UISegmentedControl *interestBtn2;
@property (nonatomic, retain) IBOutlet UISegmentedControl *interestBtn3;
@property (nonatomic, retain) IBOutlet UISegmentedControl *interestBtn4;
@property (nonatomic, retain) IBOutlet UISegmentedControl *interestBtn5;

-(IBAction)submitBtnPressed:(id)sender;

@end
