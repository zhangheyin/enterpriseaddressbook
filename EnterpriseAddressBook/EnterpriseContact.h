//
//  EnterpriseContact.h
//  TestSQLite
//
//  Created by admin on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnterpriseContact : NSObject
@property (nonatomic, copy) NSString *contact_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *name_pinyin;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *company_id;
@property (nonatomic, copy) NSString *depart_id;
@property (nonatomic, copy) NSString *vcard;
@property (nonatomic, copy) NSString *phone_number;
@property (nonatomic, copy) NSString *detail_pinyin;
@property (nonatomic, copy) NSString *name_pinyin_index;
@property (nonatomic, retain) NSArray *name_pinyin_array;
@property (nonatomic, copy) NSString *name_pinyin_number;

@end
