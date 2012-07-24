//
//  ContatsViewController.m
//  Tabbar_iOS5
//
//  Created by admin on 12-7-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactItemCell.h"
@interface ContactsViewController ()

@end

@implementation ContactsViewController
@synthesize tableView = _tableView;

@synthesize contacts = _contacts;
@synthesize filteredListContent = _filteredListContent;
@synthesize all_keys = _all_keys;



- (void)viewDidLoad {
  self.searchDisplayController.searchBar.keyboardType = UIKeyboardTypeNumberPad;
  [self.searchDisplayController.searchBar setTintColor:[UIColor colorWithRed:0xcc/255.0 green:0x33/255.0 blue:0.f/255.0 alpha:1.0]];
  UIBarButtonItem *rightButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd     
                                                                                 target:self 
                                                                                action:@selector(showNewPersonViewController)];
                                   
  self.navigationItem.rightBarButtonItem = rightButton;
  [rightButton release]; 
  //self.tableView.clearsContextBeforeDrawing = NO;
  
  dispatch_queue_t q = dispatch_queue_create("queue", 0);
  dispatch_async(q, ^{
    self.contacts = [ABContactsHelper contacts]; 
    self.all_keys = [self fetchAllKey:self.contacts];
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


- (void)viewWillAppear:(BOOL)animated{
  dispatch_queue_t q = dispatch_queue_create("queue", 0);
  dispatch_async(q, ^{
    self.contacts = [ABContactsHelper contacts]; 
    self.all_keys = [self fetchAllKey:self.contacts];
    dispatch_async(dispatch_get_main_queue(), ^{
      // [self setIsSearching:NO];
      [self.tableView reloadData];
    });
  });
  dispatch_release(q);  
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (NSArray *)fetchAllKey:(NSArray*)contacts {
  NSMutableArray *key_array = [[[NSMutableArray alloc] init] autorelease];
  [key_array addObject:UITableViewIndexSearch];
  for (NSDictionary *aContacts in contacts) {
    [key_array addObject:[aContacts objectForKey:kNamePinyinKey]];
  }
  
  return [[NSSet setWithArray:key_array] allObjects];
}


/*ADD DATE 2012 0706
 FOR FETCH THE CONTACTS AT A SETION CONTACTS LIST
 */
- (NSMutableArray *) fetchContactOnASetion:(NSArray *)contacts
                     numberOfRowsInSection:(NSUInteger)section {
  NSString *key = [self.all_keys objectAtIndex:section];
  
  NSMutableArray *contacts_in_this_section = [[[NSMutableArray alloc] init] autorelease];
  for (NSDictionary *aContact in contacts) {
    if ([key isEqualToString:[aContact objectForKey:kNamePinyinKey]]) {
      [contacts_in_this_section addObject:aContact];
    }
  }
  return contacts_in_this_section;
}

-(void)showNewPersonViewController {
	ABNewPersonViewController *picker = [[ABNewPersonViewController alloc] init];
	picker.newPersonViewDelegate = self;
	
	UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:picker];
	[self presentModalViewController:navigation animated:YES];
	[navigation.navigationBar setTintColor:[UIColor colorWithRed:0xcc/255.0 green:0x33/255.0 blue:0.f/255.0 alpha:1.0]];
	[picker release];
	[navigation release];	
  //[self.tableView reloadData];
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
    return [self.filteredListContent count];
  } else {
    return [[self fetchContactOnASetion:self.contacts 
                  numberOfRowsInSection:section] count];
  }
}


- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSDictionary *contact_dict = [[[NSDictionary alloc] init] autorelease];
  //NSLog(@"%@",self.searchDisplayController.searchResultsTableView);
  if (tableView == self.searchDisplayController.searchResultsTableView) {
    static NSString *CellIdentifier = @"CellIdentifier";
    
    [tableView registerNib:[UINib nibWithNibName:@"ContactCell" 
                                          bundle:nil] 
    forCellReuseIdentifier:CellIdentifier];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:cell.frame] autorelease];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0xd9/255.0 green:0x66/255.0 blue:40.f/255.0 alpha:1.0];   
    contact_dict = [self.filteredListContent objectAtIndex:indexPath.row];
    ABContact *contact = [contact_dict objectForKey:kContact];
    
    UIImageView *contact_image = (UIImageView *)[cell viewWithTag:1000];
    UILabel *name_lable = (UILabel *)[cell viewWithTag:1010];
   // UILabel *pinyin_lable = (UILabel *)[cell viewWithTag:1020];
    UILabel *number_lable = (UILabel *)[cell viewWithTag:1030];
    
    name_lable.text = [contact.contactName isEqualToString:@""] ? @"未命名" : contact.contactName;
   // pinyin_lable.text = [contact_dict objectForKey:kNamePinyin];
    number_lable.text = [contact.phoneArray objectAtIndex:0];
    contact_image.image = [UIImage imageNamed:@"Avatar.png"];
    return cell;
  }	else {
    static NSString *CustomCellIdentifier = @"ContactItemCell";
    
    static BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
      UINib *nib = [UINib nibWithNibName:@"ContactItemCell" bundle:nil];
      [tableView registerNib:nib forCellReuseIdentifier:CustomCellIdentifier];
      nibsRegistered = YES;
    }
    
    ContactItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:cell.frame] autorelease];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0xd9/255.0 green:0x66/255.0 blue:40.f/255.0 alpha:1.0];  
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    //NSLog(@"%@", self.all_keys);
    NSDictionary *contact_dict_section = [[self fetchContactOnASetion:self.contacts 
                                                numberOfRowsInSection:section] objectAtIndex:row];
    
    ABContact *contact = [contact_dict_section objectForKey:kContact];
    cell.name = [contact.contactName isEqualToString:@""] ? @"未命名" : contact.contactName;
    cell.number = [contact.phoneArray objectAtIndex:0];
  //  cell.pinyin = [contact_dict_section objectForKey:kNamePinyin];
    cell.image = (contact.image) ? contact.image : [UIImage imageNamed:@"Avatar.png"];
    
    return cell;
  } 
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
	if (tableView == self.searchDisplayController.searchResultsTableView)	{
    return nil;
  }	else	{
    NSString *key = [self.all_keys objectAtIndex:section];
    if (key == UITableViewIndexSearch)
      return nil;
    return key;
  }    
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
  if (tableView == self.searchDisplayController.searchResultsTableView)	{
    return nil;
  }	else	{
    return self.all_keys;
  }   
}

