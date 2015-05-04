//
//  ArtistsWebPageViewController.h
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 4/21/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface ArtistsWebPageViewController : GAITrackedViewController <UIWebViewDelegate>{
    NSString *webLink;
    IBOutlet UIWebView *webView;
    IBOutlet UIActivityIndicatorView *indicator;
}

@property (nonatomic, retain) NSString *webLink;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;

@end
