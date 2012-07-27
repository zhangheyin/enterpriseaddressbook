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
#import "CompanyOrganizationViewController.h"
#import "EnterpriseNameDatabase.h"
#import "Company.h"
#import "CallHistory.h"
@interface EnterpriseContactViewController ()

@end

@implementation EnterpriseContactViewController

@synthesize enterprise_contacts = _enterprise_contacts;
@synthesize company_id = _company_id;
@synthesize all_keys = _all_keys;
@synthesize tableView = _tableView;
@synthesize filtered_enterprise_contacts = _filtered_enterprise_contacts;
@synthesize sortKindsIndex = _sortKindsIndex;
@synthesize allDepartments = _allDepartments;
@synthesize companyActionSheet = _companyActionSheet;
@synthesize sortDisplayActionSheet = _sortDisplayActionSheet;
@synthesize callHistory = _callHistory;
@synthesize companyName = _companyName;

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.searchDisplayController.searchBar setTintColor:[UIColor colorWithRed:0xcc/255.0 
                                                                       green:0x33/255.0 
                                                                        blue:0.f/255.0 
                                                                       alpha:1.0]];
  UIBarButtonItem *rightButton  = [[UIBarButtonItem alloc]initWithTitle:@"排序方式" 
                                                                  style:UIBarButtonItemStyleBordered 
                                                                 target:self 
                                                                 action:@selector(sortKind)];
  
  UIBarButtonItem *leftButton   = [[UIBarButtonItem alloc]initWithTitle:@"组织结构" 
                                                                  style:UIBarButtonItemStyleBordered 
                                                                 target:self 
                                                                 action:@selector(intoCompanyOrganization)];
  self.navigationItem.rightBarButtonItem = rightButton;
  self.navigationItem.leftBarButtonItem = leftButton;
  
  self.sortDisplayActionSheet = [[UIActionSheet alloc] init];
  self.companyActionSheet = [[UIActionSheet alloc] init];
  
  Company *defultCompany = [[EnterpriseNameDatabase queryEnterpriseName] objectAtIndex:0];
  self.company_id = defultCompany.companyID; 
  self.companyName = defultCompany.companyName;
  [self initTitleView:self.companyName];  

  dispatch_queue_t q = dispatch_queue_create("queue", 0);
  dispatch_async(q, ^{
    
    self.enterprise_contacts = [EnterpriseContacts contacts:self.company_id];
    //NSLog(@"%@", self.enterprise_contacts);
    self.all_keys = [self fetchAllPinyinKey:self.enterprise_contacts];
    self.allDepartments = [EnterpriseContactDatabase queryAllEnterpriseDepartments:self.company_id];
    self.callHistory = [CallHistory loadCallRecordFromFilePath:[CallHistory filePathName]];
    
    dispatch_async(dispatch_get_main_queue(), ^{

      [self.searchDisplayController.searchBar setPlaceholder:[NSString stringWithFormat:@"联系人搜索 | 共有%i个企业联系人", [self.enterprise_contacts count]]];
      [self.tableView reloadData];
    });
  });
  dispatch_release(q);  
   //self.navigationItem.titleView = bt;  //self.navigationItem.titleView = self.dropDownList;
  [rightButton release];  
  [leftButton release];
  self.searchDisplayController.searchBar.keyboardType = UIKeyboardTypeNumberPad;
}

- (void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
//  dispatch_queue_t q = dispatch_queue_create("queue", 0);
//  dispatch_async(q, ^{
//    //[self copyFileDatabase];
//    self.enterprise_contacts = [EnterpriseContacts contacts:self.company_id];
//    //NSLog(@"%@", self.enterprise_contacts);
//    self.all_keys = [self fetchAllPinyinKey:self.enterprise_contacts];
//    self.allDepartments = [EnterpriseContactDatabase queryAllEnterpriseDepartments:self.company_id];
    self.callHistory = [CallHistory loadCallRecordFromFilePath:[CallHistory filePathName]];
//    
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//      [self.searchDisplayController.searchBar setPlaceholder:[NSString stringWithFormat:@"联系人搜索 | 共有%i个企业联系人", [self.enterprise_contacts count]]];
//      [self.tableView reloadData];
//    });
//  });
//  
//  dispatch_release(q);  
//  Company *defultCompany = [[EnterpriseNameDatabase queryEnterpriseName] objectAtIndex:0];
//  self.company_id = defultCompany.companyID; 
//  self.companyName = defultCompany.companyName;
//  [self initTitleView:defultCompany.companyName];
}

