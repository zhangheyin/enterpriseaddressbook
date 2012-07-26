//
//  EnterpriseContactViewController.h
//  TestSQLite
//
//  Created by admin on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnterpriseContactDatabase.h"
#import "ABContact.h"
#import "EnterpriseSearchPinYin.h"
#import <QuartzCore/QuartzCore.h>

@interface EnterpriseContactViewController : UIViewController <ABPersonViewControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, retain) NSArray *enterprise_contacts;
@property (nonatomic, retain) NSArray *filtered_enterprise_contacts;
@property (nonatomic, copy) NSString *company_id;
@property (nonatomic, retain) NSArray *all_keys;
@property (nonatomic) NSInteger sortKindsIndex;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSMutableArray *allDepartments;
@property (retain, nonatomic) UIActionSheet *companyActionSheet;
@property (retain, nonatomic) UIActionSheet *sortDisplayActionSheet;
@property (copy, nonatomic) NSString *companyName;

@property (retain, nonatomic) NSMutableArray* callHistory;
- (NSArray *)fetchAllPinyinKey:(NSArray*)contacts;
- (NSMutableArray *) fetchContactOnASetion:(NSArray *)contacts
                     numberOfRowsInSection:(NSUInteger)section 
                                whichIndex:(NSInteger)sortIndex;
- (void) initTitleView:(NSString *)companyName;

- (void) sortKind;
- (void) intoCompanyOrganization;
@end
