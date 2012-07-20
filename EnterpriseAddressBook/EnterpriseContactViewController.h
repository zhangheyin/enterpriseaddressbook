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
@interface EnterpriseContactViewController : UIViewController <ABPersonViewControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) NSArray *enterprise_contacts;
@property (nonatomic, retain) NSArray *filtered_enterprise_contacts;
@property (nonatomic, strong) NSString *company_id;
@property (nonatomic, retain) NSArray *all_keys;
@property (nonatomic) NSInteger sortKindsIndex;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSMutableArray *allDepartments;
- (NSArray *)fetchAllPinyinKey:(NSArray*)contacts;
- (NSMutableArray *) fetchContactOnASetion:(NSArray *)contacts
                     numberOfRowsInSection:(NSUInteger)section 
                                whichIndex:(NSInteger)sortIndex;

- (void) sortKind;
@end