- (void) initTitleView:(NSString *)companyName {
  UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];//allocate titleView
  UIButton *btnNormal = [UIButton buttonWithType:UIButtonTypeCustom];
  [btnNormal setFrame:CGRectMake(0, 0, 150, 20)];
  [btnNormal addTarget:self action:@selector(companyList) forControlEvents:UIControlEventTouchUpInside];
  //[btnNormal setBackgroundImage:[UIImage imageNamed:@"icon_question_info.png"] forState:UIControlStateNormal ];
  
  [btnNormal setTitle:companyName forState:UIControlStateNormal];
  //[btnNormal setFont:[UIFont systemFontOfSize:8]];
  // btnNormal.titleLabel.font = [UIFont systemFontOfSize:12];
  
  btnNormal.titleLabel.textAlignment = UITextAlignmentCenter;
  btnNormal.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
  btnNormal.titleLabel.numberOfLines = 0;     // 不可少Label属性之一
  btnNormal.titleLabel.lineBreakMode = UILineBreakModeCharacterWrap;    // 不可少Label属性之二
  [titleView addSubview:btnNormal];
  
  //  UILabel *titleText = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 100, 20)];//allocate titleText
  //  titleText.textColor = [UIColor whiteColor];
  //  titleText.backgroundColor = [UIColor clearColor];
  //  [titleText setText:companyName];
  //  //[titleView addSubview:titleText];
  //  [titleText release];//release titleText 
  self.navigationItem.titleView = titleView;
  [titleView release];//release titleView
  
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

- (void) intoCompanyOrganization {
  CompanyOrganizationViewController *covc = [[[CompanyOrganizationViewController alloc] init] autorelease];
  covc.departID = @"0";
  covc.companyID = self.company_id;//@"3";
  covc.companyName = self.companyName;
  //covc.title = @"组织结构";
  
  CATransition *animation = [CATransition animation];  
  //动画时间  
  animation.duration = .5f;  
  //display mode, slow at beginning and end  
  animation.timingFunction = UIViewAnimationCurveEaseInOut;  
  //过渡效果  
  animation.type = @"cube";  
  //过渡方向  
  animation.subtype = kCATransitionFromRight;  
  //暂时不知,感觉与Progress一起用的,如果不加,Progress好像没有效果  
  // animation.fillMode = kCAFillModeBackwards;  
  //动画开始(在整体动画的百分比).  
  //animation.startProgress = 0.3;  
  // [imageView.layer addAnimation:animation forKey:nil];  
  [self.navigationController.view.layer addAnimation:animation 
                                              forKey:nil];
  [self.navigationController pushViewController:covc animated:NO];
}

- (void) sortKind {
  self.sortDisplayActionSheet = [[UIActionSheet alloc] initWithTitle:@"排序方式" 
                                                            delegate:(id<UIActionSheetDelegate>)self   
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:nil//@"修改联系人" 
                                                   otherButtonTitles:@"按姓名排序", @"按部门排序", nil];
  
  self.sortDisplayActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
  //[popupQuery showFromTabBar:(UITabBar *)self.tabBarController.view];
  [self.sortDisplayActionSheet showInView:[UIApplication sharedApplication].keyWindow];
  // [self.sortDisplayActionSheet release];
}