- (NSInteger)tableView:(UITableView *)tableView
sectionForSectionIndexTitle:(NSString *)title
               atIndex:(NSInteger)index {
  
  if (tableView == self.searchDisplayController.searchResultsTableView)	{
    return NSNotFound;
  }	else	{
    NSString *key = [self.all_keys objectAtIndex:index];
    if (key == UITableViewIndexSearch) {
      [tableView setContentOffset:CGPointZero animated:NO];
      return NSNotFound;
    } else return index;
  }    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

  NSUInteger section = [indexPath section];
  NSUInteger row = [indexPath row];
  //NSLog(@"%@", self.all_keys);
  ABContact *contact;
  if (tableView == self.searchDisplayController.searchResultsTableView)	{
    NSDictionary *contact_dict = [self.filteredListContent objectAtIndex:indexPath.row];
    contact = [contact_dict objectForKey:kContact];
  } else {
    NSDictionary *contact_dict_section = [[self fetchContactOnASetion:self.contacts 
                                                numberOfRowsInSection:section] objectAtIndex:row];
    contact = [contact_dict_section objectForKey:kContact];
  }
  ABRecordRef person = contact.record;
  ABPersonViewController *picker = [[[ABPersonViewController alloc] init] autorelease];
  picker.personViewDelegate = self;
  picker.displayedPerson = person;
  // Allow users to edit the person’s information
  picker.allowsEditing = YES;
  
  [self.navigationController pushViewController:picker animated:YES];
}

