//
//  ArtistsDetailViewController.m
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 3/20/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import "ArtistsDetailViewController.h"
#import "UserListViewController.h"
#import "UserInputDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ArtistsWebPageViewController.h"
#import "ArtistsMoreImagesViewController.h"
#import "AFHTTPRequestOperationManager.h"

@interface ArtistsDetailViewController ()

@end

@implementation ArtistsDetailViewController

@synthesize artistImage, artistFavoriteImage, artistEmailBtn, artistMoreImageBtn, artistName, artistBooth, artistCategory, artistAddress, artistDescription, artistMap, item;
@synthesize view1, view2;
@synthesize artistFavoriteBtn, artistWebPageBtn;

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
    artistAddress.text          = [[item objectForKey:@"description"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    [item objectForKey:@"description"];
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
    
    artistEmailBtn.layer.cornerRadius = 5;
    
    // button rounded corner
    artistUserPhotosBtn.layer.borderColor = [[UIColor blackColor] CGColor];
    artistUserPhotosBtn.layer.borderWidth = 1.0;
    artistUserPhotosBtn.layer.cornerRadius = 5;
    
    artistMoreImageBtn.layer.borderColor = [[UIColor blackColor] CGColor];
    artistMoreImageBtn.layer.borderWidth = 1.0;
    artistMoreImageBtn.layer.cornerRadius = 5;
    
    artistWebPageBtn.layer.borderColor = [[UIColor blackColor] CGColor];
    artistWebPageBtn.layer.borderWidth = 1.0;
    artistWebPageBtn.layer.cornerRadius = 5;
    
    artistFavoriteBtn.layer.borderColor = [[UIColor blackColor] CGColor];
    artistFavoriteBtn.layer.borderWidth = 1.0;
    artistFavoriteBtn.layer.cornerRadius = 5;

    artistMap.layer.borderColor = [[UIColor grayColor] CGColor];
    artistMap.layer.cornerRadius = 5;
    artistMap.layer.borderWidth = 1;
    
    view1.layer.borderColor = [[UIColor grayColor] CGColor];
    view1.layer.cornerRadius = 5;
    view1.layer.borderWidth = 1;
    
    view2.layer.borderColor = [[UIColor grayColor] CGColor];
    view2.layer.cornerRadius = 5;
    view2.layer.borderWidth = 1;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"ArtistsDetailViewController";
    self.navigationItem.backBarButtonItem.title = @"Back";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // load event updates everytime the view is opened
    [self downloadArtistUpdates];
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

- (IBAction)artistFavoriteBtnPressed:(id)sender {
    [self uploadMyFavorite];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSString *currentLatitude = [[NSString alloc]
                                 initWithFormat:@"%+.6f",
                                 newLocation.coordinate.latitude];
    latitude = [currentLatitude doubleValue];
    
    NSString *currentLongitude = [[NSString alloc]
                                  initWithFormat:@"%+.6f",
                                  newLocation.coordinate.longitude];
    longitude = [currentLongitude doubleValue];
    
    if (latitude != 0.0 && longitude != 0.0) {
        [_locationManager stopUpdatingLocation];
    }
}

- (void) uploadMyFavorite {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *timeStampValue = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user_id"     :[userDefault objectForKey:@"user_id"],
                             @"artist_id"   :[item objectForKey:@"id"],
                             @"datetime"    :[NSString stringWithFormat:@"%@", timeStampValue],
                             @"latitude"    :[NSString stringWithFormat:@"%f", latitude],
                             @"longitude"   :[NSString stringWithFormat:@"%f", longitude]};
    
    [manager POST:@"http://heounsuk.com/festival/upload_my_favorite_artist.php" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        
        if([[responseObject objectForKey:@"success"] boolValue] == TRUE) {
            [self downloadArtistUpdates];
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
        NSLog(@"Operation: %@, Error: %@", operation, error);
    }];
}

- (void) downloadArtistUpdates {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"artist_id"    :[NSString stringWithFormat:@"%d", [[item objectForKey:@"id"] intValue]]};
    [manager POST:@"http://heounsuk.com/festival/download_artist_details.php" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        
        if([[responseObject objectForKey:@"success"] boolValue] == TRUE) {
            NSMutableArray *itemAry = [[NSMutableArray alloc]initWithCapacity:0];
            itemAry = [[responseObject objectForKey:@"results"] objectForKey:@"favorite_user_ary"];
            int itemAryCnt = (int)[itemAry count];
            
            NSLog(@"itemAryCnt: %d", itemAryCnt);
            
            [artistFavoriteBtn setTitle:[NSString stringWithFormat:@"     (%d)", itemAryCnt] forState:UIControlStateNormal];
            
            BOOL favoriteAdded = NO;
            for (int i = 0; i < itemAryCnt; i++) {
                NSDictionary *dic = [itemAry objectAtIndex:i];
                if ([[userDefault objectForKey:@"user_id"] intValue] == [[dic objectForKey:@"user_id"] intValue]) {
                    favoriteAdded = YES;
                    break;
                }
            }
            
            if (favoriteAdded) {
                [artistFavoriteImage setImage:[UIImage imageNamed:@"star_selected.png"]];
            }
            else {
                [artistFavoriteImage setImage:[UIImage imageNamed:@"star_normal.png"]];
            }
            
        }
        else {
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString: @"ArtistsWebPageViewController"]) {
        ArtistsWebPageViewController *viewController = (ArtistsWebPageViewController *)[segue destinationViewController];
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.webLink = [item objectForKey:@"website"];
    }
    else if ([[segue identifier] isEqualToString: @"ArtistsMoreImagesViewController"]) {
        ArtistsMoreImagesViewController *viewController = (ArtistsMoreImagesViewController *)[segue destinationViewController];
        viewController.hidesBottomBarWhenPushed = YES;
        NSMutableArray *photoArray = [[NSMutableArray alloc]initWithCapacity:0];
        [photoArray addObjectsFromArray:[item objectForKey:@"image_url"]];
        viewController.photoList = photoArray;
    }
    else if ([[segue identifier] isEqualToString: @"UserInputDetailViewController"]) {
        UserInputDetailViewController *viewController = (UserInputDetailViewController *)[segue destinationViewController];
        viewController.eventID = [[item objectForKey:@"id"] intValue];
    }
    else {
        
    }
}

@end
