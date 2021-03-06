//
//  EnterpriseContact.m
//  EnterpriseContact
//
//  Created by admin on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EnterpriseContact.h"

@implementation EnterpriseContact
@synthesize contact_id = _contact_id;
@synthesize name = _name;
@synthesize name_pinyin = _name_pinyin;
@synthesize gender = _gender;
@synthesize company_id = _company_id;
@synthesize depart_id = _depart_id;
@synthesize vcard = _vcard;
@synthesize phone_number = _phone_number;
@synthesize detail_pinyin = _detail_pinyin;
@synthesize name_pinyin_index = _name_pinyin_index;
@synthesize name_pinyin_array = _name_pinyin_array;
@synthesize name_pinyin_number = _name_pinyin_number;



- (void)dealloc {
  [self.contact_id release];
  [self.name release];
  [self.name_pinyin release];
  [self.gender release];
  [self.company_id release];
  [self.depart_id release];
  [self.vcard release];
  [self.phone_number release];
  [self.detail_pinyin release];
  [self.name_pinyin_index release];
  [self.name_pinyin_array release];
  [self.name_pinyin_number release];
  
  [super dealloc];
}
@end
