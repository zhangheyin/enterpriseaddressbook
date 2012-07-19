//
//  FirstViewController.h
//  TestTabBar
//
//  Created by Lion User on 12-6-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DialView.h"

static NSString *kTelephoneNumber = @"telephonenumber";
static NSString *kHaveContacts = @"havecontacts";
static NSString *kMain = @"main";
static NSString *kDialTime = @"dialtime";
@interface DialViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (retain, nonatomic) IBOutlet UILabel *diaplayLable;
@property (copy, nonatomic) NSString *telephone_number;
@property (retain, nonatomic) IBOutlet DialView *dialView;
@property  BOOL isHidden;
@property (retain, nonatomic) IBOutlet UITableView *table;
@property (retain, nonatomic) IBOutlet UIButton *number_display;
@property (nonatomic, retain) NSArray *contacts;
@property (nonatomic, retain) NSArray *filteredListContent;
@property (retain, nonatomic) NSMutableDictionary* single_call_history;
@property (retain, nonatomic) NSMutableArray* call_history;
@property BOOL isSearching;
- (void)fetchContacts;
- (IBAction)dialNumber:(UIButton *)sender;
- (void)filterContentForSearchText:(NSString*)searchText;
- (IBAction)back:(UIButton *)sender;
- (NSDate *)dialTime;

@end
