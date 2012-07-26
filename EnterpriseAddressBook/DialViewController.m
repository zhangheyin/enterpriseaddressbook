//
//  FirstViewController.m
//  FirstViewController
//
//  Created by Lion User on 12-6-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DialViewController.h"
#import "SearchPinYin.h"
#import "CallRecordCell.h"
#import "CallRecord.h"
#import "EnterpriseContacts.h"
#import "Company.h"
#import "EnterpriseNameDatabase.h"
#import "EnterpriseSearchPinYin.h"
#import "EnterpriseContact.h"
@interface DialViewController ()
- (void) toHidden;
- (void) toAppear;
@end

@implementation DialViewController
@synthesize table = _table;

@synthesize diaplayLable = _diaplayLable;
@synthesize telephone_number = _telephone_number;
@synthesize isHidden = _isHidden;
@synthesize dialView = _dialView;
@synthesize number_display = _number_display;
@synthesize single_call_history = _single_call_history;
@synthesize call_history = _call_history;
@synthesize contacts = _contacts;
@synthesize filteredListContent = _filteredListContent;
@synthesize isSearching = _isSearching;
@synthesize layer = _layer;
@synthesize enterpriseContacts = _enterpriseContacts;

- (void) setTelephone_number:(NSString *)telephone_number {
  if (![telephone_number isEqualToString:@""]) {
    [self setIsSearching:YES];
    [self.diaplayLable setText:@""];
  } else {
    [self setIsSearching:NO];
    [self.diaplayLable setText:@"点击此处呼出"];
  }
  _telephone_number = telephone_number;
  //self.telephone_number = _telephone_number;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}
- (IBAction)change:(id)sender {
  CGRect frame = CGRectMake(0, 0, 200, 200);
  float x = frame.origin.x + frame.size.width - 30;
  float y = frame.origin.y + frame.size.height - 30;
  CATransform3D rotate;
  CATransform3D scale;
  CATransform3D combine;
  
  [CATransaction begin];
  [CATransaction setValue:[NSNumber numberWithFloat:5.0f]
                   forKey:kCATransactionAnimationDuration];
  
  [self.layer setPosition:CGPointMake(x, y)];
  scale = CATransform3DMakeScale(0.1f, 0.1f, 1.0f);
  rotate = CATransform3DMakeRotation(1.57f, 0.0f, 0.0f, 1.0f);
  combine = CATransform3DConcat(rotate, scale);
  [self.dialView.layer setTransform:combine];
  
  [CATransaction commit];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  dispatch_queue_t q = dispatch_queue_create("queue", 0);
  dispatch_async(q, ^{
    self.contacts = [ABContactsHelper contacts];  
    NSArray *eContacts = [[[NSArray alloc] init] autorelease];
    NSMutableArray *companyArray = [EnterpriseNameDatabase queryEnterpriseName];
    
    for (Company *aCompany in companyArray) {
      eContacts = [eContacts arrayByAddingObjectsFromArray:[[EnterpriseContacts contacts:aCompany.companyID] copy]];
    }
    NSLog(@"e %i  l %i", [eContacts count], [self.contacts count]);
    self.enterpriseContacts = eContacts;
    self.call_history = [self loadCallRecordFromFilePath:[self filePathName]];
    dispatch_async(dispatch_get_main_queue(), ^{ 
      //NSLog(@"DFSDFAS %@", self.call_history);
      [self.table reloadData];
    });
  });
  dispatch_release(q);   
  
  self.isHidden = NO;
  self.telephone_number = [[[NSString alloc] init] autorelease];
  self.call_history = [[[NSMutableArray alloc] init] autorelease];
  self.single_call_history = [[[NSMutableDictionary alloc] init] autorelease];
  
  [[NSNotificationCenter defaultCenter] addObserver:self 
                                           selector:@selector(update) 
                                               name:@"update" 
                                             object:nil];  
}

- (IBAction)dial:(UIButton *)sender {
  if (![self.telephone_number isEqualToString:@""]) {
    
    NSString *phoneAddress = [NSString stringWithFormat:@"tel://%@", self.telephone_number];
    /*BOOL dialSucessful = */
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneAddress]];
    
    if (YES) {
      // if (dialSucessful) {
      ABContact *abContact = [SearchPinYin absoluteMatch:self.telephone_number addressBook:[self.contacts mutableCopy]];
      self.single_call_history = [[[NSMutableDictionary alloc] init] autorelease];
      //CallRecord *callRecord = [[[CallRecord alloc] init] autorelease];
      if (abContact != nil) {
        [self.single_call_history setObject:abContact.contactName forKey:kMain]; 
        [self.single_call_history setObject:@"YES" forKey:kHaveContacts];
      } else {
        [self.single_call_history setObject:self.telephone_number forKey:kMain];
        [self.single_call_history setObject:@"NO" forKey:kHaveContacts];
      }
      
      /*
       //////////////////////////////////
       if (abContact != nil) {        
       callRecord.callName = abContact.contactName;
       } else {
       callRecord.callName = @"";
       }
       callRecord.callNumber = self.telephone_number;
       callRecord.callTime = [self dialTime];
       //////////////////////////////////
       */
      
      [self.single_call_history setObject:self.telephone_number forKey:kTelephoneNumber];
      
      // NSLog(@"rrrrr %@", self.single_call_history);
      [self.single_call_history setObject:[self dialTime] forKey:kDialTime];
      // NSLog(@"%@", [self dialTime]);
      
      //[self.call_history insertObject:callRecord atIndex:0];
      [self.call_history insertObject:self.single_call_history atIndex:0];  
      // NSLog(@"rrrrr %@", self.call_history);
      [self saveCallRecord:self.call_history toFilePath:[self filePathName]];
      
      self.telephone_number = @"";
      [self.number_display setTitle:@"" forState:UIStatusBarStyleDefault];
      [self.table reloadData];
      
    }
  }
}

