//
//  SigninViewController.h
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 6/19/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface SigninViewController : GAITrackedViewController <UITextViewDelegate> {
    IBOutlet UITextField *emailText;
    IBOutlet UITextField *passwordText;
    
    IBOutlet UIButton *loginBtn;
    IBOutlet UINavigationBar *topBar;
}

@property (nonatomic, retain)     IBOutlet UITextField *emailText;
@property (nonatomic, retain)     IBOutlet UITextField *passwordText;
@property (nonatomic, retain)     IBOutlet UIButton *loginBtn;
@property (nonatomic, retain)     IBOutlet UINavigationBar *topBar;

-(IBAction)loginBtnPressed:(id)sender;

@end
