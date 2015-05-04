//
//  AddUsersViewController.m
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 6/19/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import "AddUsersViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "AFHTTPRequestOperationManager.h"
#import "JSON.h"

@interface AddUsersViewController ()

@end

@implementation AddUsersViewController

@synthesize userList, tableViewList, jsonArray, lastIndexPath, checkArray, doneBtn;

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

    // ios7 handling navigationBar
    // ref : http://stackoverflow.com/questions/19029833/ios-7-navigation-bar-text-and-arrow-color
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:59.0/255.0 green:89.0/255.0 blue:152.0/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    // initialization
    checkArray = [NSMutableArray arrayWithCapacity:0];
    
    [self downloadUsers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.screenName = @"AddUsersViewController";
    self.navigationItem.backBarButtonItem.title = @"Back";
}

// Table view property
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [userList count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Display items
    NSMutableDictionary *item       = [userList objectAtIndex:indexPath.row];
    UIImageView *userImage         = (UIImageView *)[cell viewWithTag:100];
    UILabel *userName              = (UILabel *)[cell viewWithTag:101];
    
    // user image
    [userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [item objectForKey:@"user_image"]]]];
    userImage.layer.cornerRadius = 4.0f;
    userImage.clipsToBounds = YES;
    
    // user name
    userName.text = [item objectForKey:@"user_name"];
    
    // check indexPath
    if ([[checkArray objectAtIndex:indexPath.row] isEqualToString:@"1"])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.lastIndexPath = indexPath;
    
    if ([[checkArray objectAtIndex:indexPath.row] isEqualToString:@"0"]) { // not chosen
        [checkArray setObject:@"1" atIndexedSubscript:indexPath.row];
    }
    else { // already chosen
        [checkArray setObject:@"0" atIndexedSubscript:indexPath.row];
    }
    
    [tableView reloadData];
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

- (void) downloadUsers {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://community.ist.psu.edu/Festival/download_users_all.php" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        if ([[responseObject objectForKey:@"success"]boolValue] == TRUE) {
            jsonArray = [NSMutableArray arrayWithCapacity:0];
            userList = [NSMutableArray arrayWithCapacity:0];
            [jsonArray addObjectsFromArray:[responseObject objectForKey:@"results"]];
            
            if ([jsonArray count] > 0) {
                // insert new items into table
                for (int i = 0; i < [jsonArray count]; i++) {
                    
                    // get an item
                    NSDictionary *item = [jsonArray objectAtIndex:i];
                    [userList addObject:item];
                    
                    [checkArray setObject:@"0" atIndexedSubscript:i];
                }
            }
            else {
                NSLog(@"No data available");
            }
            
            [tableViewList reloadData];
        }
        else {
            UIAlertView *dialog = [[UIAlertView alloc]init];
            [dialog setDelegate:self];
            [dialog setTitle:@"Message"];
            [dialog setMessage:@"No results found"];
            [dialog addButtonWithTitle:@"OK"];
            [dialog show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(IBAction)doneBtnPressed:(id)sender {
    
    NSMutableArray *selectedUsers = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0 ; i < [checkArray count] ; i++) {
        
        NSDictionary *item = [checkArray objectAtIndex:i];
        
        if ([item isEqual:@"1"]) {
            [selectedUsers addObject:[userList objectAtIndex:i]];
            
            NSLog(@"%@", [[userList objectAtIndex:i] objectForKey:@"user_name"]);
        }
    }
    
    [self.delegate addItemViewController:self didFinishAddUsers:selectedUsers];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
