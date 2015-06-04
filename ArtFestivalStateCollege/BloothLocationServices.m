//
//  LocationManager.m
//  BloothEvents
//
//  Created by Kevin Costello on 12/9/14.
//  Copyright (c) 2015 Blooth Event Services LLC. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "BloothLocationServices.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "Beacon.h"
#import <UIKit/UIKit.h>
#import "BloothConstants.h"
#import <Parse/Parse.h>
#import "AFHTTPRequestOperationManager.h"

@interface BloothLocationServices () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *returnedBeaconObjects;
@property (nonatomic, strong) CBCentralManager* bluetoothManager;
@property (nonatomic, strong) NSMutableDictionary *beaconNotifications;

@end

@implementation BloothLocationServices

@synthesize lastSeenBeacon;
@synthesize lastBeacons;
@synthesize activeRegions;
@synthesize currentRegion;


+(instancetype)sharedManager{
    static dispatch_once_t oncetoken;
    static BloothLocationServices *sharedManager;
    dispatch_once(&oncetoken, ^{ sharedManager = [[self alloc]init];
    });
    return sharedManager;
}


- (id)init
{
    self = [super init];
    if (self) {
        
        [self setupLocationManager];
        lastBeacons = [NSMutableDictionary new];
        activeRegions = [NSMutableDictionary new];
        _beaconNotifications = [NSMutableDictionary new];
    }
    return self;
}

- (void)setupLocationManager
{
    [NSTimer scheduledTimerWithTimeInterval:UpdateTimer  
                                     target:self
                                   selector:@selector(lastBeaconSeenUpdate)
                                   userInfo:nil
                                    repeats:YES];
    
     [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(webServiceCheckin:)
                                           name:lastBeaconSeenUpdate
                                           object:nil];

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(webServiceCheckin:)
                                                 name:regionUpdate
                                               object:nil];
    
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    
    [self detectBluetooth];
    //[self getBeaconsAtEvent]; //DEBUG to refresh the region info not on timer
    
    if([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]] == NO){
        
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
    
        }
    }else{
        
        if(![CLLocationManager locationServicesEnabled])
        {
            
            NSLog(@"Location Services disabled");
            NSString *message = @"Location Services Disabled! Blooth Events uses location services to provide exclusive offers while to users based on their location at the conference! Please enable Location services in Settings to get the full experience.";
            [self locationServicesNotAuthed:message];
        }
        if(![CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]])
        {
            
            NSLog(@"Region Monitoring not available");
            NSString *message = @"iBeacon features not available on this device!";
            [self locationServicesNotAuthed:message];
        }
        if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
           [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted  )
        {
            
            NSLog(@"App not authorized");
            NSString *message = @"Location Services not authorized! Blooth Events uses location services to provide exclusive offers while to users based on their location at the conference! Please enable Location services in Settings to get the full experience.";
            [self locationServicesNotAuthed:message];
        }
    }
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:@"bloothLastBeaconUpdate"];
    NSLog(@"%@", date);
    
    
    if ( date == nil ){
        NSDate *now = [NSDate date];
        [[NSUserDefaults standardUserDefaults] setObject:now forKey:@"bloothLastBeaconUpdate"];
        [self getBeaconsAtEvent];
    }else{
        NSDate *now = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date toDate:now options:0];
        NSInteger hour = [components hour];
        
        if (hour >= 24){
            [self getBeaconsAtEvent];
        }
    }
}



