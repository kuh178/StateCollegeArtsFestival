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

@synthesize submitBtn, interestBtn1, interestBtn2, interestBtn3, interestBtn4, interestBtn5;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // button rounded corner
    submitBtn.layer.cornerRadius = 5;
    submitBtn.layer.borderWidth = 1;
    
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
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user_id"     :[NSString stringWithFormat:@"%@", [userDefault objectForKey:@"user_id"]],
                             @"interest_1"  :[NSString stringWithFormat:@"%d", interest1],
                             @"interest_2"  :[NSString stringWithFormat:@"%d", interest2],
                             @"interest_3"  :[NSString stringWithFormat:@"%d", interest3],
                             @"interest_4"  :[NSString stringWithFormat:@"%d", interest4],
                             @"interest_5"  :[NSString stringWithFormat:@"%d", interest5]};
    
    [manager POST:@"http://community.ist.psu.edu/Festival/upload_account_preferences.php" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        
        if ([[responseObject objectForKey:@"success"]boolValue] == TRUE) {
            // move to the main page
            UITabBarController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
            [self presentViewController:viewController animated:YES completion:nil];
            [self removeFromParentViewController];
        }
        else {
            UIAlertView *dialog = [[UIAlertView alloc]init];
            [dialog setDelegate:self];
            [dialog setTitle:@"Message"];
            [dialog setMessage:@"Error. Please try again"];
            [dialog addButtonWithTitle:@"OK"];
            [dialog show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
