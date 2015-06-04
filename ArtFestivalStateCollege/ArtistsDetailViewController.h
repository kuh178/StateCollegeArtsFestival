//
//  ArtistsDetailViewController.h
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 3/20/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GAITrackedViewController.h"

@interface ArtistsDetailViewController : GAITrackedViewController {

    IBOutlet UIImageView        *artistImage;
    IBOutlet UIImageView        *artistFavoriteImage;
    IBOutlet UILabel            *artistName;
    IBOutlet UILabel            *artistBooth;
    IBOutlet UILabel            *artistCategory;
    IBOutlet UILabel            *artistAddress;
    IBOutlet UILabel            *artistDescription;
    
    IBOutlet UIButton           *artistMoreImageBtn;
    IBOutlet UIButton           *artistUserPhotosBtn;
    IBOutlet UIButton           *artistEmailBtn;
    IBOutlet UIButton           *artistWebPageBtn;
    IBOutlet UIButton           *artistFavoriteBtn;

    IBOutlet MKMapView          *artistMap;
    
    IBOutlet UIView             *view1;
    IBOutlet UIView             *view2;

    NSMutableDictionary         *item;
    
    double latitude;
    double longitude;
}

@property (nonatomic, retain) IBOutlet UIImageView        *artistImage;
@property (nonatomic, retain) IBOutlet UIImageView        *artistFavoriteImage;
@property (nonatomic, retain) IBOutlet UILabel            *artistName;
@property (nonatomic, retain) IBOutlet UILabel            *artistBooth;
@property (nonatomic, retain) IBOutlet UILabel            *artistCategory;
@property (nonatomic, retain) IBOutlet UILabel            *artistAddress;
@property (nonatomic, retain) IBOutlet UILabel            *artistDescription;
@property (nonatomic, retain) IBOutlet MKMapView          *artistMap;

@property (nonatomic, retain) IBOutlet UIButton           *artistMoreImageBtn;
@property (nonatomic, retain) IBOutlet UIButton           *artistEmailBtn;
@property (nonatomic, retain) IBOutlet UIButton           *artistWebPageBtn;
@property (nonatomic, retain) IBOutlet UIButton           *artistFavoriteBtn;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *startLocation;

@property (nonatomic, retain) IBOutlet UIView             *view1;
@property (nonatomic, retain) IBOutlet UIView             *view2;

@property (nonatomic, retain) NSMutableDictionary         *item;

- (IBAction)artistEmailBtnPressed:(id)sender;
- (IBAction)artistFavoriteBtnPressed:(id)sender;

@end
