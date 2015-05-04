//
//  MoreViewController.m
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 3/4/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import "MoreViewController.h"
#import "SocialNewsViewController.h"
#import "FestivalMapViewController.h"
#import "LoginViewController.h"

@interface MoreViewController ()

@end

@implementation MoreViewController
@synthesize logoutBtn;

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
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:59.0/255.0 green:89.0/255.0 blue:162.0/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"MoreViewController";
    self.navigationItem.backBarButtonItem.title = @"Back";
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString: @"SocialNewsViewController"]) {
        SocialNewsViewController *viewController = (SocialNewsViewController *)[segue destinationViewController];
        viewController.hidesBottomBarWhenPushed = YES;
    }
    else if([[segue identifier] isEqualToString: @"FestivalMapViewController"]) {
        FestivalMapViewController *viewController = (FestivalMapViewController *)[segue destinationViewController];
        viewController.hidesBottomBarWhenPushed = YES;
    }
}

- (IBAction)logoutBtnPressed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Proceed to logout?" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Logout", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // Logout
        
        // remove all keys in NSUserDefaults
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSDictionary * dict = [userDefault dictionaryRepresentation];
        for (id key in dict) {
            [userDefault removeObjectForKey:key];
        }
        [userDefault synchronize];
        
        // move to the login page
        
        LoginViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        //[self presentViewController:viewController animated:NO completion:nil];
        viewController.hidesBottomBarWhenPushed = YES;
        [viewController.navigationController setNavigationBarHidden:YES];
        [self.navigationController pushViewController:viewController animated:YES];
        [self removeFromParentViewController];
        // [self.navigationController pushViewController:viewController animated:YES];
        
    }
    else { // Cancel
        
    }
}


@end