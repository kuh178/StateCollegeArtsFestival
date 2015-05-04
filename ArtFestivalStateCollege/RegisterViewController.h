//
//  RegisterViewController.h
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 6/19/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface RegisterViewController : GAITrackedViewController <UITextViewDelegate> {
    IBOutlet UITextField *usernameText;
    IBOutlet UITextField *emailText;
    IBOutlet UITextField *passwordText;
    IBOutlet UITextField *passwordAgainText;
    
    IBOutlet UIButton *signinBtn;
    IBOutlet UINavigationBar *topBar;
}

@property (nonatomic, retain)     IBOutlet UITextField *usernameText;
@property (nonatomic, retain)     IBOutlet UITextField *emailText;
@property (nonatomic, retain)     IBOutlet UITextField *passwordText;
@property (nonatomic, retain)     IBOutlet UITextField *passwordAgainText;

@property (nonatomic, retain)     IBOutlet UIButton *signinBtn;
@property (nonatomic, retain)     IBOutlet UINavigationBar *topBar;

-(IBAction)signinBtnPressed:(id)sender;

@end
