//
//  Beacon.h
//  BloothEvents
//
//  Created by Kevin Costello on 12/9/14.
//  Copyright (c) 2015 Blooth Event Services LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
//@import CoreLocation;

@interface Beacon : NSObject

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSUUID *uuid;
@property (strong, nonatomic) NSString *commonName;
@property (strong, nonatomic) NSString *greetingString;
@property (strong, nonatomic) NSString *exitString;
//@property (strong, nonatomic) CLBeacon *lastSeenBeacon;


- (instancetype)initWithName:(NSString *)identifier
                  commonName:(NSString *)commonName
                        uuid:(NSUUID *)uuid
              greetingString:(NSString *)greetingString
                  exitString:(NSString *)exitString;
@end