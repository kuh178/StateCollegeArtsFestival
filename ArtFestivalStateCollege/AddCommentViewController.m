//
//  AddCommentViewController.m
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 6/21/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import "AddCommentViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "EventDetailViewController.h"
#import "JSON.h"

#define kOFFSET_FOR_KEYBOARD 80.0

@interface AddCommentViewController ()

@end

@implementation AddCommentViewController

@synthesize item, userCommentsArray, tableViewList, addBtn, commentText;

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
    
    // ios7 handling navigationBar
    // ref : http://stackoverflow.com/questions/19029833/ios-7-navigation-bar-text-and-arrow-color
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:51.0/255.0 green:164.0/255.0 blue:192.0/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    // make the corner of the buttons round
    addBtn.layer.cornerRadius = 5;
    addBtn.layer.borderWidth = 1;
    addBtn.layer.borderColor = [UIColor colorWithRed:59.0/255.0 green:89.0/255.0 blue:152.0/255.0 alpha:1.0].CGColor;

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"AddCommentViewController";
    self.navigationItem.backBarButtonItem.title = @"Back";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// Table view property
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [userCommentsArray count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Display items
    NSMutableDictionary *cItem       = [userCommentsArray objectAtIndex:indexPath.row];
    UIImageView *userImage          = (UIImageView *)[cell viewWithTag:100];
    UILabel *userName               = (UILabel *)[cell viewWithTag:101];
    UILabel *comment                = (UILabel *)[cell viewWithTag:102];
    UILabel *datetime               = (UILabel *)[cell viewWithTag:103];
    
    // user image
    [userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [cItem objectForKey:@"user_image"]]]];
    userImage.layer.cornerRadius = 4.0f;
    userImage.clipsToBounds = YES;
    
    // user name
    userName.text = [cItem objectForKey:@"user_name"];
    
    // comment
    comment.text = [cItem objectForKey:@"comment"];
    
    // comment datetime
    NSTimeInterval _interval=[[cItem objectForKey:@"datetime"] doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setLocale:[NSLocale currentLocale]];
    [_formatter setDateFormat:@"MMM-dd"];
    NSString *_date=[_formatter stringFromDate:date];
    datetime.text = _date;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSMutableDictionary *item = [commentList objectAtIndex:indexPath.row];
    
    //[self performSegueWithIdentifier:@"EventDetailViewController" sender:item];
    
    //EventDetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EventDetailViewController"];
    //viewController.hidesBottomBarWhenPushed = YES;
    //[viewController setItem:item];
    //[self.navigationController pushViewController:viewController animated:YES];
    //[self presentViewController:viewController animated:YES completion:nil];
}

-(IBAction)addBtnPressed:(id)sender {
    if (commentText.text.length == 0) {
        UIAlertView *dialog = [[UIAlertView alloc]init];
        [dialog setDelegate:nil];
        [dialog setTitle:@"Message"];
        [dialog setMessage:@"Check your comment"];
        [dialog addButtonWithTitle:@"OK"];
        [dialog show];
    }
    else { // upload to the server

        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        
        NSString *timeStampValue = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *params = @{@"user_id"     :[userDefault objectForKey:@"user_id"],
                                 @"post_id"     :[NSString stringWithFormat:@"%d", [[item objectForKey:@"post_id"] intValue]],
                                 @"datetime"    :[NSString stringWithFormat:@"%@", timeStampValue],
                                 @"comment"     :[NSString stringWithFormat:@"%@", commentText.text]};
        
        [manager POST:@"http://community.ist.psu.edu/Festival/upload_user_content_comment.php" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success: %@", responseObject);
            
            if ([[responseObject objectForKey:@"success"]boolValue] == TRUE) {
                
                //UIAlertView *dialog = [[UIAlertView alloc]init];
                //[dialog setDelegate:nil];
                //[dialog setTitle:@"Message"];
                //[dialog setMessage:@"Comment added"];
                //[dialog addButtonWithTitle:@"OK"];
                //[dialog show];
                
                // receive a list of comments from the server
                
                if ([[responseObject objectForKey:@"user_comments_array"] count] > 0) {
                    userCommentsArray = [NSMutableArray arrayWithCapacity:0];
                    userCommentsArray = [responseObject objectForKey:@"user_comments_array"];
                    
                    [tableViewList reloadData];
                }
                else {
                    
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
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == commentText) {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"textViewDidBeginEditing");
    
    // To load different storyboards on launch
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    
    if (iOSDeviceScreenSize.height == 480 || UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (textField.frame.origin.y + textField.frame.size.height > 480 - 216) {
            double offset = 480 - 216 - textField.frame.origin.y - textField.frame.size.height;
            CGRect rect = CGRectMake(0, offset, self.view.frame.size.width, self.view.frame.size.height);
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3];
            
            self.view.frame = rect;
            
            [UIView commitAnimations];
        }
    }
    if (iOSDeviceScreenSize.height == 568) {
        if (textField.frame.origin.y + textField.frame.size.height > 568 - 216) {
            double offset = 568 - 216 - textField.frame.origin.y - textField.frame.size.height;
            CGRect rect = CGRectMake(0, offset, self.view.frame.size.width, self.view.frame.size.height);
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3];
            
            self.view.frame = rect;
            
            [UIView commitAnimations];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"textViewDidEndEditing");
    
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

@end
