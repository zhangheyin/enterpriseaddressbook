//
//  CompanyOrganizationViewController.m
//  EnterpriseAddressBook
//
//  Created by admin on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CompanyOrganizationViewController.h"
#import "CompanyOrganization.h"
#import "EnterpriseContacts.h"
#import "ABContact.h"
#import "CallHistory.h"
#import "Company.h"
#import "EnterpriseNameDatabase.h"
@interface CompanyOrganizationViewController ()

@end

@implementation CompanyOrganizationViewController
@synthesize allCompanyOrganization = _allCompanyOrganization;
@synthesize departID = _departID;
@synthesize companyID = _companyID;
@synthesize companyName = _companyName;
@synthesize callHistory = _callHistory;

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self initTitleView:self.companyName];
  self.allCompanyOrganization = [CompanyOrganization queryAllCompanyOrganization:self.companyID 
                                                                        departID:self.departID];
  self.callHistory = [CallHistory loadCallRecordFromFilePath:[CallHistory filePathName]];
 // NSLog(@"%@", self.allCompanyOrganization);
  // Uncomment the following line to preserve selection between presentations.
  self.clearsSelectionOnViewWillAppear = NO;
  
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload {
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section{
  return [self.allCompanyOrganization count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"CompanyOrganization";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) { 
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]; 
  }   
  // Configure the cell...
  CompanyOrganization *aCompanyOrganization = [self.allCompanyOrganization objectAtIndex:[indexPath row]];
  
  cell.textLabel.text = aCompanyOrganization.departName;
  cell.imageView.image = (!aCompanyOrganization.id) ? [UIImage imageNamed:@"ICON_Group.png"] : [UIImage imageNamed:@"ICON_Person.png"];
  
  return cell;
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
  
  CompanyOrganization *aCompanyOrganization = [self.allCompanyOrganization objectAtIndex:[indexPath row]];
  
  if (aCompanyOrganization.id) {
    ABRecordRef person = [EnterpriseContacts vCardStringtoABRecordRef:aCompanyOrganization.vCard];
    ABPersonViewController *picker = [[[ABPersonViewController alloc] init] autorelease];
    ABContact *aContact = [ABContact contactWithRecord:person];
    
    picker.personViewDelegate = self;
    picker.displayedPerson = person;
    // Allow users to edit the person’s information
    picker.allowsEditing = NO;
    picker.title = aContact.contactName;
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
  } else {
    CompanyOrganizationViewController *covc = [[[CompanyOrganizationViewController alloc] init] autorelease];
    covc.departID = aCompanyOrganization.depart_id;
    covc.companyID = aCompanyOrganization.company_id;
    covc.title = aCompanyOrganization.departName;
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
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    [self.navigationController pushViewController:covc animated:NO];
  }
}

#pragma mark ABPersonViewControllerDelegate methods
// Does not allow users to perform default actions such as dialing a phone number, when they select a contact property.
- (BOOL)personViewController:(ABPersonViewController *)personViewController 
shouldPerformDefaultActionForPerson:(ABRecordRef)person 
                    property:(ABPropertyID)property 
                  identifier:(ABMultiValueIdentifier)identifierForValue {
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

	return YES;
}

- (void) companyList {
  NSMutableArray *companyList = [EnterpriseNameDatabase queryEnterpriseName];
  UIActionSheet *companyActionSheet = [[UIActionSheet alloc] initWithTitle:@"公司列表"  
                                                        delegate:self  
                                               cancelButtonTitle:nil  
                                          destructiveButtonTitle:nil  
                                               otherButtonTitles:nil];  
  // 逐个添加按钮（比如可以是数组循环）  
  for (Company *aCompany in companyList) {
    [companyActionSheet addButtonWithTitle:aCompany.companyName];
  }
  // 同时添加一个取消按钮  
  [companyActionSheet addButtonWithTitle:@"取消"];  
  // 将取消按钮的index设置成我们刚添加的那个按钮，这样在delegate中就可以知道是那个按钮  
  companyActionSheet.cancelButtonIndex = companyActionSheet.numberOfButtons-1;
  companyActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
  [companyActionSheet showInView:[UIApplication sharedApplication].keyWindow];
  [companyActionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
  if  (buttonIndex < [[EnterpriseNameDatabase queryEnterpriseName] count]) {
    Company *defultCompany = [[EnterpriseNameDatabase queryEnterpriseName] objectAtIndex:buttonIndex];
    [self initTitleView:defultCompany.companyName];
    self.companyName = defultCompany.companyName;
    self.companyID = defultCompany.companyID;
    self.allCompanyOrganization = [CompanyOrganization queryAllCompanyOrganization:self.companyID 
                                                                          departID:self.departID];
    [self.tableView reloadData];
  }
}

- (void) initTitleView:(NSString *)companyName {
  UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 240, 20)];//allocate titleView
  UIButton *btnNormal = [UIButton buttonWithType:UIButtonTypeCustom];
  [btnNormal setFrame:CGRectMake(0, 0, 240, 20)];
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

- (void)dealloc {
  [self.allCompanyOrganization release];
  [self.companyID release];
  [self.departID release];
  [self.companyName release];
  [self.callHistory release];
  
  [super dealloc];
}
@end
