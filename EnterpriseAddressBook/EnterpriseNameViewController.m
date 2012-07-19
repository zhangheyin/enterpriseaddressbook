//
//  EnterpriseNameViewController.m
//  TestSQLite
//
//  Created by admin on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EnterpriseNameViewController.h"
#import "Company.h"
#import "EnterpriseContactViewController.h"

@interface EnterpriseNameViewController ()

@end

@implementation EnterpriseNameViewController
@synthesize enterpriseDatabase = _enterpriseDatabase;
@synthesize enterprise_array = _enterprise_array;
@synthesize tableView = _tableView;


-(void)copyFileDatabase {
  NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];   
  NSString *documentLibraryFolderPath = [documentsDirectory stringByAppendingPathComponent:@"ycontacts.db"];
  if ([[NSFileManager defaultManager] fileExistsAtPath:documentLibraryFolderPath]) {
    NSLog(@"文件已经存在了");
  }else {
    NSString *resourceSampleImagesFolderPath =[[NSBundle mainBundle]
                           pathForResource:@"ycontacts.db"
                           ofType:nil];
    NSData *mainBundleFile = [NSData dataWithContentsOfFile:resourceSampleImagesFolderPath];
    [[NSFileManager defaultManager] createFileAtPath:documentLibraryFolderPath
                        contents:mainBundleFile
                        attributes:nil];
  }
}

-(void)deleteFileDatabade {
  NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];   
  NSString *documentLibraryFolderPath = [documentsDirectory stringByAppendingPathComponent:@"elimimation"];
  [[NSFileManager defaultManager] delete:documentLibraryFolderPath];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self copyFileDatabase];
  self.enterprise_array = [EnterpriseNameDatabase queryEnterpriseName]; 

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
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.enterprise_array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"EnterpriseName";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) { 
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]; 
  } 
  cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:cell.frame] autorelease];
  cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0xd9/255.0 green:0x66/255.0 blue:40.f/255.0 alpha:1.0]; 
  cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
  // Configure the cell...
  Company *aCompany = [self.enterprise_array objectAtIndex:[indexPath row]];
  cell.textLabel.text = aCompany.companyName;
  
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
  EnterpriseContactViewController *ecvc = [[EnterpriseContactViewController alloc] initWithNibName:@"EnterpriseContactViewController" bundle:nil];

  Company *aCompany = [self.enterprise_array objectAtIndex:[indexPath row]];
  NSString *company_id = aCompany.companyID;
  
  [ecvc setCompany_id:company_id];
  [self.navigationController pushViewController:ecvc animated:YES];
  [ecvc release];
  
}

- (void)dealloc {
  [_tableView release];
//  [_enterpriseDatabase release];
  [_enterprise_array release];
  [super dealloc];
}
@end
