//
//  CommunityConnectionQuestionsViewController.m
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 6/23/15.
//  Copyright (c) 2015 Kyungsik Han. All rights reserved.
//

#import "CommunityConnectionQuestionsViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "JSON.h"

@interface CommunityConnectionQuestionsViewController ()

@end

@implementation CommunityConnectionQuestionsViewController

@synthesize submitBtn, answer1Segment, answer2Segment, answer3Segment;
@synthesize interest1, interest2, interest3, interest4, interest5, interest6, interest7, gender, age;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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

- (void) uploadUserInfo:(int)answer1 answer2:(int)answer2 answer3:(int)answer3 {
    
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
                             @"age"         :[NSString stringWithFormat:@"%d", age],
                             @"answer_1"    :[NSString stringWithFormat:@"%d", answer1],
                             @"answer_2"    :[NSString stringWithFormat:@"%d", answer2],
                             @"answer_3"    :[NSString stringWithFormat:@"%d", answer3]};
    
    [manager POST:@"http://heounsuk.com/festival/upload_account_preferences.php" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
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

- (IBAction)submitBtnPressed:(id)sender {
    
    int answer1 = (int)answer1Segment.selectedSegmentIndex;
    int answer2 = (int)answer2Segment.selectedSegmentIndex;
    int answer3 = (int)answer3Segment.selectedSegmentIndex;
    
    [self uploadUserInfo:answer1 answer2:answer2 answer3:answer3];
}

@end