- (void)fetchContacts
{
  //dispatch_queue_t q = dispatch_queue_create("queue", 0);
  //dispatch_async(q, ^{
  //    self.contacts = [ABContactsHelper contacts]; 
  //   dispatch_async(dispatch_get_main_queue(), ^{
  //self.contacts = array;
  //   });
  //});
  
  // dispatch_release(q);  
  
  
  
  // [self performSelectorOnMainThread:@selector(fetch) withObject:nil waitUntilDone:NO];
}

#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
  /*执行姓名首字母的*/
  [self fetchContacts];
  //NSLog(@"filterContentForSearchText start");
  NSArray *result_of_key_pinyin = [SearchPinYin executePinyinKeySearch2:searchText 
                                                            addressBook:self.contacts];    
  /*执行号码的检索*/
  //[self fetchContacts];
  NSArray *result_of_number_search = [SearchPinYin executeNumberSearch:searchText 
                                                           addressBook:self.contacts];
  /*执行全拼的检索*/
  //[self fetchContacts];
  NSArray *result_of_detail_pinyin = [SearchPinYin executeDetailPinyinSearch:searchText 
                                                                 addressBook:self.contacts];
  
  //NSLog(@"~~~~~~2~~~~~~~");        
  NSArray *final_result = [[result_of_key_pinyin arrayByAddingObjectsFromArray:result_of_number_search] arrayByAddingObjectsFromArray:result_of_detail_pinyin];
 // NSLog(@"filterContentForSearchText finish");
  self.filteredListContent = [final_result copy];
}


#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
  [self filterContentForSearchText:searchString scope:
   [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
  return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
  [self filterContentForSearchText:[self.searchDisplayController.searchBar text] 
                             scope:
   [[self.searchDisplayController.searchBar 
     scopeButtonTitles] 
    objectAtIndex:searchOption]];
  return YES;
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//  //UILabel *or = (UILabel *)tableView.tableHeaderView
//  
//  UIView* sectionHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 18)];
//  sectionHead.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
//  sectionHead.userInteractionEnabled = YES;
//  sectionHead.tag = section;
//  
//  UIImageView *headerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PlainTableViewSectionHeader.png"]];
//  headerImage.contentMode = UIViewContentModeScaleAspectFit;
//  
//  [sectionHead addSubview:headerImage];
//  [headerImage release];
//  
//  UILabel *sectionText = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, tableView.bounds.size.width - 10, 18)];
//  sectionText.text = [self.all_keys objectAtIndex:section];
//  sectionText.backgroundColor = [UIColor greenColor];
//  sectionText.textColor = [UIColor whiteColor];
//  sectionText.shadowColor = [UIColor darkGrayColor];
//  sectionText.shadowOffset = CGSizeMake(0,1);
//  sectionText.font = [UIFont boldSystemFontOfSize:18];
//  
//  [sectionHead addSubview:sectionText];
//  [sectionText release];
//  
//  return [sectionHead autorelease];
//}

- (void)dealloc {
  [_tableView release];
  [_contacts release];
  [_filteredListContent release];
  [_all_keys release];

  [super dealloc];
}

#pragma mark ABPersonViewControllerDelegate methods
// Does not allow users to perform default actions such as dialing a phone number, when they select a contact property.
- (BOOL)personViewController:(ABPersonViewController *)personViewController 
shouldPerformDefaultActionForPerson:(ABRecordRef)person 
                    property:(ABPropertyID)property 
                  identifier:(ABMultiValueIdentifier)identifierForValue{
	return YES;
}


#pragma mark ABNewPersonViewControllerDelegate methods
// Dismisses the new-person view controller. 
- (void)newPersonViewController:(ABNewPersonViewController *)newPersonViewController didCompleteWithNewPerson:(ABRecordRef)person
{
	[self dismissModalViewControllerAnimated:YES];
}
@end