- (NSDate *)dialTime {
  return  [NSDate date];
}

- (void) toHidden {
  CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"]; //动画类型为移动位置
  positionAnimation.duration =.3f;
  CGMutablePathRef path = CGPathCreateMutable(); //创建路径
  CGFloat x1 = 160.f;//self.dialView.frame.origin.x + self.dialView.bounds.size.width * .5f;
  CGFloat y1 = 233.f;//self.dialView.bounds.size.height - 50; //self.dialView.frame.origin.y + 200;  
  CGFloat x2 = 160.f;//self.dialView.frame.origin.x + self.dialView.bounds.size.width * .5f;
  CGFloat y2 = 550.f;//self.dialView.frame.origin.y + 500;   
  //NSLog(@"%f, %f, %f, %f", self.dialView.frame.origin.x, self.dialView.bounds.size.width, x2, y2);
  //NSLog(@"%f, %f", self.dialView.frame.origin.x, self.dialView.frame.origin.y );
  CGPathMoveToPoint(path, NULL, x1, y1); //移动到指定路径
  CGPathAddLineToPoint(path, NULL, x2, y2); //添加一条路径
  
  positionAnimation.path = path; //设置移动路径为刚才创建的路径
  CGPathRelease(path);
  
  [self.dialView.layer addAnimation:positionAnimation forKey:@"Test"];
  //[self.dialView setHidden:YES];
  self.dialView.frame = CGRectMake(160, 587,320, self.dialView.bounds.size.height);
}

- (void) toAppear {
  self.dialView.frame = CGRectMake(0, 87, 320, self.dialView.bounds.size.height);
  CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"]; //动画类型为移动位置
  positionAnimation.duration =.3f;
  CGMutablePathRef path = CGPathCreateMutable(); //创建路径
  CGFloat x1 = 160.f;//self.dialView.frame.origin.x + self.dialView.bounds.size.width * .5f;
  CGFloat y1 = 233.f;//self.dialView.bounds.size.height - 50; //self.dialView.frame.origin.y + 200;  
  CGFloat x2 = 160.f;//self.dialView.frame.origin.x + self.dialView.bounds.size.width * .5f;
  CGFloat y2 = 550.f;//self.dialView.frame.origin.y + 500;   
  

 // NSLog(@"%f, %f, %f, %f", x1, y1, x2, y2);
  
  CGPathMoveToPoint(path, NULL, x2, y2); //移动到指定路径
  CGPathAddLineToPoint(path, NULL, x1, y1); //添加一条路径
  
  positionAnimation.path = path; //设置移动路径为刚才创建的路径
  CGPathRelease(path);
  
  [self.dialView.layer addAnimation:positionAnimation forKey:@"Test"];
}

- (void)update {
  if (self.isHidden) {
    self.isHidden = NO;

    [self toAppear];
    //[self.dialView setHidden:NO];
  } else {
    self.isHidden = YES;
    [self toHidden];

  }
}