- (void) companyList {
  NSMutableArray *companyList = [EnterpriseNameDatabase queryEnterpriseName];
  self.companyActionSheet = [[UIActionSheet alloc] initWithTitle:@"公司列表"  
                                                        delegate:self  
                                               cancelButtonTitle:nil  
                                          destructiveButtonTitle:nil  
                                               otherButtonTitles:nil];  
  // 逐个添加按钮（比如可以是数组循环）  
  for (Company *aCompany in companyList) {
    [self.companyActionSheet addButtonWithTitle:aCompany.companyName];
  }
  // 同时添加一个取消按钮  
  [self.companyActionSheet addButtonWithTitle:@"取消"];  
  // 将取消按钮的index设置成我们刚添加的那个按钮，这样在delegate中就可以知道是那个按钮  
  self.companyActionSheet.cancelButtonIndex = self.companyActionSheet.numberOfButtons-1;
  self.companyActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
  [self.companyActionSheet showInView:[UIApplication sharedApplication].keyWindow];
  //[sheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
  if (actionSheet == self.sortDisplayActionSheet) {
    switch (buttonIndex) {
      case 0:
        self.sortKindsIndex = 0;
        break;
      case 1:
        self.sortKindsIndex = 1;
        break;
      default:
        break;
    }
    [self.tableView reloadData];
  } else {
    if  (buttonIndex < [[EnterpriseNameDatabase queryEnterpriseName] count]) {
      Company *defultCompany = [[EnterpriseNameDatabase queryEnterpriseName] objectAtIndex:buttonIndex];
      self.company_id = defultCompany.companyID;
      self.enterprise_contacts = [EnterpriseContacts contacts:self.company_id];
      self.all_keys = [self fetchAllPinyinKey:self.enterprise_contacts];
      self.allDepartments = [EnterpriseContactDatabase queryAllEnterpriseDepartments:self.company_id];
      [self.searchDisplayController.searchBar setPlaceholder:[NSString stringWithFormat:@"联系人搜索 | 共有%i个企业联系人", [self.enterprise_contacts count]]];
      [self initTitleView:defultCompany.companyName];
      self.companyName = defultCompany.companyName;
      [self.tableView reloadData];
    }
  }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if (tableView == self.searchDisplayController.searchResultsTableView) {
    return 1;
  } else {
    NSInteger sectionCount = 0;
    switch (self.sortKindsIndex) {
      case 0:
        sectionCount = [self.all_keys count];
        break;
      case 1:
        sectionCount = [self.allDepartments count];
        break;
      default:
        break;
    }
    
    return sectionCount;
  }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {  
	if (tableView == self.searchDisplayController.searchResultsTableView) {
    return [self.filtered_enterprise_contacts count];
  } else {
    switch (self.sortKindsIndex) {
      case 0:
        return [[self fetchContactOnASetion:self.enterprise_contacts 
                      numberOfRowsInSection:section 
                                 whichIndex:self.sortKindsIndex] count];
        break;
      case 1:
        return [[self fetchContactOnASetion:self.enterprise_contacts 
                      numberOfRowsInSection:section  
                                 whichIndex:self.sortKindsIndex] count];
        break;
      default:
        break;
    }
    
    
  }
  return 0;
}

/*ADD DATE 2012 0706
 FOR FETCH THE CONTACTS AT A SETION CONTACTS LIST */
- (NSMutableArray *) fetchContactOnASetion:(NSArray *)contacts
                     numberOfRowsInSection:(NSUInteger)section 
                                whichIndex:(NSInteger)sortIndex {
  switch (sortIndex) {
    case 0:{
      NSString *key = [self.all_keys objectAtIndex:section];
      
      NSMutableArray *contacts_in_this_section = [[[NSMutableArray alloc] init] autorelease];
      for (EnterpriseContact *aContact in contacts) {
        if ([key isEqualToString:aContact.name_pinyin_index]) {
          [contacts_in_this_section addObject:aContact];
        }
      }
      return contacts_in_this_section;
    }
      break;
    case 1:{
      NSMutableArray *contacts_in_this_section = [[[NSMutableArray alloc] init] autorelease];
      NSString *key = [[[self.allDepartments objectAtIndex:section] allKeys] objectAtIndex:0];
      
      for (EnterpriseContact *aContact in contacts) {
        //NSLog(@"%@", aContact.depart_id);
        if ([key isEqualToString:aContact.depart_id]) {
          [contacts_in_this_section addObject:aContact];
        }
      }
      return contacts_in_this_section;
    }
      break;
    default:
      break;
  }
  
  return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  //NSDictionary *contact_dict = [[[NSDictionary alloc] init] autorelease];
  //NSLog(@"%@",self.searchDisplayController.searchResultsTableView);
  if (tableView == self.searchDisplayController.searchResultsTableView)	{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    [tableView registerNib:[UINib nibWithNibName:@"ContactCell"  bundle:nil] forCellReuseIdentifier:CellIdentifier];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:cell.frame] autorelease];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0xd9/255.0 green:0x66/255.0 blue:40.f/255.0 alpha:1.0];  
    EnterpriseContact *aContact = [self.filtered_enterprise_contacts objectAtIndex:indexPath.row];
    // NSLog(@"%@", aContact);
    //ABContact *contact = //[contact_dict objectForKey:kContact];
    
    UIImageView *contact_image = (UIImageView *)[cell viewWithTag:1000];
    UILabel *name_lable = (UILabel *)[cell viewWithTag:1010];
    //  UILabel *pinyin_lable = (UILabel *)[cell viewWithTag:1020];
    //  UILabel *number_lable = (UILabel *)[cell viewWithTag:1030];
    
    name_lable.text = aContact.name;//[contact.contactName isEqualToString:@""] ? contact.emailaddresses : contact.contactName;
    // pinyin_lable.text = aContact.name_pinyin;[contact_dict objectForKey:kNamePinyin];
    // number_lable.text = aContact.phone_number;//contact.phonenumbers;
    contact_image.image = [UIImage imageNamed:@"ICON_Person.png"];
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
                                         numberOfRowsInSection:section 
                                                    whichIndex:self.sortKindsIndex] objectAtIndex:row];
    
    cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:cell.frame] autorelease];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0xd9/255.0 green:0x66/255.0 blue:40.f/255.0 alpha:1.0]; 
    
    cell.name = aContact.name;
    //    cell.number = aContact.phone_number;
    // cell.pinyin = aContact.name_pinyin;
    cell.image =  [UIImage imageNamed:@"ICON_Person.png"];
    
    return cell;
  } 
}
- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
	if (tableView == self.searchDisplayController.searchResultsTableView) {
    return nil;
  } else {
    NSString *titleHeader = [[[NSString alloc] init] autorelease];
    switch (self.sortKindsIndex) {
      case 0: {
        titleHeader = [self.all_keys objectAtIndex:section];
        if (titleHeader == UITableViewIndexSearch)
          return nil;
        return titleHeader;
      }
        break;
      case 1:
        titleHeader = [[[self.allDepartments objectAtIndex:section] allValues] objectAtIndex:0];
        return titleHeader;        
        break;
      default:
        break;
        return nil;
    }
  } 
  return nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
  if (tableView == self.searchDisplayController.searchResultsTableView) {
    return nil;
  } else {
    switch (self.sortKindsIndex) {
      case 0:
        return self.all_keys;
        break;
      case 1: {
        NSMutableArray *allDepartmentsName = [[[NSMutableArray alloc] init] autorelease];
        
        for (NSDictionary *singleDepartment in allDepartmentsName) {
          [allDepartmentsName addObject: [[singleDepartment allValues] objectAtIndex:0]];
        }
        return allDepartmentsName;
      } 
        break;
        
      default:
        break;
    }
    return nil;
  } 
}

