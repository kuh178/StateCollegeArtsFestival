//
//  UserInputDetailedViewController.m
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 3/20/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import "UserInputDetailedViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "AFHTTPRequestOperationManager.h"
#import "AddCommentViewController.h"
#import "JSON.h"

@interface UserInputDetailedViewController ()

@end

@implementation UserInputDetailedViewController

@synthesize image, userImage, username, datetime, item, commentArray, audioBtn, likePhotoBtn, commentText, addCommentBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // image
    CALayer *layer = image.layer;
    [layer setBorderColor: [[UIColor blackColor] CGColor]];
    [layer setBorderWidth:1.0f];
    [layer setShadowColor: [[UIColor blackColor] CGColor]];
    [layer setShadowOpacity:0.5f];
    [layer setShadowOffset: CGSizeMake(1,2)];
    [layer setShadowRadius:2.0];
    [image setClipsToBounds:NO];
   

    // image
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [item objectForKey:@"image_url"]]]];
            image.clipsToBounds = YES;
        });
    });
    
    // user image
    [userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [item objectForKey:@"user_image"]]]];
    userImage.layer.cornerRadius = 4.0f;
    userImage.clipsToBounds = YES;
    
    // user name
    username.text = [item objectForKey:@"user_name"];
    
    // datetime
    NSTimeInterval _interval = [[item objectForKey:@"datetime"] doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setLocale:[NSLocale currentLocale]];
    [_formatter setDateFormat:@"YYYY, MMMM dd"];
    NSString *_date=[_formatter stringFromDate:date];
    datetime.text = _date;
    
    // comment
    commentText.text = [item objectForKey:@"comment"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"UserInputDetailedViewController";
    self.title = @"Details";
    self.navigationItem.backBarButtonItem.title = @"Back";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self downloadLikesComments];
}

- (void)downloadLikesComments {

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"post_id"     :[NSString stringWithFormat:@"%d", [[item objectForKey:@"post_id"] intValue]]};
    
    [manager POST:@"http://heounsuk.com/festival/download_user_photo_likes_comments.php" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        
        if ([[responseObject objectForKey:@"success"]boolValue] == TRUE) {
         
            int numLikes = [[responseObject objectForKey:@"user_likes_array"] count];
            int numComments = [[responseObject objectForKey:@"user_comments_array"] count];
            
            // num likes
            if (numLikes <= 1) {
                [likePhotoBtn setTitle:[NSString stringWithFormat:@"%d like", numLikes] forState:UIControlStateNormal];
            }
            else {
                [likePhotoBtn setTitle:[NSString stringWithFormat:@"%d likes", numLikes] forState:UIControlStateNormal];
            }
            
            // num comments
            if (numComments <= 1) {
                [addCommentBtn setTitle:[NSString stringWithFormat:@"%d comment", numComments] forState:UIControlStateNormal];
            }
            else {
                [addCommentBtn setTitle:[NSString stringWithFormat:@"%d comments", numComments] forState:UIControlStateNormal];
            }
            
            commentArray = [NSMutableArray arrayWithCapacity:0];
            commentArray = [responseObject objectForKey:@"user_comments_array"];
        }
        else {
            UIAlertView *dialog = [[UIAlertView alloc]init];
            [dialog setDelegate:nil];
            [dialog setTitle:@"Message"];
            [dialog setMessage:[responseObject objectForKey:@"message"]];
            [dialog addButtonWithTitle:@"OK"];
            [dialog show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (IBAction)audioBtnPressed:(id)sender {
    
}

- (IBAction)likePhotoBtnPressed:(id)sender {
    [self addLike];
}

- (void) addLike {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString *timeStampValue = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user_id"     :[userDefault objectForKey:@"user_id"],
                             @"post_id"     :[NSString stringWithFormat:@"%d", [[item objectForKey:@"post_id"] intValue]],
                             @"datetime"    :[NSString stringWithFormat:@"%@", timeStampValue]};
    
    NSLog(@"%d", [[item objectForKey:@"post_id"] intValue]);
    NSLog(@"%d", [[userDefault objectForKey:@"user_id"] intValue]);
    
    [manager POST:@"http://heounsuk.com/festival/upload_user_content_like.php" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        
        if ([[responseObject objectForKey:@"success"]boolValue] == TRUE) {
            
            UIAlertView *dialog = [[UIAlertView alloc]init];
            [dialog setDelegate:nil];
            [dialog setTitle:@"Message"];
            [dialog setMessage:@"Like added"];
            [dialog addButtonWithTitle:@"OK"];
            [dialog show];
            
            if (([[item objectForKey:@"like_cnt"] intValue] + 1) <= 1) {
                [likePhotoBtn setTitle:[NSString stringWithFormat:@"%d like",[[item objectForKey:@"like_cnt"] intValue] + 1] forState:UIControlStateNormal];
            }
            else {
                [likePhotoBtn setTitle:[NSString stringWithFormat:@"%d likes",[[item objectForKey:@"like_cnt"] intValue] + 1] forState:UIControlStateNormal];
            }
            
        }
        else {
            UIAlertView *dialog = [[UIAlertView alloc]init];
            [dialog setDelegate:nil];
            [dialog setTitle:@"Message"];
            [dialog setMessage:[responseObject objectForKey:@"message"]];
            [dialog addButtonWithTitle:@"OK"];
            [dialog show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Like"]){
        
        
    }
    else { // else (e.g., Cancel)
        
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString: @"AddCommentViewController"]) {
        AddCommentViewController *viewController = (AddCommentViewController *)[segue destinationViewController];
        viewController.hidesBottomBarWhenPushed = YES;
        [viewController setItem:item];
        [viewController setUserCommentsArray:commentArray];
    }
}

- (IBAction)addCommentBtnPressed:(id)sender {
    
}



@end