- (void)viewDidUnload {
  [self setDiaplayLable:nil];
  [self setDialView:nil];
  [self setNumber_display:nil];

  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (IBAction)dialNumber:(UIButton *)sender {
  NSString *currentDisplayText = self.number_display.currentTitle ? self.number_display.currentTitle : @"";
  NSString *newDisplayText = [currentDisplayText stringByAppendingString:[sender currentTitle]];
  
  [self.number_display setTitle:newDisplayText forState:UIControlStateNormal];
  self.telephone_number = self.number_display.currentTitle; 
  
  [self filterContentForSearchText:self.telephone_number];
}

- (IBAction)back:(UIButton *)sender {
  NSInteger tel_length = [self.telephone_number length];
  
  if (tel_length > 0) {
    self.telephone_number = [self.telephone_number substringToIndex:(tel_length - 1)];
    [self.number_display setTitle:self.telephone_number forState:UIControlStateNormal];
    [self filterContentForSearchText:self.telephone_number];
  }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return (self.isSearching) ? [self.filteredListContent count] : [self.call_history count]; 
}

- (NSMutableArray *)loadCallRecordFromFilePath:(NSString *)filePath {
  NSMutableArray *record = nil;
  if (filePath == nil || [filePath length] == 0 || 
      [[NSFileManager defaultManager] fileExistsAtPath:filePath] == NO) {
    record = [[[NSMutableArray alloc] init] autorelease];
  } else {
    NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
    NSKeyedUnarchiver *vdUnarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    record = [vdUnarchiver decodeObjectForKey:kSaveKeyMarkerLines];
    [vdUnarchiver finishDecoding];
    [vdUnarchiver release];
    [data release];
  }
  return record;
}

- (void)saveCallRecord:(NSMutableArray *)record toFilePath:(NSString *)filePath {
  NSMutableData *data = [[NSMutableData alloc] init];
  NSKeyedArchiver *vdArchiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
  [vdArchiver encodeObject:record forKey:kSaveKeyMarkerLines];
  [vdArchiver finishEncoding];
  [data writeToFile:filePath atomically:YES];
  [vdArchiver release];
  [data release];
}

- (NSString *)filePathName {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
  NSString *documentsDirectory = [paths objectAtIndex:0];  
  if (!documentsDirectory) {  
    NSLog(@"Documents directory not found!");  
  }  
  NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"CallRecord.plist"];  
  
  return appFile;
}

-(UITableViewCell *)tableView:(UITableView *)tableView 
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CustomCellIdentifier = @"CellIdentifier";
  static BOOL nibsRegistered = NO;
  if (!nibsRegistered) {
    UINib *nib = [UINib nibWithNibName:@"CallRecordCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:CustomCellIdentifier];
    nibsRegistered = YES;
  }
  
  CallRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
  
  if (self.isSearching) {
    id aContact = [self.filteredListContent objectAtIndex:indexPath.row];
    NSLog(@"%i", [self.filteredListContent count]);
    if ([aContact isKindOfClass:[NSDictionary class]]) {
      NSDictionary *contact_dict = [self.filteredListContent objectAtIndex:indexPath.row];
      ABContact *contact = [contact_dict objectForKey:kContact];
      
      cell.main = ([contact.contactName isEqualToString:@""]) ? contact.emailaddresses : contact.contactName;
      cell.number = contact.phonenumbers;
      cell.dialTime = @"";
      cell.image = [UIImage imageNamed:@"Avatar.png"];
    } else {
      EnterpriseContact *eContact = [self.filteredListContent objectAtIndex:indexPath.row];
      
      cell.main = eContact.name;
      cell.number = eContact.phone_number;
      cell.dialTime = @"";
      cell.image = [UIImage imageNamed:@"ICON_Person.png"];
    }
  } else {
    
    NSDictionary *call_record = [self.call_history objectAtIndex:([indexPath row])];
    //CallRecord *callRecord = [self.call_history objectAtIndex:[indexPath row]];
    
    //NSLog(@"%@", call_record);
    //cell.main = ([callRecord.callName isEqualToString:@""]) ? callRecord.callNumber : callRecord.callName; 
    // NSLog(@"%@",[call_record objectForKey:kHaveContacts]);
    cell.main = ([[call_record objectForKey:kHaveContacts] isEqualToString:@"YES"]) ? [call_record objectForKey:kMain] :[call_record objectForKey:kTelephoneNumber];
    
    cell.number = ([[call_record objectForKey:kHaveContacts] isEqualToString:@"YES"]) ? [call_record objectForKey:kTelephoneNumber] : @"";
    // cell.number = ([callRecord.callName isEqualToString:@""]) ? callRecord.callNumber : @"";
    cell.image = [UIImage imageNamed:@"dial_list_call.png"];
    
    NSDate *current = [NSDate date];
    NSDate *date = [call_record objectForKey:kDialTime];    
    //NSDate *date = callRecord.callTime;
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:[self dateFormaterString:[current timeIntervalSince1970] - [date timeIntervalSince1970]]];
    
    cell.dialTime = [dateFormatter stringFromDate:date];
  }
  return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  NSLog(@"scrollViewDidScroll");
}

