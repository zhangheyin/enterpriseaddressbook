//
//  EnterpriseContactDatabase.h
//  EnterpriseContactDatabase
//
//  Created by admin on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

//#import "SimpleSQLite.h"

@interface EnterpriseContactDatabase
+ (NSMutableArray *)queryAllEnterpriseContacts2:(NSString *)company_id;
+ (NSMutableArray *)queryAllEnterpriseDepartments;
@end
