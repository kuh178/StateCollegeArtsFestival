//
//  ArtistsDetailViewController.m
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 3/20/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import "ArtistsDetailViewController.h"
#import "GoingDetailViewController.h"
#import "UserInputDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ArtistsWebPageViewController.h"
#import "ArtistsMoreImagesViewController.h"

@interface ArtistsDetailViewController ()

@end

@implementation ArtistsDetailViewController

@synthesize artistImage, artistEmailBtn, artistMoreImageBtn, artistName, artistBooth, artistCategory, artistDescription, artistMap, item;

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
    
    // display information
    artistName.text             = [item objectForKey:@"name"];
    artistDescription.text      = [item objectForKey:@"description"];
    artistBooth.text            = [NSString stringWithFormat:@"(%@)\n%@", [item objectForKey:@"booth"], [item objectForKey:@"location_name"]];
    artistCategory.text         = [item objectForKey:@"discipline_name"];
    
    // hide website button if there's nothing in the string...
    if ([[item objectForKey:@"website"] length] <= 5) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    else {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    // artist image
    NSMutableArray *imageArray = [item objectForKey:@"image_url"];
    [artistImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", imageArray[0]]]];
    artistImage.layer.cornerRadius = 4.0f;
    artistImage.clipsToBounds = YES;
    
    // add a push pin on the map
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake([[item objectForKey:@"latitude"] doubleValue], [[item objectForKey:@"longitude"] doubleValue]);
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:loc];
    //[annotation setTitle:@"Title"]; //You can set the subtitle too
    [artistMap addAnnotation:annotation];
    
    MKCoordinateRegion adjustedRegion = [artistMap regionThatFits:MKCoordinateRegionMakeWithDistance(loc, 500, 500)];
    adjustedRegion.span.longitudeDelta  = 0.01;
    adjustedRegion.span.latitudeDelta  = 0.01;
    [artistMap setRegion:adjustedRegion animated:YES];
    
    artistEmailBtn.layer.borderColor = [[UIColor blackColor] CGColor];
    artistEmailBtn.layer.cornerRadius = 5;
    artistEmailBtn.layer.borderWidth = 1;
    
    artistMoreImageBtn.layer.borderColor = [[UIColor blackColor] CGColor];
    artistMoreImageBtn.layer.cornerRadius = 5;
    artistMoreImageBtn.layer.borderWidth = 1;
    
    artistMap.layer.borderColor = [[UIColor grayColor] CGColor];
    artistMap.layer.cornerRadius = 5;
    artistMap.layer.borderWidth = 1;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"ArtistsDetailViewController";
    self.navigationItem.backBarButtonItem.title = @"Back";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)artistGoingBtnPressed:(id)sender {
    
}

- (IBAction)artistUserInputBtnPressed:(id)sender {
    
}

- (IBAction)artistEmailBtnPressed:(id)sender {
    NSString *recipients = [NSString stringWithFormat:@"mailto:%@", [item objectForKey:@"email"]];
    NSString *body = @"";
    
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString: @"ArtistsWebPageViewController"]) {
        ArtistsWebPageViewController *viewController = (ArtistsWebPageViewController *)[segue destinationViewController];
        viewController.hidesBottomBarWhenPushed = YES;
        [viewController setWebLink:[item objectForKey:@"website"]];
    }
    else if ([[segue identifier] isEqualToString: @"ArtistsMoreImagesViewController"]) {
        ArtistsMoreImagesViewController *viewController = (ArtistsMoreImagesViewController *)[segue destinationViewController];
        viewController.hidesBottomBarWhenPushed = YES;
        
        NSMutableArray *photoArray = [[NSMutableArray alloc]initWithCapacity:0];
        [photoArray addObjectsFromArray:[item objectForKey:@"image_url"]];
        
        [viewController setPhotoList:photoArray];
    }
}

@end
