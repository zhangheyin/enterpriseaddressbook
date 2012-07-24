//
//  CompanyOrganization.m
//  CompanyOrganization
//
//  Created by admin on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CompanyOrganization.h"
#import "FMDatabase.h"
@implementation CompanyOrganization
@synthesize id = _id;
//@synthesize result = _result;
@synthesize company_id = _company_id;
//@synthesize auth_code = _auth_code;
//@synthesize organization_struct = _organization_struct;
@synthesize depart_id = _depart_id;
@synthesize departName = _departName;
@synthesize vCard = _vCard;

+ (NSMutableArray *)queryAllCompanyOrganization:(NSString *)companyID 
                                       departID:(NSString *)parentID {
  NSMutableArray *allCompanyOrganization = [[[NSMutableArray alloc] init] autorelease];
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
    FMResultSet *rs = [db executeQuery:@"select * from org where company_id = ? and parent_id = ?", companyID, parentID];
    while ([rs next]) {
      
      CompanyOrganization *aCompanyOrganization = [[[CompanyOrganization alloc] init] autorelease];
      
      aCompanyOrganization.company_id = [rs stringForColumn:@"company_id"];
      aCompanyOrganization.depart_id = [rs stringForColumn:@"struct_id"];
      aCompanyOrganization.departName = [rs stringForColumn:@"name"];
    
      [allCompanyOrganization addObject:aCompanyOrganization];
      
    }
    rs = [db executeQuery:@"select * from data where depart_id = ? and company_Id = ?;", parentID, companyID];
    while ([rs next]) {
      CompanyOrganization *aCompanyOrganization = [[[CompanyOrganization alloc] init] autorelease];
      aCompanyOrganization.company_id = [rs stringForColumn:@"company_id"];
      aCompanyOrganization.depart_id = [rs stringForColumn:@"depart_id"];
      aCompanyOrganization.departName = [rs stringForColumn:@"name"];
      aCompanyOrganization.id = [rs stringForColumn:@"contact_id"];
      aCompanyOrganization.vCard = [rs stringForColumn:@"vcard"];
      [allCompanyOrganization addObject:aCompanyOrganization];
    }
  }
  return allCompanyOrganization;  
}


@end