- (NSInteger)todayTimeInterval {
  NSCalendar *cal = [NSCalendar currentCalendar];
  NSDateComponents* nowHour = [cal components:NSHourCalendarUnit fromDate:[NSDate date]];
  NSDateComponents* nowMinute = [cal components:NSMinuteCalendarUnit fromDate:[NSDate date]];
  NSDateComponents* nowSecond = [cal components:NSSecondCalendarUnit fromDate:[NSDate date]];
  
  NSInteger todaySecond = nowSecond.second + (nowMinute.minute * 60) + (nowHour.hour * 60 * 60);
  //NSLog(@"%d %d %d", nowSecond.second, nowMinute.minute, nowHour.hour);
  //NSLog(@"%@", todayDate);
  //NSLog(@"%d", todaySecond);
  return todaySecond;
}

- (NSString *)dateFormaterString:(NSInteger)timeInterval {
  if (timeInterval <= [self todayTimeInterval]) {
    return @"hh:mm";
  } else {
    if (timeInterval > ([self todayTimeInterval] + 86400 )) {
      return @"MM/dd";
    } else {
      return @"昨天";
    }
  }
}

- (NSDate *) currentDate:(NSDate *)now {
  NSTimeZone *zone = [NSTimeZone systemTimeZone];  
  NSInteger interval = [zone secondsFromGMTForDate: now];  
  NSDate *localeDate = [now dateByAddingTimeInterval: interval];  
  
  return localeDate;
}


#pragma mark - Table view delegate
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath { 
  if (self.isSearching) {
    if (!self.isHidden) {
      self.isHidden = YES;
      //[self.dialView setHidden:YES];
      [self toHidden];
      return nil;
    } else {
      return indexPath;
    } 
  } else {
    if (!self.isHidden) {
      self.isHidden = YES;
      //[self.dialView setHidden:YES];
      [self toHidden];
      return nil;
    } else {
      return indexPath;
    } 
  }
}  

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.isSearching) {
    if (!self.isHidden) {
      self.isHidden = YES;
      //[self.dialView setHidden:YES];
      [self toHidden];
    } else {
      id aContact = [self.filteredListContent objectAtIndex:indexPath.row];
          if ([aContact isKindOfClass:[NSDictionary class]]) {
            
      NSDictionary *contact_dict = [[[NSDictionary alloc] init] autorelease];
      contact_dict = [self.filteredListContent objectAtIndex:indexPath.row];
      ABContact *abContact = [contact_dict objectForKey:kContact];
      NSString *callNumber =[abContact.phoneArray objectAtIndex:0];
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callNumber]];
      //    g(@"contact.phoneArray   %@", [abContact.phoneArray objectAtIndex:0]);
      
      self.single_call_history = [[[NSMutableDictionary alloc] init] autorelease];
      if (abContact != nil) {
        [self.single_call_history setObject:abContact.contactName forKey:kMain]; 
        [self.single_call_history setObject:@"YES" forKey:kHaveContacts];
      } else {
        [self.single_call_history setObject:self.telephone_number forKey:kMain];
        [self.single_call_history setObject:@"NO" forKey:kHaveContacts];
      }
      
      [self.single_call_history setObject:callNumber forKey:kTelephoneNumber];
      [self.single_call_history setObject:[self dialTime] forKey:kDialTime];
      [self.call_history insertObject:self.single_call_history atIndex:0];  
      
      [self saveCallRecord:self.call_history toFilePath:[self filePathName]];
      [self.number_display setTitle:@"" forState:UIStatusBarStyleDefault];
      self.telephone_number = @"";
      [self.table reloadData];
          } else {
            EnterpriseContact *eContact = [self.filteredListContent objectAtIndex:indexPath.row];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:eContact.phone_number]];
            self.single_call_history = [[[NSMutableDictionary alloc] init] autorelease];
            [self.single_call_history setObject:eContact.name forKey:kMain]; 
            [self.single_call_history setObject:@"YES" forKey:kHaveContacts];
            
            [self.single_call_history setObject:eContact.phone_number forKey:kTelephoneNumber];
            [self.single_call_history setObject:[self dialTime] forKey:kDialTime];
            [self.call_history insertObject:self.single_call_history atIndex:0];  
            
            [self saveCallRecord:self.call_history toFilePath:[self filePathName]];
            [self.number_display setTitle:@"" forState:UIStatusBarStyleDefault];
            self.telephone_number = @"";
            [self.table reloadData];
          }
    }    
  } else {
    if (self.isHidden) {
      NSDictionary *single = [self.call_history objectAtIndex:[indexPath row]];
      NSString *callNumber = [single objectForKey:kTelephoneNumber];
      
      ABContact *abContact = [SearchPinYin absoluteMatch:callNumber 
                                             addressBook:[self.contacts mutableCopy]];
      
      self.single_call_history = [[[NSMutableDictionary alloc] init] autorelease];
      if (abContact != nil) {
        [self.single_call_history setObject:abContact.contactName forKey:kMain]; 
        [self.single_call_history setObject:@"YES" forKey:kHaveContacts];
      } else {
        [self.single_call_history setObject:callNumber forKey:kMain];
        [self.single_call_history setObject:@"NO" forKey:kHaveContacts];
      }
      
      [self.single_call_history setObject:callNumber forKey:kTelephoneNumber];
      [self.single_call_history setObject:[self dialTime] forKey:kDialTime];
      [self.call_history insertObject:self.single_call_history atIndex:0];  
      
      [self saveCallRecord:self.call_history toFilePath:[self filePathName]];
      [self.number_display setTitle:@"" forState:UIStatusBarStyleDefault];
      self.telephone_number = @"";
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[single objectForKey:kTelephoneNumber ]]];
      
      [self.table reloadData];
    }
  }
}

