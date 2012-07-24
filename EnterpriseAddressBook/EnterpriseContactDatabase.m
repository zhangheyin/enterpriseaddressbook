//
//  EnterpriseContactDatabase.m
//  EnterpriseContactDatabase
//
//  Created by admin on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EnterpriseContactDatabase.h"
#import "EnterpriseContact.h"
#import "FMDatabase.h"
@implementation EnterpriseContactDatabase

- (id) init {
   // self = [super init];
  if (!self) {
    return nil;
  }
  
  return self;
}

+ (NSMutableArray *)queryAllEnterpriseDepartments {
  NSMutableArray *allEnterpriseStructs = [[[NSMutableArray alloc] init] autorelease];
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentDirectory = [paths objectAtIndex:0];
  //dbPath： 数据库路径，在Document中。
  NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"ycontacts.db"];
  //创建数据库实例 db  这里说明下:如果路径中不存在"Test.db"的文件,sqlite会自动创建"Test.db"
  FMDatabase *db= [FMDatabase databaseWithPath:dbPath] ;
  if (![db open]) {
    NSLog(@"Could not open db.");
    return nil;
  } else {
    FMResultSet *rs = [db executeQuery:@"select struct_id, name from org;"];//, company_id];
    while ([rs next]) {
      NSDictionary *aEnterpriseStruct = [NSDictionary dictionaryWithObject:[rs stringForColumn:@"name"] forKey:[rs stringForColumn:@"struct_id"]];
      [allEnterpriseStructs addObject:aEnterpriseStruct];
    }
  }
  //NSLog(@"%@", allEnterpriseStructs);
  return allEnterpriseStructs;
}

+ (NSMutableArray *)queryAllEnterpriseContacts2:(NSString *)company_id {
  //保持所有联系人
  NSMutableArray *all_enterprise_contacts_array = [[[NSMutableArray alloc] init] autorelease];
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentDirectory = [paths objectAtIndex:0];
  //dbPath： 数据库路径，在Document中。
  NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"ycontacts.db"];
  //创建数据库实例 db  这里说明下:如果路径中不存在"Test.db"的文件,sqlite会自动创建"Test.db"
  FMDatabase *db= [FMDatabase databaseWithPath:dbPath] ;
  if (![db open]) {
    NSLog(@"Could not open db.");
    return nil;
  } else {
    FMResultSet *rs = [db executeQuery:@"select * from data;"];
    while ([rs next]) {
      EnterpriseContact *aContact = [[EnterpriseContact alloc] init] ;
      aContact.contact_id   = [rs stringForColumn:@"contact_id"];
      aContact.name         = [rs stringForColumn:@"name"];
      aContact.name_pinyin  = [rs stringForColumn:@"name_pinyin"];
      aContact.gender       = [rs stringForColumn:@"gender"];
      aContact.company_id   = [rs stringForColumn:@"company_id"];
      aContact.depart_id    = [rs stringForColumn:@"depart_id"];
      aContact.vcard        = [rs stringForColumn:@"vcard"];
      aContact.phone_number = [rs stringForColumn:@"pre_tel"];
      [all_enterprise_contacts_array addObject:aContact];
//      
//      NSString *stringvcard = [NSString stringWithFormat:@"\nBEGIN:VCARD\nVERSION:3.0\nFN:%@\nN:%@;;;;\nPROFILE:VCARD\nPHOTO;VALUE=URI;TYPE=jpg:\nBDAY:\nTEL;TYPE=cell:%@\nEMAIL;TYPE=work:%@\nTITLE:%@\nORG:%@\nREV:2012-06-13T16\:54\:10Z\nIMPP;X-SERVICE-TYPE=QQ;type=HOME;type=pref:x-apple:888888\nEND:VCARD",
//                               aContact.name,aContact.name,
//                               aContact.phone_number,
//                               [rs stringForColumn:@"pre_email"],
//                               [rs stringForColumn:@"title"],
//                               [rs stringForColumn:@"org"]
//                               
//                               ];
//      NSLog(@"%@", stringvcard);
      [aContact release];
    }
    [rs close];
    return all_enterprise_contacts_array;
  }
}

@end

