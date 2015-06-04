//
//  UserInputDetailedViewController.h
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 3/20/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface UserInputDetailedViewController : GAITrackedViewController {
    IBOutlet UIImageView    *image;
    IBOutlet UIImageView    *userImage;
    IBOutlet UIImageView    *favoriteImage;
    IBOutlet UILabel        *username;
    IBOutlet UILabel        *datetime;
    
    IBOutlet UIButton       *audioBtn;
    IBOutlet UIButton       *likePhotoBtn;
    IBOutlet UIButton       *addCommentBtn;
    IBOutlet UIButton       *removeBtn;
    IBOutlet UIBarButtonItem *moreBtn;
    IBOutlet UITextView     *commentText;
    
    NSMutableDictionary     *item;
    NSMutableArray          *commentArray;
}

@property (nonatomic, retain)     IBOutlet UIImageView      *image;
@property (nonatomic, retain)     IBOutlet UIImageView      *userImage;
@property (nonatomic, retain)     IBOutlet UIImageView      *favoriteImage;
@property (nonatomic, retain)     IBOutlet UILabel          *username;
@property (nonatomic, retain)     IBOutlet UILabel          *datetime;

@property (nonatomic, retain)     IBOutlet UIButton         *audioBtn;
@property (nonatomic, retain)     IBOutlet UIButton         *likePhotoBtn;
@property (nonatomic, retain)     IBOutlet UIButton         *addCommentBtn;
@property (nonatomic, retain)     IBOutlet UIButton         *removeBtn;
@property (nonatomic, retain)     IBOutlet UIBarButtonItem  *moreBtn;
@property (nonatomic, retain)     IBOutlet UITextView       *commentText;

@property (nonatomic, retain)     NSMutableDictionary       *item;
@property (nonatomic, retain)     NSMutableArray            *commentArray;

- (IBAction)audioBtnPressed:(id)sender;
- (IBAction)likePhotoBtnPressed:(id)sender;
- (IBAction)addCommentBtnPressed:(id)sender;
- (IBAction)removeBtnPressed:(id)sender;
- (IBAction)moreBtnPressed:(id)sender;

@end
