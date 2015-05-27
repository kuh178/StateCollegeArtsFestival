//
//  LocationManager.m
//  BloothEvents
//
//  Created by Kevin Costello on 12/9/14.
//  Copyright (c) 2015 Blooth Event Services LLC. All rights reserved.
//


#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "Beacon.h"
#import <UIKit/UIKit.h>

@class BloothLocationServices;
@interface BloothLocationServices : NSObject <CBCentralManagerDelegate>

@property (strong, nonatomic) NSString *lastSeenBeacon;
@property (strong, nonatomic) NSMutableDictionary *lastBeacons;
@property (strong, nonatomic) NSMutableDictionary *activeRegions;
@property(strong, nonatomic) NSString *currentRegion;


- (void)setupLocationManager;
+(instancetype)sharedManager;





@end
