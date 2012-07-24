//
//  CompanyOrganizationViewController.h
//  EnterpriseAddressBook
//
//  Created by admin on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>  
#import <AddressBookUI/AddressBookUI.h> 
@interface CompanyOrganizationViewController : UITableViewController <ABPersonViewControllerDelegate>
@property (nonatomic, retain) NSMutableArray *allCompanyOrganization;
@property (nonatomic, copy) NSString *companyID;
@property (nonatomic, copy) NSString *departID;
@end
