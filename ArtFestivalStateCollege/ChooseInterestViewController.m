//
//  ChooseInterestViewController.m
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 4/6/15.
//  Copyright (c) 2015 Kyungsik Han. All rights reserved.
//

#import "ChooseInterestViewController.h"

@interface ChooseInterestViewController ()

@end

@implementation ChooseInterestViewController

@synthesize submitBtn;

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
    
    // move to the main page
    UITabBarController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
    [self presentViewController:viewController animated:YES completion:nil];
    [self removeFromParentViewController];
}

@end
