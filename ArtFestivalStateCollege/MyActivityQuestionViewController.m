//
//  MyActivityQuestionViewController.m
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 5/25/15.
//  Copyright (c) 2015 Kyungsik Han. All rights reserved.
//

#import "MyActivityQuestionViewController.h"
#import "AFHTTPRequestOperationManager.h"

@interface MyActivityQuestionViewController ()

@end

@implementation MyActivityQuestionViewController

@synthesize questionMainLabel, question1Label, question2Label, question3Label, question4Label;
@synthesize segmentQuestion1, segmentQuestion2, segmentQuestion3, segmentQuestion4, submitBtn, surveyID, qAry, qMainQuestion;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // button border
    submitBtn.layer.borderWidth = 1.0;
    submitBtn.layer.cornerRadius = 5;
    
    questionMainLabel.text = qMainQuestion;
    
    question1Label.text = [qAry objectAtIndex:0];
    question2Label.text = [qAry objectAtIndex:1];
    question3Label.text = [qAry objectAtIndex:2];
    question4Label.text = [qAry objectAtIndex:3];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"EventDetailViewController";
    self.title = @"Share feedback";
    self.navigationItem.backBarButtonItem.title = @"Back";
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

- (void)submitAnswers {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *timeStampValue = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
    
    NSLog(@"surveyID: %d", surveyID);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user_id"         :[userDefault objectForKey:@"user_id"],
                             @"survey_id"       :[NSString stringWithFormat:@"%d", surveyID],
                             @"datetime"        :timeStampValue,
                             @"question1"       :[NSString stringWithFormat:@"%d", (int)segmentQuestion1.selectedSegmentIndex+1],
                             @"question2"       :[NSString stringWithFormat:@"%d", (int)segmentQuestion2.selectedSegmentIndex+1],
                             @"question3"       :[NSString stringWithFormat:@"%d", (int)segmentQuestion3.selectedSegmentIndex+1],
                             @"question4"       :[NSString stringWithFormat:@"%d", (int)segmentQuestion4.selectedSegmentIndex+1]};
    
    [manager POST:@"http://heounsuk.com/festival/upload_adhoc_answers.php" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        
        if([[responseObject objectForKey:@"success"] boolValue] == TRUE) {
            
            UIAlertView *dialog = [[UIAlertView alloc]init];
            [dialog setDelegate:nil];
            [dialog setTitle:@"Message"];
            [dialog setMessage:@"Thank you for answering the survey"];
            [dialog addButtonWithTitle:@"Close"];
            [dialog show];
            
            // when succeed, dismiss the current view controller
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Operation: %@, Error: %@", operation, error);
    }];
}

// It is important for you to hide kwyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)submitBtnPressed:(id)sender {
    
    if (segmentQuestion1.selectedSegmentIndex != -1 &&
        segmentQuestion2.selectedSegmentIndex != -1 &&
        segmentQuestion3.selectedSegmentIndex != -1 &&
        segmentQuestion4.selectedSegmentIndex != -1) {
        [self submitAnswers];
    }
    else {
        UIAlertView *dialog = [[UIAlertView alloc]init];
        [dialog setDelegate:nil];
        [dialog setTitle:@"Message"];
        [dialog setMessage:@"Please answer all questions"];
        [dialog addButtonWithTitle:@"OK"];
        [dialog show];
    }
}


@end