- (void)fetchContacts {
  
  //dispatch_queue_t q = dispatch_queue_create("queue", 0);
  //dispatch_async(q, ^{   
  
  //   self.contacts  = [ABContactsHelper contacts];
  //self.contacts = [ABContactsHelper contacts];
  //    dispatch_async(dispatch_get_main_queue(), ^{
  //self.contacts = con;
  //   });
  //});
  // dispatch_release(q);
}


- (void)filterContentForSearchText:(NSString*)searchText {
  /*执行姓名首字母的*/
  //[self fetchContacts];
  //NSLog(@"filterContentForSearchText start");
  // NSArray *result_of_key_pinyin = [SearchPinYin executePinyinKeySearch:searchText 
  //                                                               addressBook:[self.contacts mutableCopy]]; 
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
  NSArray *localContactresult = [[result_of_key_pinyin arrayByAddingObjectsFromArray:result_of_number_search] arrayByAddingObjectsFromArray:result_of_detail_pinyin];
  //NSLog(@"filterContentForSearchText finish");
  //self.filteredListContent = [final_result copy];
  
  
  
  NSArray *resultOfKeyPinyin = [EnterpriseSearchPinYin executePinyinKeySearch2:searchText 
                                                                   addressBook:self.enterpriseContacts];  
  //执行号码的检索
  //[self fetchContacts];
  NSArray *resultOfNumberSearch = [EnterpriseSearchPinYin executeNumberSearch:searchText 
                                                                  addressBook:self.enterpriseContacts];
  //执行全拼的检索
  //[self fetchContacts];
  NSArray *resultOfDetailPinyin = [EnterpriseSearchPinYin executeDetailPinyinSearch:searchText 
                                                                        addressBook:self.enterpriseContacts];
  //NSLog(@"~~~~~~2~~~~~~~");    
  NSArray *enterpriseContatsResult = [[resultOfKeyPinyin arrayByAddingObjectsFromArray:resultOfNumberSearch] arrayByAddingObjectsFromArray:resultOfDetailPinyin];
  //NSLog(@"%@", final_result);    
  NSSet *set = [NSSet setWithArray:enterpriseContatsResult];
  
  //[set allObjects];
  self.filteredListContent =  [localContactresult arrayByAddingObjectsFromArray:[set allObjects]];
  
  NSLog(@"localContactresult %i enterpriseContatsResult %i filteredListContent %i", [localContactresult count],[[set allObjects] count], [self.filteredListContent count]);
  
  
  [self.table reloadData];
}

- (void)dealloc {
  [_diaplayLable release];
  [_telephone_number release];
  [_dialView release];
  [_table release];
  [_number_display release];
  [_contacts release];
  [_filteredListContent release];
  [_single_call_history release];
  [_call_history release];
  [self.layer release];
  [self.enterpriseContacts release];
  [super dealloc];
}
@end
