//
//  AddCommentViewController.h
//  ArtFestivalStateCollege
//
//  Created by Kyungsik Han on 6/21/14.
//  Copyright (c) 2014 Kyungsik Han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface AddCommentViewController : GAITrackedViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    
    NSMutableDictionary         *item;
    NSMutableArray              *userCommentsArray;
    
    IBOutlet UITableView        *tableViewList;
    IBOutlet UIButton           *addBtn;
    IBOutlet UITextField        *commentText;
    IBOutlet UIBarButtonItem    *removeBtn;
}

@property (nonatomic, retain) NSMutableDictionary           *item;
@property (nonatomic, retain) NSMutableArray                *userCommentsArray;

@property (nonatomic, retain) IBOutlet UITableView          *tableViewList;
@property (nonatomic, retain) IBOutlet UIButton             *addBtn;
@property (nonatomic, retain) IBOutlet UITextField          *commentText;
@property (nonatomic, retain) IBOutlet UIBarButtonItem      *removeBtn;

-(IBAction)addBtnPressed:(id)sender;
-(IBAction)removeBtnPressed:(id)sender;


@end
