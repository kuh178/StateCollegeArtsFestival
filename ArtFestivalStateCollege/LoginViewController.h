//
//  LoginViewController.h
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 3/15/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface LoginViewController : GAITrackedViewController {
    IBOutlet UIButton *facebookBtn;
    IBOutlet UIButton *createAccountBtn;
    IBOutlet UIButton *loginBtn;
}

@property (nonatomic, retain) IBOutlet UIButton *facebookBtn;
@property (nonatomic, retain) IBOutlet UIButton *createAccountBtn;
@property (nonatomic, retain) IBOutlet UIButton *loginBtn;


- (IBAction)facebookBtnPressed:(id)sender;
- (IBAction)registerBtnPressed:(id)sender;
- (IBAction)loginBtnPressed:(id)sender;

@end
