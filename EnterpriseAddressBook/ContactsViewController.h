//
//  ContatsViewController.h
//  Tabbar_iOS5
//
//  Created by admin on 12-7-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>  
#import <AddressBookUI/AddressBookUI.h> 
#import "POAPinyin.h"
#import "ABContactsHelper.h"
#import "SearchPinYin.h"

@interface ContactsViewController : UIViewController<ABPersonViewControllerDelegate>
@property (nonatomic, retain) NSArray *contacts;
@property (nonatomic, retain) NSArray *filteredListContent;
@property (nonatomic, retain) NSArray *all_keys;

- (NSMutableArray *) fetchContactOnASetion:(NSArray *)contacts
                     numberOfRowsInSection:(NSUInteger)section;
- (NSArray *)fetchAllKey:(NSArray*)contacts;
@property (retain, nonatomic) IBOutlet UITableView *tableView;

@end
