//
//  MapViewAnnotation.m
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 6/21/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import "MapViewAnnotation.h"

@implementation MapViewAnnotation

@synthesize coordinate;
@synthesize markTitle, markSubTitle;

-(id)initWithCoordinate:(CLLocationCoordinate2D)theCoordinate andMarkTitle:(NSString *)theMarkTitle andMarkSubTitle:(NSString *)theMarkSubTitle {
	coordinate      = theCoordinate;
    markTitle       = theMarkTitle;
    markSubTitle    = theMarkSubTitle;

	return self;
}

- (NSString *)title {
    return markTitle;
}

- (NSString *)subtitle {
    return markSubTitle;
}

@end