- (void) getBeaconsAtEvent{
    
    self.returnedBeaconObjects = [NSMutableArray new];
    
    //query parse for event beacons
    PFQuery *query = [PFQuery queryWithClassName:@"Regions"];
    [query whereKey:@"eventId" equalTo:CurrentEventId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error){
            
            
            for (PFObject *object in objects){
                
                NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:[object objectForKey:@"UUID"]];
                NSString *identifier = [object objectForKey:@"identifier"];
                NSString *commonName = [object objectForKey:@"commonName"];
                NSString *greetingString = [object objectForKey:@"greetingString"];
                NSString *exitString = [object objectForKey:@"exitString"];
                
               
                Beacon *b = [[Beacon new]
                             initWithName:identifier
                             commonName:(NSString *)commonName
                             uuid:(NSUUID *)uuid
                            greetingString:(NSString *)greetingString
                            exitString:(NSString *)exitString];
        
                [_returnedBeaconObjects addObject:b];
                
                
                NSMutableDictionary *regionInfo = [NSMutableDictionary new];
                [regionInfo setObject:b.greetingString forKey:@"greetingString"];
                [regionInfo setObject:b.exitString forKey:@"exitString"];
                [_beaconNotifications setObject:regionInfo forKey:b.identifier];

            }
            NSLog(@"@%@",_beaconNotifications);
            
            
            [[NSUserDefaults standardUserDefaults] setObject:_beaconNotifications forKey:@"beaconNotifications"];
           
            
            NSArray *objectsToSend = self.returnedBeaconObjects;
            NSLog(@"%@", objectsToSend); //log beacon objects
            [self createRegionsToMonitor:objectsToSend];
        }else {
            NSLog(@"%@", error);
        }
    }];



    lastBeacons = [NSMutableDictionary new];
    activeRegions = [NSMutableDictionary new];
    lastSeenBeacon = nil;
    
}

- (void) createRegionsToMonitor:(NSArray*)regions{
    NSMutableArray *workArray = [NSMutableArray new];
    
    for(Beacon *beacon in regions){
        [workArray addObject:[self beaconRegionWithObject:beacon]];
    }
    
    [self startMonitoringForRegions:[NSArray arrayWithArray:workArray]];
}


- (CLBeaconRegion *)beaconRegionWithObject:(Beacon *)beacon {
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:beacon.uuid
                                                                      identifier:beacon.identifier];
    return beaconRegion;
}


- (void) startMonitoringForRegions:(NSArray*)regions{
   
    NSLog(@"Starting to monitor: %@ ", regions);
   
    for (CLBeaconRegion *region in regions){
        region.notifyEntryStateOnDisplay = YES;
        region.notifyOnEntry=YES;
        region.notifyOnExit =YES;
        [self.locationManager startMonitoringForRegion:region];
        
    }
    
    NSLog(@"%@",self.locationManager.monitoredRegions);
}

- (void) stopMonitoringForRegions{
    for (CLBeaconRegion *region in self.locationManager.monitoredRegions){
        [self.locationManager stopMonitoringForRegion:region];
        [self.locationManager stopRangingBeaconsInRegion:region];
    }
}


#pragma mark CLDelegate

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error {
    NSLog(@"Failed monitoring region: %@", error);
    NSLog(@"region: %@", region);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location manager failed: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    
    NSLog(@"locationManagerDidChangeAuthorizationStatus: %d", status);
    NSLog(@"%@", self.locationManager.monitoredRegions);
    
    //this forces didDetermineState to be called
    for (CLBeaconRegion *region in self.locationManager.monitoredRegions){
        [_locationManager requestStateForRegion:region];
    }
    
    if (status != kCLAuthorizationStatusAuthorizedAlways){
        NSString *message = @"Location Services Disabled! Blooth Events uses location services to provide exclusive offers to users based on their location at the conference! Please enable Location services in Settings to get the full experience.";
        [self locationServicesNotAuthed:message];
    }
    
    //detect if the user has enabled incognito mode
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"isIncognito"] == YES){
        [self stopMonitoringForRegions];
        [self incognitoPressed];         //incognito mode
        return;
    }
    
    [self detectBluetooth];
}

- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLBeaconRegion *)region{
    NSLog(@"%@", region);
    
    
    [self regionUpdate];
    [self sendEntryLocalNotificationforBeacon:region.identifier];
    
    [self.locationManager startRangingBeaconsInRegion:region];
}

- (void) locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLBeaconRegion *)region{
     
 
}
 


