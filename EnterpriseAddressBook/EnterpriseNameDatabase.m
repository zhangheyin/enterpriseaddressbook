//
//  EnterpriseSQLite.m
//  TestSQLite
//
//  Created by admin on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EnterpriseNameDatabase.h"
#import "Company.h"
#import "FMDatabase.h"
@implementation EnterpriseNameDatabase
//@synthesize enterpriseSQLiteDatabase = _enterpriseSQLiteDatabase;
- (id) init {
   // self = [super init];
  if (!self) {
    return nil;
  }
  return self;
}

+ (NSMutableArray *)queryEnterpriseName {
  //保持所有组织名
  NSMutableArray *all_enterprise_name_array = [[[NSMutableArray alloc] init] autorelease];
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
    FMResultSet *rs = [db executeQuery:@"select company_id, org from data group by company_id;"];
    while ([rs next]) {
      Company *aCompany = [[[Company alloc] init] autorelease];
      aCompany.companyID = [rs stringForColumn:@"company_id"];
      aCompany.companyName = [rs stringForColumn:@"org"];  
      
      [all_enterprise_name_array addObject:aCompany];       
    }
    [rs close];
    //NSLog(@"%@", all_enterprise_name_array);
    return all_enterprise_name_array;
  }
}

@end
