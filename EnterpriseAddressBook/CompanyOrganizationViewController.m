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
@interface CompanyOrganizationViewController ()

@end

@implementation CompanyOrganizationViewController
@synthesize allCompanyOrganization = _allCompanyOrganization;
@synthesize departID = _departID;
@synthesize companyID = _companyID;
- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.allCompanyOrganization = [CompanyOrganization queryAllCompanyOrganization:self.companyID 
                                                                        departID:self.departID];
  
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
                  identifier:(ABMultiValueIdentifier)identifierForValue{
	return YES;
}

- (void)dealloc {
  [self.allCompanyOrganization release];
  [self.companyID release];
  [self.departID release];
  [super dealloc];
}
@end
