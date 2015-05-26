//
//  ChooseInterestViewController.m
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 4/6/15.
//  Copyright (c) 2015 Kyungsik Han. All rights reserved.
//

#import "ChooseInterestViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "JSON.h"

@interface ChooseInterestViewController ()

@end

@implementation ChooseInterestViewController

@synthesize submitBtn, interestBtn1, interestBtn2, interestBtn3, interestBtn4, interestBtn5, interestBtn6, interestBtn7, ageBtn, genderBtn, previousViewController;

#define LOGIN_PAGE 1
#define PROFILE_PAGE 2

int age;
NSString *gender;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // button rounded corner
    submitBtn.layer.cornerRadius = 5;
    submitBtn.layer.borderWidth = 1;
    
    ageBtn.layer.cornerRadius = 5;
    ageBtn.layer.borderWidth = 1;
    
    genderBtn.layer.cornerRadius = 5;
    genderBtn.layer.borderWidth = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(IBAction)submitBtnPressed:(id)sender {
    [self uploadUserInfo];
}

-(void)uploadUserInfo {
    
    int interest1;
    int interest2;
    int interest3;
    int interest4;
    int interest5;
    int interest6;
    int interest7;
    
    if (interestBtn1.selectedSegmentIndex == 0) {
        interest1 = 1;
    }
    else {
        interest1 = 0;
    }
    
    if (interestBtn2.selectedSegmentIndex == 0) {
        interest2 = 1;
    }
    else {
        interest2 = 0;
    }
    
    if (interestBtn3.selectedSegmentIndex == 0) {
        interest3 = 1;
    }
    else {
        interest3 = 0;
    }
    
    if (interestBtn4.selectedSegmentIndex == 0) {
        interest4 = 1;
    }
    else {
        interest4 = 0;
    }
    
    if (interestBtn5.selectedSegmentIndex == 0) {
        interest5 = 1;
    }
    else {
        interest5 = 0;
    }
    
    if (interestBtn6.selectedSegmentIndex == 0) {
        interest6 = 1;
    }
    else {
        interest6 = 0;
    }
    
    if (interestBtn7.selectedSegmentIndex == 0) {
        interest7 = 1;
    }
    else {
        interest7 = 0;
    }
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user_id"     :[NSString stringWithFormat:@"%@", [userDefault objectForKey:@"user_id"]],
                             @"interest_1"  :[NSString stringWithFormat:@"%d", interest1],
                             @"interest_2"  :[NSString stringWithFormat:@"%d", interest2],
                             @"interest_3"  :[NSString stringWithFormat:@"%d", interest3],
                             @"interest_4"  :[NSString stringWithFormat:@"%d", interest4],
                             @"interest_5"  :[NSString stringWithFormat:@"%d", interest5],
                             @"interest_6"  :[NSString stringWithFormat:@"%d", interest6],
                             @"interest_7"  :[NSString stringWithFormat:@"%d", interest7],
                             @"gender"      :[NSString stringWithFormat:@"%@", gender],
                             @"age"         :[NSString stringWithFormat:@"%d", age]};
    
    [manager POST:@"http://heounsuk.com/festival/upload_account_preferences.php" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        
        if ([[responseObject objectForKey:@"success"]boolValue] == TRUE) {
            
            if (previousViewController == LOGIN_PAGE) {
                // move to the main page
                UITabBarController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
                [self presentViewController:viewController animated:YES completion:nil];
                [self removeFromParentViewController];
            }
            else { // from profile
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
        else {
            UIAlertView *dialog = [[UIAlertView alloc]init];
            [dialog setDelegate:nil];
            [dialog setTitle:@"Message"];
            [dialog setMessage:@"Error. Please try again"];
            [dialog addButtonWithTitle:@"OK"];
            [dialog show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(IBAction)genderBtnPressed:(id)sender {
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Choose your gender" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Male",
                            @"Female",
                            nil];
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
    
}

-(IBAction)ageBtnPressed:(id)sender {
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Choose your age" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"less than 20",
                            @"20s",
                            @"30s",
                            @"40s",
                            @"more than 50",
                            nil];
    popup.tag = 2;
    [popup showInView:[UIApplication sharedApplication].keyWindow];

}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    gender = @"M";
                    [genderBtn setTitle:@"Male" forState:UIControlStateNormal];
                    
                    break;
                case 1:
                    gender = @"F";
                    [genderBtn setTitle:@"Female" forState:UIControlStateNormal];
                    
                    break;
                default:
                    break;
            }
            break;
        }
        case 2: {
            switch (buttonIndex) {
                case 0:
                    age = 10;
                    [ageBtn setTitle:@"10s" forState:UIControlStateNormal];
                    
                    break;
                case 1:
                    age = 20;
                    [ageBtn setTitle:@"20s" forState:UIControlStateNormal];
                    
                    break;
                case 2:
                    age = 30;
                    [ageBtn setTitle:@"30s" forState:UIControlStateNormal];
                    
                    break;
                case 3:
                    age = 40;
                    [ageBtn setTitle:@"40s" forState:UIControlStateNormal];
                    
                    break;
                case 4:
                    age = 50;
                    [ageBtn setTitle:@"More than 50" forState:UIControlStateNormal];
                    
                    break;
                default:
                    break;
            }
        }
        default:
            break;
    }
}

@end
