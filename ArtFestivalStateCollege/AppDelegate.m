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
//#import <GoogleMaps/GoogleMaps.h>


@implementation AppDelegate

//@synthesize session = _session;

//NSString *const FBSessionStateChangedNotification = @"edu.psu.ist.cscl.ArtFestivalStateCollege";

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
    
    // Initialize tracker.
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-52154939-1"];
    
    // To load different storyboards on launch
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    
    NSLog(@"%f", iOSDeviceScreenSize.height);
    
    if (iOSDeviceScreenSize.height == 480 || UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) //화면세로길이가 480 (3gs,4, 4s) or iPad
    {
        // UIStoryboard 생성
        UIStoryboard *iPhone35Storyboard = [UIStoryboard storyboardWithName:@"StoryBoard_Small" bundle:nil];
        // 생성한 UIStoryboard에서  initial view controller를 가져온다.
        UIViewController *initialViewController = [iPhone35Storyboard instantiateInitialViewController];
        
        // 화면크기로 윈도우 생성
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        // window의 rootViewController를 스토리보드의 initial view controller로 설정
        self.window.rootViewController  = initialViewController;
        
        // 윈도우 보이기
        [self.window makeKeyAndVisible];
    }
    
    if (iOSDeviceScreenSize.height == 568) //화면세로길이가 568 (5)
    {
        //동일
        UIStoryboard *iPhone4Storyboard = [UIStoryboard storyboardWithName:@"StoryBoard5" bundle:nil];
        
        UIViewController *initialViewController = [iPhone4Storyboard instantiateInitialViewController];
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
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Did Fail to Register for Remote Notifications");
    NSLog(@"%@, %@", error, error.localizedDescription);
    
}


@end
