//
//  FirstViewController.h
//  FirstViewController
//
//  Created by Lion User on 12-6-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DialView.h"
#import <QuartzCore/QuartzCore.h>


@interface DialViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
@property (nonatomic, assign) CALayer *layer;
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
@property (retain, nonatomic) NSArray *enterpriseContacts;
@property (retain, nonatomic) UIActionSheet *clearRecordSheet;
@property (retain, nonatomic) UIActionSheet *dialSheet;


- (void)fetchContacts;
- (IBAction)dialNumber:(UIButton *)sender;
- (void)filterContentForSearchText:(NSString*)searchText;
- (IBAction)back:(UIButton *)sender;
- (void) clearRecord;
- (void) saveCallHistory:(NSString *)contactName
              callNumber:(NSString *)callNumber;
@end
