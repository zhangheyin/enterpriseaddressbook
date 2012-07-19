//
//  CompanyOrganization.h
//  CompanyOrganization
//
//  Created by admin on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyOrganization : NSObject
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *result;
@property (nonatomic, strong) NSString *company_id;
@property (nonatomic, strong) NSString *auth_code;
@property (nonatomic, strong) NSMutableDictionary *organization_struct;
@end