- (NSInteger)tableView:(UITableView *)tableView
sectionForSectionIndexTitle:(NSString *)title
               atIndex:(NSInteger)index {
  NSString *key = [self.all_keys objectAtIndex:index];
  if (key == UITableViewIndexSearch) {
    [tableView setContentOffset:CGPointZero animated:NO];
    return NSNotFound;
  } else 
    return index;
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
  NSUInteger section = [indexPath section];
  NSUInteger row = [indexPath row];
  //NSLog(@"%@", self.all_keys);
  dispatch_queue_t q = dispatch_queue_create("queue", 0);
  dispatch_async(q, ^{
    EnterpriseContact *aContact;
    if (tableView == self.searchDisplayController.searchResultsTableView)	{
      aContact = [self.filtered_enterprise_contacts objectAtIndex:indexPath.row];
      // NSLog(@"%@", aContact); 
    } else {
      
      aContact = [[self fetchContactOnASetion:self.enterprise_contacts 
                        numberOfRowsInSection:section 
                                   whichIndex:self.sortKindsIndex] objectAtIndex:row];
    }
    ABRecordRef person = [EnterpriseContacts vCardStringtoABRecordRef:aContact.vcard];
    ABPersonViewController *picker = [[[ABPersonViewController alloc] init] autorelease];
    picker.personViewDelegate = self;
    picker.displayedPerson = person;
    // Allow users to edit the person’s information
    picker.allowsEditing = NO;
    picker.title = aContact.name;

    
    dispatch_async(dispatch_get_main_queue(), ^{
      
      CATransition *animation = [CATransition animation];  
      //动画时间  
      animation.duration = 0.5f;  
      //display mode, slow at beginning and end  
      animation.timingFunction = UIViewAnimationCurveEaseInOut;  
      //过渡效果  
      animation.type = @"pageCurl";  
      //过渡方向  
      animation.subtype = kCATransitionFromRight;  
      //暂时不知,感觉与Progress一起用的,如果不加,Progress好像没有效果  
      animation.fillMode = kCAFillModeBackwards;  
      //动画开始(在整体动画的百分比).  
      animation.startProgress = 0.3;  
      // [imageView.layer addAnimation:animation forKey:nil];  
      // transition.delegate = self;
      [self.navigationController.view.layer addAnimation:animation forKey:nil];
      [self.navigationController pushViewController:picker animated:NO];

    });
  });
  dispatch_release(q);  
  
	
	//[people release];
	//CFRelease(addressBook);
}



