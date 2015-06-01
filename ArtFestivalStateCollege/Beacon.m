//
//  Beacon.m
//  BloothEvents
//
//  Created by Kevin Costello on 12/9/14.
//  Copyright (c) 2015 Blooth Event Services LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Beacon.h"


@implementation Beacon

- (instancetype)initWithName:(NSString *)identifier
                        commonName:(NSString *)commonName
                        uuid:(NSUUID *)uuid
              greetingString:(NSString *)greetingString
                  exitString:(NSString *)exitString
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _identifier = identifier;
    _uuid = uuid;
    _commonName = commonName;
    _greetingString = greetingString;
    _exitString = exitString;
    
    return self;
}
@end
