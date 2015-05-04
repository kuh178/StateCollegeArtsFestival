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
}

@property (nonatomic, retain) IBOutlet UIButton *logoutBtn;

- (IBAction)logoutBtnPressed:(id)sender;

@end
