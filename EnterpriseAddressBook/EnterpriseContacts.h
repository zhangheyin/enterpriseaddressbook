//
//  EnterpriseContacts.h
//  TestSQLite
//
//  Created by admin on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "SimpleSQLite.h"
#import "ABContact.h"
@interface EnterpriseContacts : NSObject
+ (NSMutableArray *) contacts:(NSString *)company_id;
+ (ABContact *) vCardStringtoABContact:(NSString *)vcard_string;
+ (ABRecordRef) vCardStringtoABRecordRef:(NSString *)vcard_string;
//@property (nonatomic, strong) SimpleSQLite *enterprise_contacts_sqlite;
+ (NSString *) wholepinyin:(NSMutableArray *)array;
@end
