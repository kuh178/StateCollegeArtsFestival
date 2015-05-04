//
//  EventMapViewViewController.h
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 3/20/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <GoogleMaps/GoogleMaps.h>
#import "GAITrackedViewController.h"

@interface EventMapViewViewController : GAITrackedViewController {
    NSMutableArray *list;
}

@property (nonatomic, retain) NSMutableArray *list;

@end
