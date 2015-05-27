//
//  AppDelegate.m
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 3/4/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import "GAI.h"
#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import "BloothLocationServices.h"

//#import <GoogleMaps/GoogleMaps.h>


@implementation AppDelegate

//@synthesize session = _session;

//NSString *const FBSessionStateChangedNotification = @"edu.psu.ist.cscl.ArtFestivalStateCollege";
UIStoryboard *storyboard;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // this is for the google map
    //[GMSServices provideAPIKey:@"AIzaSyAgcjUmJH6c2dD14y6otmSn75VoIYZA02A"];
    
    // for Google Analytics
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    //initilize parse and blooth
    [Parse setApplicationId:@"8kF8pk05dWxFLAmSOQjrG4ecbLABu0hx8wTwjY92"
                  clientKey:@"cngCLXl0J9kMzzvrciQFgcXwgRsnaUgxQjsigBLy"];
    
    // we want to push this back until we know the user is logged in
    [BloothLocationServices sharedManager];
    
    // Initialize tracker.
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-52154939-1"];
    
    // To load different storyboards on launch
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    
    NSLog(@"%f", iOSDeviceScreenSize.height);
    
    if (iOSDeviceScreenSize.height == 480 || UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) //height 480 (3gs,4, 4s) or iPad
    {
        // createUIStoryboard
        storyboard = [UIStoryboard storyboardWithName:@"StoryBoard_Small" bundle:nil];
        //  call initial view controller from UIStoryboard
        UIViewController *initialViewController = [storyboard instantiateInitialViewController];
        
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController  = initialViewController;
        [self.window makeKeyAndVisible];
    }
    
    if (iOSDeviceScreenSize.height == 568) //height 568 (5, 5s)
    {
        storyboard = [UIStoryboard storyboardWithName:@"StoryBoard5" bundle:nil];
        
        UIViewController *initialViewController = [storyboard instantiateInitialViewController];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController  = initialViewController;
        [self.window makeKeyAndVisible];
    }
    
    // google map sdk
    //[GMSServices provideAPIKey:@"AIzaSyCe6SZn7XdTRcznv2MGEkWel-Y6u4Eiypk"];
    
    // for controlling status bar
    // ref: http://stackoverflow.com/questions/18953879/how-to-set-status-bars-content-color-to-white-on-ios-7
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //return YES;
    //return [[FBSDKApplicationDelegate sharedInstance] application:application
    //                                didFinishLaunchingWithOptions:launchOptions];
    
    // Override point for customization after application launch.
    [FBSDKLoginButton class];
    
    // Notification registration; Let the device know we want to receive push notifications
    // ref1: http://code.tutsplus.com/tutorials/setting-up-push-notifications-on-ios--cms-21925
    // ref2: http://stackoverflow.com/questions/24454033/registerforremotenotificationtypes-is-not-supported-in-ios-8-0-and-later
    // ref3: http://api.shephertz.com/tutorial/Push-Notification-iOS/
    //-- Set Notification
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        application.applicationIconBadgeNumber = 0;
        
        [application registerForRemoteNotifications];
    }
    else {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
        application.applicationIconBadgeNumber = 0;
    }
    
    
    
    return YES;
}

// To process the response you get from interacting with the Facebook login process, you need to override the application:openURL:sourceApplication:annotation
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBSDKAppEvents activateApp];
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

// for notification
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"Did Register for Remote Notifications with Device Token (%@)", deviceToken);
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *device = [deviceToken description];
    device = [device stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    device = [device stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"device :%@", device);
    
    [userDefault setObject:device forKey:@"device_token"];
    [userDefault synchronize];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Did Fail to Register for Remote Notifications");
    NSLog(@"%@, %@", error, error.localizedDescription);
    
}

// when receives a notification
- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    UIApplicationState state = [application applicationState];
    
    NSLog(@"userInfo : %@", userInfo);
    
    // user tapped notification while app was in background
    if (state == UIApplicationStateInactive || state == UIApplicationStateBackground) {
        // go to screen relevant to Notification content
        NSLog(@"background");
        
        // increase badge number
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber: +1];
    } else {
        // App is in UIApplicationStateActive (running in foreground)

        //Application is in background - When the notification is clicked on, we will get here
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0]; //Clear notification as we have clicked it, potentially could also be -1 to decrement?
        
        // perhaps show an UIAlertView
        NSLog(@"foreground");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Close", nil];
        [alert show];
    }
}

//local notifs
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    // If the application is in the foreground, we will notify the user of the region's state via an alert.
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:notification.alertBody message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    /*
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    UITabBarController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
    UINavigationController *navController = [tabBarController.viewControllers objectAtIndex:4];
    
    if ([title isEqualToString:@"Check"]){ // Check the message, open up a new view

        BOOL isOnScreen = [[navController topViewController] isKindOfClass:[ProfileViewController class]];
        
        NSLog(@"isOnScreen : %hhd", isOnScreen);
        
        if(isOnScreen){
            [tabBarController setSelectedIndex:4];
            ProfileViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
            [navController pushViewController:vc animated:YES];
            
            NSLog(@"vc : %@", vc);
            
            //MoreViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"MoreViewController"];
            //[self presentViewController:viewController animated:YES completion:nil];

        }
    }
    else {
        
    }
    */
}


@end
