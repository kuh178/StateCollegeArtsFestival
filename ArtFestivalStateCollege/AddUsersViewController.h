//
//  AddUsersViewController.h
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 6/19/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

// ref: http://www.faqoverflow.com/stackoverflow/5210535.html
@class AddUsersViewController;
@protocol AddUsersViewControllerDelegate <NSObject>
-(void)addItemViewController:(AddUsersViewController *)controller didFinishAddUsers:(NSArray *)array;
@end

@interface AddUsersViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray              *userList;
    NSMutableArray              *jsonArray;
    NSIndexPath                 *lastIndexPath;
    
    NSMutableArray              *checkArray;
    
    IBOutlet UITableView        *tableViewList;
    IBOutlet UIBarButtonItem    *doneBtn;
}

@property (nonatomic, retain) NSMutableArray            *userList;
@property (nonatomic, retain) NSMutableArray            *jsonArray;
@property (nonatomic, retain) NSIndexPath               *lastIndexPath;

@property (nonatomic, retain) NSMutableArray            *checkArray;

@property (nonatomic, retain) IBOutlet UITableView      *tableViewList;
@property (nonatomic, retain) IBOutlet UIBarButtonItem  *doneBtn;

@property (nonatomic, weak) id <AddUsersViewControllerDelegate> delegate;

-(IBAction)doneBtnPressed:(id)sender;

@end

