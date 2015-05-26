//
//  LoginViewController.m
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 3/15/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import "RegisterViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SigninViewController.h"
#import "LoginViewController.h"
#import "ChooseInterestViewController.h"
#import "AppDelegate.h"
#import "JSON.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize facebookBtn, createAccountBtn, loginBtn;

#define LOGIN_PAGE 1

NSString *userName, *userImage, *userEmail, *datetime;
NSUserDefaults *userDefault;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.hidden = YES;
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    
    // NSUserDefaults
    userDefault = [NSUserDefaults standardUserDefaults];
    NSLog(@"device token: %@", [userDefault objectForKey:@"device_token"]);
    
    // make the corner of the buttons round
    facebookBtn.layer.cornerRadius = 5;
    facebookBtn.layer.borderWidth = 1;
    
    createAccountBtn.layer.cornerRadius = 5;
    createAccountBtn.layer.borderWidth = 1;
    
    loginBtn.layer.cornerRadius = 5;
    loginBtn.layer.borderWidth = 1;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.screenName = @"LoginViewController";
    self.navigationItem.backBarButtonItem.title = @"Back";
    
    NSLog(@"logged in? %@", [userDefault objectForKey:@"is_loggedin"]);
    
    // if not logged in, move to the login page
    if ([[userDefault objectForKey:@"is_loggedin"] intValue] == 1) {
        
        NSLog(@"logged in? %@", [userDefault objectForKey:@"is_loggedin"]);
        
        UITabBarController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
        [self presentViewController:viewController animated:YES completion:nil];
        [self removeFromParentViewController];
    }
    else {
        /*
        AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
        if (!appDelegate.session.isOpen) {
            // create a fresh session object
            appDelegate.session = [[FBSession alloc] init];
            
            // if we don't have a cached token, a call to open here would cause UX for login to
            // occur; we don't want that to happen unless the user clicks the login button, and so
            // we check here to make sure we have a token before calling open
            if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
                // even though we had a cached token, we need to login to make the session usable
                [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                                 FBSessionState status,
                                                                 NSError *error) {
                }];
            }
        }
        */
        
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)facebookBtnPressed:(id)sender {
    
    // get the app delegate so that we can access the session property
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"email", @"public_profile"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            // Process error
        } else if (result.isCancelled) {
            // Handle cancellations
        } else {
            
            NSLog(@"%@", result.grantedPermissions);
            
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if ([result.grantedPermissions containsObject:@"email"]) {
                // Do work
            }
            if ([result.grantedPermissions containsObject:@"public_profile"]) {
                // Do work
            }
            
            //FBSDKAccessToken *token = result.token;
            //NSString *tokenString = token.tokenString;
            //NSString *userId = token.userID;

            [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
             startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 if (!error) {
                     NSLog(@"fetched user:%@", result);

                     userName = [NSString stringWithFormat:@"%@", [result objectForKey:@"name"]];
                     userImage = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", [result objectForKey:@"id"]];
                     userEmail = [NSString stringWithFormat:@"%@", [result objectForKey:@"email"]];
                     
                     [self uploadAccountInfo];

                 }
             }];
        }
    }];
    
    /*
    // this button's job is to flip-flop the session from open to closed
    if (appDelegate.session.isOpen) {
        // if a user logs out explicitly, we delete any cached token information, and next
        // time they run the applicaiton they will be presented with log in UX again; most
        // users will simply close the app or switch away, without logging out; this will
        // cause the implicit cached-token login to occur on next launch of the application
        [appDelegate.session closeAndClearTokenInformation];
        
    } else {
        
        NSArray *permissions = [[NSArray alloc] initWithObjects:@"email", @"basic_info", nil];
        appDelegate.session = [[FBSession alloc] initWithPermissions:permissions];
        
        [FBSession setActiveSession:appDelegate.session];
        
        [FBSession openActiveSessionWithReadPermissions:permissions allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            
            if (!error) {
                FBRequest *me  = [FBRequest requestForMe];
                
                // it is VERY IMPORTANT to set the session on the request after logging in
                // ref: http://stackoverflow.com/questions/13483391/why-cant-i-access-the-facebook-friends-list-after-reopening-a-session-in-ios
                me.session = appDelegate.session;
                
                [me startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                    
                    if(!error) {
                        NSDictionary<FBGraphUser> *my = (NSDictionary<FBGraphUser> *) result;
                        NSLog(@"My dictionary: %@", my);
                        
                        userName = my.name;
                        userImage = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", my.id];
                        userEmail = [my objectForKey:@"email"];
                        
                        [self uploadAccountInfo];
                    }
                }];
            }
        }];
    }
     */
}

- (void) uploadAccountInfo {
    
    NSString *timeStampValue = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];

    NSLog(@"device token: %@", [userDefault objectForKey:@"device_token"]);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user_name"     :[NSString stringWithFormat:@"%@", userName],
                             @"user_image"    :[NSString stringWithFormat:@"%@", userImage],
                             @"user_email"    :[NSString stringWithFormat:@"%@", userEmail],
                             @"datetime"      :[NSString stringWithFormat:@"%@", timeStampValue],
                             @"device_token"  :[NSString stringWithFormat:@"%@", [userDefault objectForKey:@"device_token"]],
                             @"platform"      :[NSString stringWithFormat:@"1"]};
    
    [manager POST:@"http://heounsuk.com/festival/upload_account_info.php" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        
        if ([[responseObject objectForKey:@"success"]boolValue] == TRUE) {
            
            [userDefault setObject:userName forKey:@"user_name"];
            [userDefault setObject:[responseObject objectForKey:@"message"] forKey:@"user_id"];
            [userDefault setObject:[NSString stringWithFormat:@"1"] forKey:@"is_loggedin"]; // 1 means YES; 0 means NO
            [userDefault setObject:userImage forKey:@"user_image"];
            [userDefault synchronize];
            
            // move to the interest selection page
            ChooseInterestViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseInterestViewController"];
            viewController.previousViewController = LOGIN_PAGE;
            [self presentViewController:viewController animated:YES completion:nil];
            
        }
        else {
            UIAlertView *dialog = [[UIAlertView alloc]init];
            [dialog setDelegate:self];
            [dialog setTitle:@"Message"];
            [dialog setMessage:@"Error while logging in"];
            [dialog addButtonWithTitle:@"OK"];
            [dialog show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (IBAction)registerBtnPressed:(id)sender {
    RegisterViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    [self presentViewController:viewController animated:YES completion:nil];

}

- (IBAction)loginBtnPressed:(id)sender {
    SigninViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SigninViewController"];
    [self presentViewController:viewController animated:YES completion:nil];

}

@end
