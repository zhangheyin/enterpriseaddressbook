//
//  CompanyOrganization.h
//  CompanyOrganization
//
//  Created by admin on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyOrganization : NSObject
@property (nonatomic, copy) NSString *id;
//@property (nonatomic, copy) NSString *result;
@property (nonatomic, copy) NSString *company_id;
//@property (nonatomic, copy) NSString *auth_code;
//@property (nonatomic, retain) NSMutableDictionary *organization_struct;
@property (nonatomic, copy) NSString *depart_id;
@property (nonatomic, copy) NSString *departName;
@property (nonatomic, copy) NSString *vCard;
+ (NSMutableArray *)queryAllCompanyOrganization:(NSString *)companyID 
                                       departID:(NSString *)departID;
@end
