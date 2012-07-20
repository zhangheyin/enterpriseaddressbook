//
//  EnterpriseContactViewController.m
//  TestSQLite
//
//  Created by admin on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EnterpriseContactViewController.h"
#import "EnterpriseContacts.h"
#import "EnterpriseContact.h"
#import "ContactItemCell.h"

@interface EnterpriseContactViewController ()

@end

@implementation EnterpriseContactViewController

@synthesize enterprise_contacts = _enterprise_contacts;
@synthesize company_id = _company_id;
@synthesize all_keys = _all_keys;
@synthesize tableView = _tableView;
@synthesize filtered_enterprise_contacts = _filtered_enterprise_contacts;



- (void)viewDidLoad {
  [super viewDidLoad];
  NSLog(@"viewDidLoad");
  self.searchDisplayController.searchBar.keyboardType = UIKeyboardTypeNumberPad;
  dispatch_queue_t q = dispatch_queue_create("queue", 0);
  dispatch_async(q, ^{
    self.enterprise_contacts = [EnterpriseContacts contacts:self.company_id];
    //NSLog(@"%@", self.enterprise_contacts);
    self.all_keys = [self fetchAllKey:self.enterprise_contacts];
    dispatch_async(dispatch_get_main_queue(), ^{
      // [self setIsSearching:NO];
      [self.tableView reloadData];
    });
  });
  
  dispatch_release(q);  
}

- (void)viewDidUnload {
  [self setTableView:nil];
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if (tableView == self.searchDisplayController.searchResultsTableView) {
    return 1;
  } else {
    return [self.all_keys count];
  }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {  
	if (tableView == self.searchDisplayController.searchResultsTableView) {
    return [self.filtered_enterprise_contacts count];
  } else {
    return [[self fetchContactOnASetion:self.enterprise_contacts 
                  numberOfRowsInSection:section] count];
  }
}

/*ADD DATE 2012 0706
 FOR FETCH THE CONTACTS AT A SETION CONTACTS LIST
 */
- (NSMutableArray *) fetchContactOnASetion:(NSArray *)contacts
                     numberOfRowsInSection:(NSUInteger)section {
  NSString *key = [self.all_keys objectAtIndex:section];
  
  NSMutableArray *contacts_in_this_section = [[[NSMutableArray alloc] init] autorelease];
  for (EnterpriseContact *aContact in contacts) {
    if ([key isEqualToString:aContact.name_pinyin_index]) {
      [contacts_in_this_section addObject:aContact];
    }
  }
  return contacts_in_this_section;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSDictionary *contact_dict = [[[NSDictionary alloc] init] autorelease];
  //NSLog(@"%@",self.searchDisplayController.searchResultsTableView);
  if (tableView == self.searchDisplayController.searchResultsTableView)	{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    [tableView registerNib:[UINib nibWithNibName:@"ContactCell"  bundle:nil] forCellReuseIdentifier:CellIdentifier];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:cell.frame] autorelease];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0xd9/255.0 green:0x66/255.0 blue:40.f/255.0 alpha:1.0];  
    EnterpriseContact *aContact = [self.filtered_enterprise_contacts objectAtIndex:indexPath.row];
    NSLog(@"%@", aContact);
    //ABContact *contact = //[contact_dict objectForKey:kContact];
    
    UIImageView *contact_image = (UIImageView *)[cell viewWithTag:1000];
    UILabel *name_lable = (UILabel *)[cell viewWithTag:1010];
    UILabel *pinyin_lable = (UILabel *)[cell viewWithTag:1020];
    UILabel *number_lable = (UILabel *)[cell viewWithTag:1030];
    
    name_lable.text = aContact.name;//[contact.contactName isEqualToString:@""] ? contact.emailaddresses : contact.contactName;
    pinyin_lable.text = aContact.name_pinyin;[contact_dict objectForKey:kNamePinyin];
    number_lable.text = aContact.phone_number;//contact.phonenumbers;
    contact_image.image = [UIImage imageNamed:@"Avatar.png"];
    return cell;
  } else {
    static NSString *CustomCellIdentifier = @"ContactItemCell";
    
    //static BOOL nibsRegistered = NO;
    // if (!nibsRegistered) {
    UINib *nib = [UINib nibWithNibName:@"ContactItemCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:CustomCellIdentifier];
    //   nibsRegistered = YES;
    //}
    
    ContactItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    //NSLog(@"%@", self.all_keys);
    EnterpriseContact *aContact = [[self fetchContactOnASetion:self.enterprise_contacts 
                                         numberOfRowsInSection:section] objectAtIndex:row];
    
    
    cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:cell.frame] autorelease];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0xd9/255.0 green:0x66/255.0 blue:40.f/255.0 alpha:1.0]; 
    
    
    cell.name = aContact.name;
    cell.number = aContact.phone_number;
    cell.pinyin = aContact.name_pinyin;
    cell.image =  [UIImage imageNamed:@"Avatar.png"];
    
    return cell;
  } 
}
- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
	if (tableView == self.searchDisplayController.searchResultsTableView) {
    return nil;
  } else {
    NSString *key = [self.all_keys objectAtIndex:section];
    if (key == UITableViewIndexSearch)
      return nil;
    return key;
  } 
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
  if (tableView == self.searchDisplayController.searchResultsTableView) {
    return nil;
  } else {
    return self.all_keys;
  } 
}

