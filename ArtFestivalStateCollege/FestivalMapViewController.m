//
//  FestivalMapViewController.m
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 4/6/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import "FestivalMapViewController.h"

@interface FestivalMapViewController ()

@end

@implementation FestivalMapViewController

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
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"FestivalMapViewController";
    self.navigationItem.backBarButtonItem.title = @"Back";
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