/*add 20120710*/
- (NSArray *)fetchAllPinyinKey:(NSArray*)contacts {
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
  //[self fetchContacts];
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
  [self filterContentForSearchText:searchString 
                             scope:
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
  [_allDepartments release];
  [self.sortDisplayActionSheet release];
  [self.companyActionSheet release];
  [self.companyName release];
  [self.callHistory release];
  [super dealloc];
}

#pragma mark ABPersonViewControllerDelegate methods
// Does not allow users to perform default actions such as dialing a phone number, when they select a contact property.
- (BOOL)personViewController:(ABPersonViewController *)personViewController 
shouldPerformDefaultActionForPerson:(ABRecordRef)person 
                    property:(ABPropertyID)property 
                  identifier:(ABMultiValueIdentifier)identifierForValue {
  self.callHistory = [CallHistory loadCallRecordFromFilePath:[CallHistory filePathName]];
  if (property == kABPersonPhoneProperty) {
    
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    //电话号码
    NSString *phoneNumber = [(NSString*)ABMultiValueCopyValueAtIndex(phoneMulti, identifierForValue) autorelease];
    ABContact *aContact = [ABContact contactWithRecord:person];
    
    NSMutableDictionary *singleCall = [[[NSMutableDictionary alloc] init] autorelease];
    [singleCall setObject:aContact.contactName    forKey:kMain]; 
    [singleCall setObject:@"YES"                  forKey:kHaveContacts];
    [singleCall setObject:phoneNumber             forKey:kTelephoneNumber];
    [singleCall setObject:[CallHistory dialTime]  forKey:kDialTime];
    [self.callHistory insertObject:singleCall atIndex:0];  
    
    [CallHistory saveCallRecord:self.callHistory 
                     toFilePath:[CallHistory filePathName]];
  }
	return YES;
}

@end
