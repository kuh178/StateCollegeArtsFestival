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
}

@property (nonatomic, retain) IBOutlet UIButton *submitBtn;

-(IBAction)submitBtnPressed:(id)sender;

@end