- (void)locationManager:(CLLocationManager *)manager
          didExitRegion:(CLBeaconRegion *)region{

    
    [self.locationManager stopRangingBeaconsInRegion:region];
    [activeRegions removeObjectForKey:region.identifier];
   // [self sendExitLocalNotificationforBeacon:region.identifier];
    
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLBeaconRegion *)region{
    
    
    if (state == CLRegionStateInside){
        
        [self.locationManager startRangingBeaconsInRegion:region];
        NSDate *now = [NSDate date];
        NSLog(@"We are in a region");
        NSLog(@"%@", region);
        NSString *regionID = region.identifier;
        [activeRegions setObject:regionID forKey:now];
        [self regionUpdate];

    
        NSLog(@"%@", activeRegions);
        
        
    }else if(state == CLRegionStateOutside || CLRegionStateUnknown){
        NSLog(@"We are not in a region");
        //remove from activeRegions
        NSString *regionId = region.identifier;
        NSArray *temp = [activeRegions allKeysForObject:regionId];
        NSString *key = [temp firstObject];
        NSLog(@"%@", key);
        if (key!= nil){
        [activeRegions removeObjectForKey:key];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager
rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region
              withError:(NSError *)error{
    NSLog(@"%@", error);
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
   
    NSPredicate *predicateIrrelevantBeacons = [NSPredicate predicateWithFormat:@"(self.accuracy != -1) AND (self.proximity != %d)", CLProximityUnknown];
    NSArray *relevantBeacons = [beacons filteredArrayUsingPredicate: predicateIrrelevantBeacons];
    // call helper2
    NSLog(@"%@", relevantBeacons);
    [self addToLastBeacons:relevantBeacons];
}

- (void) addToLastBeacons:(NSArray *)relevantBeacons{
    for (CLBeacon *beacon in relevantBeacons){
        
        NSString *major = [beacon.major stringValue];
        NSString *minor = [beacon.minor stringValue];
        NSString *beaconKey = [NSString stringWithFormat:@"%@_%@_%@", [self beaconIdentifierFromUUID:beacon.proximityUUID], major, minor];
        NSInteger beaconRssi = beacon.rssi;
        NSString *integerAsString = [@(beaconRssi) stringValue];
        NSLog(@"%@", integerAsString);
        [lastBeacons setObject:beaconKey forKey:integerAsString];
        NSLog(@"%@", lastBeacons);
        
    }
}

- (NSString *)beaconIdentifierFromUUID:(NSUUID *)beacon {
    NSSet *regions = self.locationManager.monitoredRegions;
    NSString *beaconRegion = [NSString new];
    for (CLBeaconRegion *region in regions){

        if ([region.proximityUUID isEqual:beacon]){
            
            beaconRegion = region.identifier;
            
            return beaconRegion;
        }
    }
    return beaconRegion;
}


- (void) lastBeaconSeenUpdate{
    
    //combat empty array
    BOOL isEmpty = ([lastBeacons count] == 0);
    if (isEmpty == true){
        return;
    }
    
    
    
   NSMutableArray *arrayToSort = [NSMutableArray new];
    
    for (NSString *string in [lastBeacons allKeys]){
        int value = [string intValue];
        NSNumber *number = [NSNumber numberWithInt:value];
        [arrayToSort addObject:number];
    }
    
    
    NSLog(@"%@", arrayToSort);
    
 
    
    NSArray* finalArray = [self sortBeacons:arrayToSort];
    NSLog(@"%@", finalArray);
    NSNumber *closestRssi1 = finalArray[0];
    NSString *closestRssi = [closestRssi1 stringValue];
    NSString *closestBeacon = [lastBeacons objectForKey:closestRssi];

    
    NSLog(@"%@", lastSeenBeacon);
    if (![lastSeenBeacon isEqualToString:closestBeacon]){
        
        lastSeenBeacon = closestBeacon;

        
        [[NSNotificationCenter defaultCenter] postNotificationName:lastBeaconSeenUpdate
                                                            object:@"lastSeenBeaconUpdate"
                                                          userInfo:nil];

    }
   
    lastBeacons = [NSMutableDictionary new];
}
- (NSArray*)sortBeacons:(NSArray *)arrayToSort {
    
    NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"self" ascending: NO];
    return [arrayToSort sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortOrder]];
}

- (void) regionUpdate {
    
    //check if the array is empty
    BOOL isEmpty = ([activeRegions count] == 0);
   
    if (isEmpty != true){
        
        
        NSArray *sorted = [[activeRegions allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[activeRegions objectForKey:obj1] compare:[activeRegions objectForKey:obj2]];
        }];
        
        
        NSArray* finalArray = [[sorted reverseObjectEnumerator] allObjects];
        NSString *lastActiveRegion = [activeRegions objectForKey:finalArray[0]];
        NSLog(@"%@", finalArray);
        
        
        if (![lastActiveRegion isEqualToString:currentRegion]){
            currentRegion = lastActiveRegion;
            [[NSNotificationCenter defaultCenter] postNotificationName:regionUpdate
                                                                object:@"regionUpdate"
                                                              userInfo:nil];
        }
        
    }
}


