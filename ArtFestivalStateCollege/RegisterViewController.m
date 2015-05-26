//
//  RegisterViewController.m
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 6/19/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import "RegisterViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "ChooseInterestViewController.h"
#import "JSON.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

@synthesize usernameText, emailText, passwordText, passwordAgainText, signinBtn, topBar;

#define LOGIN_PAGE 1

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
    
    // make the corner of the buttons round
    signinBtn.layer.cornerRadius = 5;
    signinBtn.layer.borderWidth = 1;
    
    // top bar
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                style:UIBarButtonItemStyleDone target:self action:@selector(leftBarBtnPressed:)];
    leftBtn.tintColor = [UIColor whiteColor];
    
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Register"];
    item.leftBarButtonItem = leftBtn;
    item.hidesBackButton = YES;
    [topBar pushNavigationItem:item animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"RegisterViewController";
    self.navigationItem.backBarButtonItem.title = @"Back";
}

- (void) leftBarBtnPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) uploadMyGoing {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"name"        :usernameText.text,
                             @"email"       :emailText.text,
                             @"password"    :passwordText.text,
                             @"device"      :@"1"};
    
    [manager POST:@"http://heounsuk.com/festival/create_account.php" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        
        if([[responseObject objectForKey:@"success"] boolValue] == TRUE) {
            // move to the main page
            
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:usernameText.text forKey:@"user_name"];
            [userDefault setObject:[responseObject objectForKey:@"user_id"] forKey:@"user_id"];
            [userDefault setObject:[NSString stringWithFormat:@"1"] forKey:@"is_loggedin"]; // 1 means YES; 0 means NO
            [userDefault setObject:[responseObject objectForKey:@"user_image"] forKey:@"user_image"];
            
            // move to the interest selection page
            ChooseInterestViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseInterestViewController"];
            viewController.previousViewController = LOGIN_PAGE;
            [self presentViewController:viewController animated:YES completion:nil];
        }
        else {
            UIAlertView *dialog = [[UIAlertView alloc]init];
            [dialog setDelegate:self];
            [dialog setTitle:@"Message"];
            [dialog setMessage:[responseObject objectForKey:@"message"]];
            [dialog addButtonWithTitle:@"OK"];
            [dialog show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Going"]){ // Going
        
    }
    else {
        
    }
}


-(IBAction)signinBtnPressed:(id)sender {
    
    // check the field
    if (usernameText.text.length == 0) {
        UIAlertView *dialog = [[UIAlertView alloc]init];
        [dialog setDelegate:nil];
        [dialog setTitle:@"Message"];
        [dialog setMessage:@"check your name"];
        [dialog addButtonWithTitle:@"OK"];
        [dialog show];
    }
    if (emailText.text.length == 0) {
        UIAlertView *dialog = [[UIAlertView alloc]init];
        [dialog setDelegate:nil];
        [dialog setTitle:@"Message"];
        [dialog setMessage:@"check your email"];
        [dialog addButtonWithTitle:@"OK"];
        [dialog show];
    }
    else if (![self validEmail:emailText.text]) {
        UIAlertView *dialog = [[UIAlertView alloc]init];
        [dialog setDelegate:nil];
        [dialog setTitle:@"Message"];
        [dialog setMessage:@"check your email format"];
        [dialog addButtonWithTitle:@"OK"];
        [dialog show];
    }
    else if (passwordText.text.length == 0) {
        UIAlertView *dialog = [[UIAlertView alloc]init];
        [dialog setDelegate:nil];
        [dialog setTitle:@"Message"];
        [dialog setMessage:@"check your password"];
        [dialog addButtonWithTitle:@"OK"];
        [dialog show];
    }
    else if (![passwordText.text isEqualToString:passwordAgainText.text]) {
        UIAlertView *dialog = [[UIAlertView alloc]init];
        [dialog setDelegate:nil];
        [dialog setTitle:@"Message"];
        [dialog setMessage:@"passwords do not match"];
        [dialog addButtonWithTitle:@"OK"];
        [dialog show];
    }
    else {
        [self uploadMyGoing];
    }
}

- (BOOL) validEmail:(NSString*) emailString {
    
    if([emailString length]==0){
        return NO;
    }
    
    NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
    
    NSLog(@"%lu", (unsigned long)regExMatches);
    if (regExMatches == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

// It is important for you to hide kwyboard

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
