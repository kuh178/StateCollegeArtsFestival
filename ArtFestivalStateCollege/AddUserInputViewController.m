//
//  AddUserInputViewController.m
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 3/4/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import "AddUserInputViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "JSON.h"

@interface AddUserInputViewController ()

@end

@implementation AddUserInputViewController

// photo tutorial: http://www.appcoda.com/ios-programming-camera-iphone-app/
@synthesize imageView, takePhotoBtn, tagUsersBtn, uploadBtn, eventID, commentText, imageText, latitude, longitude, fromEvent;

NSData      *imageData;
UIImage     *chosenImage;
NSString    *taggedUsers;

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
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    _startLocation = nil;
    
    // make the corner of the buttons round
    tagUsersBtn.layer.cornerRadius = 5;
    tagUsersBtn.layer.borderWidth = 1;
    tagUsersBtn.layer.borderColor = [UIColor colorWithRed:59.0/255.0 green:89.0/255.0 blue:152.0/255.0 alpha:1.0].CGColor;
    
    uploadBtn.layer.cornerRadius = 5;
    uploadBtn.layer.borderWidth = 1;
    uploadBtn.layer.borderColor = [UIColor colorWithRed:59.0/255.0 green:89.0/255.0 blue:152.0/255.0 alpha:1.0].CGColor;
    
    // check if the device has a camera
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
    }
    
    if (eventID == 0) {
        eventID = -1;
    }
    
    CALayer *layer = imageView.layer;
    [layer setBorderColor: [[UIColor blackColor] CGColor]];
    [layer setBorderWidth:1.0f];
    [layer setShadowColor: [[UIColor blackColor] CGColor]];
    [layer setShadowOpacity:0.5f];
    [layer setShadowOffset: CGSizeMake(1,2)];
    [layer setShadowRadius:2.0];
    [imageView setClipsToBounds:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"AddUserInputViewController";
    self.navigationItem.backBarButtonItem.title = @"Back";
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSString *currentLatitude = [[NSString alloc]
                                 initWithFormat:@"%+.6f",
                                 newLocation.coordinate.latitude];
    latitude = [currentLatitude doubleValue];
    
    NSString *currentLongitude = [[NSString alloc]
                                  initWithFormat:@"%+.6f",
                                  newLocation.coordinate.longitude];
    longitude = [currentLongitude doubleValue];
    
    if (latitude != 0.0 && longitude != 0.0) {
        [_locationManager stopUpdatingLocation];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)takePhotoBtnPress:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Pick one" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Camera",@"Gallery", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Gallery"]){ // Gallery
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
    else if ([title isEqualToString:@"Camera"]){ // Camera
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
    else if ([title isEqualToString:@"OK"]){ // OK
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:@"true" forKey:@"reload_view"];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([title isEqualToString:@"Post"]){
        
        if (imageData) {
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            
            NSString *timeStampValue = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSDictionary *params = @{@"user_id"     :[userDefault objectForKey:@"user_id"],
                                     @"event_id"    :[NSString stringWithFormat:@"%d", eventID],
                                     @"datetime"    :[NSString stringWithFormat:@"%@", timeStampValue],
                                     @"comment"     :[NSString stringWithFormat:@"%@", commentText.text],
                                     @"tagged_users":[NSString stringWithFormat:@"%@", taggedUsers],
                                     @"latitde"     :[NSString stringWithFormat:@"%f", latitude],
                                     @"longitude"   :[NSString stringWithFormat:@"%f", longitude]};
            
            NSLog(@"size of file is %ld", (unsigned long)[imageData length]);
            
            [manager POST:@"http://community.ist.psu.edu/Festival/upload_user_content.php" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                [formData appendPartWithFileData:imageData name:@"image" fileName:@"temp_image.png" mimeType:@"image/jpeg"];
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"Success: %@", responseObject);
                
                UIAlertView *dialog = [[UIAlertView alloc]init];
                [dialog setDelegate:self];
                [dialog setTitle:@"Message"];
                [dialog setMessage:@"Succesfully posted"];
                [dialog addButtonWithTitle:@"OK"];
                [dialog show];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"operation : %@", operation.responseString);
                NSLog(@"Error: %@", error);
                
                UIAlertView *dialog = [[UIAlertView alloc]init];
                [dialog setDelegate:self];
                [dialog setTitle:@"Message"];
                [dialog setMessage:operation.responseString];
                [dialog addButtonWithTitle:@"OK"];
                [dialog show];
            }];
            
        }
        else {
            
        }
    }
    else { // else (e.g., Cancel)
        
    }
}

-(IBAction)addVoiceBtnPress:(id)sender {
    
}

-(IBAction)uploadBtnPress:(id)sender {
    
    if (imageData) {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Message"
                                                              message:@"Post this content?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                                    otherButtonTitles:@"Post", nil];
        [myAlertView show];
    }
    else {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Message"
                                                              message:@"Please add photo"
                                                             delegate:nil
                                                    cancelButtonTitle:@"Close"
                                                    otherButtonTitles:nil];
        [myAlertView show];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    chosenImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    imageView.image = chosenImage;

    imageText.hidden = YES;
    
    // update imageData value
    imageData = UIImageJPEGRepresentation(chosenImage, 0.8);

    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
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

-(IBAction)tagUsersBtnPress:(id)sender {
    
    AddUsersViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddUsersViewController"];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)addItemViewController:(AddUsersViewController *)controller didFinishAddUsers:(NSArray *)array {

    [tagUsersBtn setTitle:[NSString stringWithFormat:@"%d users", [array count]] forState:UIControlStateNormal];
    
    taggedUsers = @"";
    
    // get the array object and store it in the string
    for (int i = 0; i < [array count]; i++) {
        int user_id = [[[array objectAtIndex:i] objectForKey:@"user_id"] intValue];
        
        if (i == 0) {
            taggedUsers = [taggedUsers stringByAppendingString:[NSString stringWithFormat:@"%d", user_id]];
        }
        else {
            taggedUsers = [taggedUsers stringByAppendingString:[NSString stringWithFormat:@",%d", user_id]];
        }
    }
    
    NSLog(@"taggedUsers :%@", taggedUsers);
}


@end