#pragma mark notes
//checkin to the parse.com table on notification
- (void)webServiceCheckin:(NSNotification *)note{
    NSDate *now = [NSDate date];
    
    if ([note.object isEqualToString:@"regionUpdate"]){
    [PFCloud callFunctionInBackground:@"checkIn"
                       withParameters:@{@"userInfo": [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"], @"regionID": currentRegion, @"eventId": CurrentEventId, @"timeStamp": now}
                                block:^(NSString *response, NSError *error) {
                                    if (!error) {
                                        NSLog(@"%@", response);
                                    }else{
                                        NSLog(@"%@", error.localizedDescription);
                                    }
                                }];
        
        // call to PSU backend
        NSLog(@"Sending a regionUpdate to PSU server");
        NSString *timeStampValue = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *params = @{@"user_id"         :[NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]],
                                 @"datetime"        :[NSString stringWithFormat:@"%@", timeStampValue],
                                 @"bt_region_id"    :currentRegion,
                                 @"bt_event_id"     :CurrentEventId,
                                 @"bt_type"         :@"regionUpdate"
                                 };
        
        [manager POST:@"http://heounsuk.com/festival/upload_user_location.php" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([[responseObject objectForKey:@"success"]boolValue] == TRUE) {
                NSLog(@"location uploaded");
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        // location update completed
    }
    
    if ([note.object isEqualToString:@"lastSeenBeaconUpdate"]){
        
        NSLog(@"lastSeenBeaconUpdate");
        
        [PFCloud callFunctionInBackground:@"checkIn"
                           withParameters:@{@"userInfo": [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"], @"regionID": lastSeenBeacon, @"eventId": CurrentEventId, @"timeStamp": now}
                                    block:^(NSString *response, NSError *error) {
                                        if (!error) {
                                            NSLog(@"%@", response);
                                        }else{
                                            NSLog(@"%@", error.localizedDescription);
                                        }
                                    }];
        // call to PSU backend
        NSLog(@"Sending a regionUpdate to PSU server");
        NSString *timeStampValue = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *params = @{@"user_id"         :[NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]],
                                 @"datetime"        :[NSString stringWithFormat:@"%@", timeStampValue],
                                 @"bt_region_id"    :currentRegion,
                                 @"bt_event_id"     :CurrentEventId,
                                 @"bt_type"         :@"lastSeenBeaconUpdate"
                                 };
        
        [manager POST:@"http://heounsuk.com/festival/upload_user_location.php" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([[responseObject objectForKey:@"success"]boolValue] == TRUE) {
                NSLog(@"location uploaded");
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        // location update completed
    }
}

#pragma mark notAuthorized
//helper method to dispplay alert view *NEEDS UPDATE TO IOS8
- (void)locationServicesNotAuthed:(NSString*)message{
    //TODO add settings path to open settings
    
  /*  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Location Services Error" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    [self presentViewController:alertController]; */
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Manager Error"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
 

}
//Incognito mode method for the switch looks at the bool in NSUserDefaults
- (void)incognitoPressed{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incognito Mode Activated!"
                                                    message:@"You are currently have incognito mode activated. While in incognito mode, location services will be disabled! Location services allow us to send you special offers based on your location at the event! Without location services activated, you will not be able to receive any offers. To disable incognito mode, visit your user profile page!"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
//turn on or off incognito mode on a notification
- (void)incognitoPressed:(NSNotification *)note{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"isIncognito"] == YES){
        [self stopMonitoringForRegions];
        return;
    }else if([defaults boolForKey:@"isIncognito"] == NO){
        [self getBeaconsAtEvent];
    }
}

#pragma mark Bluetooth
//detect if bluetooth is on
- (void)detectBluetooth
{
    if(!self.bluetoothManager)
    {
        // Put on main queue so we can call UIAlertView from delegate callbacks.
        self.bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    }
    [self centralManagerDidUpdateState:self.bluetoothManager]; // Show initial state
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSString *stateString = nil;
    switch(_bluetoothManager.state)
    {
        case CBCentralManagerStateResetting: stateString = @"The connection with the system service was momentarily lost, update imminent."; break;
        case CBCentralManagerStateUnsupported: stateString = @"The platform doesn't support Bluetooth Low Energy."; break;
        case CBCentralManagerStateUnauthorized: stateString = @"The app is not authorized to use Bluetooth Low Energy. Please allow Blooth to use Bluetooth Low Energy by visiting your settings."; break;
        case CBCentralManagerStatePoweredOff: stateString = @"Bluetooth is currently powered off. Bluetooth must be on for you to receive deals at the Event!"; break;
        case CBCentralManagerStatePoweredOn: stateString = @"Bluetooth is currently powered on and available to use."; break;
        default: stateString = @"State unknown, update imminent."; break;
    }
    
    if ( self.bluetoothManager.state == CBCentralManagerStateUnauthorized || self.bluetoothManager.state == CBCentralManagerStateUnsupported || self.bluetoothManager.state == CBCentralManagerStatePoweredOff){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bluetooth Error!"
                                                        message:stateString
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

//local notification

-(void)sendEntryLocalNotificationforBeacon:(NSString*)beacon {
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    NSMutableDictionary *beaconNotifications = [[[NSUserDefaults standardUserDefaults] objectForKey:@"beaconNotifications"] mutableCopy];
    
    NSMutableDictionary *beaconInfo = [[beaconNotifications objectForKey:beacon] mutableCopy];
    
    if (beaconInfo){
        
        if ([beaconInfo valueForKey:@"lastEntryNotif"] == nil){
        notification.alertBody = [beaconInfo objectForKey:@"greetingString"];
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        NSDate *now = [NSDate date];
        [beaconInfo setObject:now forKey:@"lastEntryNotif"];
        [beaconNotifications setObject:beaconInfo forKey:beacon];
        [[NSUserDefaults standardUserDefaults] setObject:beaconNotifications forKey:@"beaconNotifications"];
        } else{
                NSDate *now = [NSDate date];
                NSDate *lastSent = [beaconInfo objectForKey:@"lastEntryNotif"];
                NSCalendar *calendar = [NSCalendar currentCalendar];
                NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:lastSent toDate:now options:0];
                NSInteger hour = [components hour];
                if (hour >= 1){
                    notification.alertBody = [beaconInfo objectForKey:@"greetingString"];
                    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                    [beaconInfo setObject:now forKey:@"lastEntryNotif"];
                    [beaconNotifications setObject:beaconInfo forKey:beacon];
                    [[NSUserDefaults standardUserDefaults] setObject:beaconNotifications forKey:@"beaconNotifications"];

                }
            }
        }
}

/*-(void)sendExitLocalNotificationforBeacon:(NSString*)beacon {
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier == %@", beacon];
    NSArray *filteredArray = [_returnedBeaconObjects filteredArrayUsingPredicate:predicate];
 if ([beaconInfo valueForKey:@"lastEntryNotif"] == nil){
 NSDate *emptyDate = nil;
 [beaconInfo setObject:emptyDate forKey:@"lastEntryNotif"];
 }
    if (filteredArray){
        Beacon *b = filteredArray[0];
        notification.alertBody = b.exitString;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
} */

@end