- (NSInteger)tableView:(UITableView *)tableView
sectionForSectionIndexTitle:(NSString *)title
               atIndex:(NSInteger)index {
  NSString *key = [self.all_keys objectAtIndex:index];
  if (key == UITableViewIndexSearch) {
    [tableView setContentOffset:CGPointZero animated:NO];
    return NSNotFound;
  } else return index;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }  
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }  
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  // Navigation logic may go here. Create and push another view controller.
  /*
   <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
   // ...
   // Pass the selected object to the new view controller.
   [self.navigationController pushViewController:detailViewController animated:YES];
   [detailViewController release];
   */
  // Fetch the address book 
	//ABAddressBookRef addressBook = ABAddressBookCreate();
	// Search for the person named "Appleseed" in the address book
	//NSArray *people = (NSArray *)ABAddressBookCopyPeopleWithName(addressBook, CFSTR("Appleseed"));
	// Display "Appleseed" information if found in the address book 
	//if ((people != nil) && [people count])
	//{
  NSUInteger section = [indexPath section];
  NSUInteger row = [indexPath row];
  //NSLog(@"%@", self.all_keys);
  
  EnterpriseContact *aContact;
  if (tableView == self.searchDisplayController.searchResultsTableView)	{
    aContact = [self.filtered_enterprise_contacts objectAtIndex:indexPath.row];
    NSLog(@"%@", aContact);
    
  } else {
    
    
    aContact = [[self fetchContactOnASetion:self.enterprise_contacts 
                      numberOfRowsInSection:section] objectAtIndex:row];
    
  }
  ABRecordRef person = [EnterpriseContacts vCardStringtoABRecordRef:aContact.vcard];
  ABPersonViewController *picker = [[[ABPersonViewController alloc] init] autorelease];
  picker.personViewDelegate = self;
  picker.displayedPerson = person;
  // Allow users to edit the person’s information
  picker.allowsEditing = NO;
  picker.title = aContact.name;
  [self.navigationController pushViewController:picker animated:YES];
  //	}
  //	else 
  //	{
  //		// Show an alert if "Appleseed" is not in Contacts
  //		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
  //                                                    message:@"Could not find Appleseed in the Contacts application" 
  //                                                   delegate:nil 
  //                                          cancelButtonTitle:@"Cancel" 
  //                                          otherButtonTitles:nil];
  //		[alert show];
  //		[alert release];
  //	}
	
	//[people release];
	//CFRelease(addressBook);
}

/*add 20120710*/

- (NSArray *)fetchAllKey:(NSArray*)contacts {
  NSMutableArray *keyArray = [[[NSMutableArray alloc] init] autorelease];
  
  for (EnterpriseContact *aContacts in contacts) {
    [keyArray addObject:aContacts.name_pinyin_index];
  }
  NSSet *keySet = [NSSet setWithArray:keyArray];
  //NSLog(@"%@",key_set);
  NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES] autorelease];
  NSArray *sortedArray = [[keySet allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
  //NSLog(@"%@", arr1);
  NSMutableArray *allKey = [NSMutableArray arrayWithArray:sortedArray];
  [allKey insertObject:UITableViewIndexSearch atIndex:0];
  return allKey;
}

- (void)fetchContacts {
  //  dispatch_queue_t q = dispatch_queue_create("queue", 0);
  //  dispatch_async(q, ^{  
  //    NSArray *con = [EnterpriseContacts contacts:self.company_id];
  //    //self.contacts = [ABContactsHelper contacts];
  //    dispatch_async(dispatch_get_main_queue(), ^{
  //      self.enterprise_contacts = con;
  //    });
  //  });
  //  dispatch_release(q);
  //   
}
#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
  //执行姓名首字母的
  // [self fetchContacts];
  NSArray *resultOfKeyPinyin = [EnterpriseSearchPinYin executePinyinKeySearch2:searchText 
                                                                   addressBook:self.enterprise_contacts];  
  //执行号码的检索
  //[self fetchContacts];
  NSArray *resultOfNumberSearch = [EnterpriseSearchPinYin executeNumberSearch:searchText 
                                                                  addressBook:self.enterprise_contacts];
  //执行全拼的检索
  //[self fetchContacts];
  NSArray *resultOfDetailPinyin = [EnterpriseSearchPinYin executeDetailPinyinSearch:searchText 
                                                                        addressBook:self.enterprise_contacts];
  //NSLog(@"~~~~~~2~~~~~~~");    
  NSArray *finalResult = [[resultOfKeyPinyin arrayByAddingObjectsFromArray:resultOfNumberSearch] arrayByAddingObjectsFromArray:resultOfDetailPinyin];
  //NSLog(@"%@", final_result);    
  NSSet *set = [NSSet setWithArray:finalResult];
  
  self.filtered_enterprise_contacts = [set allObjects];
  //NSLog(@"%@", self.filtered_enterprise_contacts);
}


#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchString:(NSString *)searchString {
  [self filterContentForSearchText:searchString scope:
   [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
  
  // Return YES to cause the search result table view to be reloaded.
  return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchScope:(NSInteger)searchOption {
  [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
   [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
  
  // Return YES to cause the search result table view to be reloaded.
  return YES;
}

- (void)dealloc {
  [_tableView release];
  [_enterprise_contacts release];
  [_filtered_enterprise_contacts release];
  [_company_id release];
  [_all_keys release];
  
  [super dealloc];
}

#pragma mark ABPersonViewControllerDelegate methods
// Does not allow users to perform default actions such as dialing a phone number, when they select a contact property.
- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person 
                    property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifierForValue{
	return NO;
}

@end
