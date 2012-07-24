//
//  EnterpriseContacts.h
//  EnterpriseContacts
//
//  Created by admin on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABContact.h"
@interface EnterpriseContacts : NSObject
+ (NSMutableArray *) contacts:(NSString *)company_id;
+ (ABContact *) vCardStringtoABContact:(NSString *)vcard_string;
+ (ABRecordRef) vCardStringtoABRecordRef:(NSString *)vcard_string;
+ (NSString *) wholepinyin:(NSMutableArray *)array;
+ (NSString *)fetchDetailPinyinForNum:(NSString *)pinyinString;
@end
