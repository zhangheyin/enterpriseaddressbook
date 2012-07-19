//
//  EnterpriseSearchPinYin.h
//  
//
//  Created by Heyin Zhang on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>  
#import <AddressBookUI/AddressBookUI.h> 
#import "POAPinyin.h"
#import "ABContactsHelper.h"

@interface EnterpriseSearchPinYin : NSObject
+ (NSDictionary*)number_pad;
+ (NSArray *)fetchKeyWordArray:(NSString *)key_word_string;
+ (NSArray *)sortedSearchArray:(NSMutableArray *)unsortedArray
                        forKey:(NSString *)forkey;

+ (NSArray *)executeNumberSearch:(NSString *)key_word 
                     addressBook:(NSArray *)addressBook;

+ (NSMutableArray *)executeDetailPinyinSearch:(NSString *)key_word
                                  addressBook:(NSArray *)addressBook;
+ (NSArray *)executePinyinKeySearch2:(NSString *)key_word 
                         addressBook:(NSArray *)addressBook;
//+ (NSArray *)executePinyinKeySearch:(NSString *)key_word 
//                        addressBook:(NSMutableArray *)addressBook;

+ (NSMutableArray *)fetchKeyAppearPinyinArray:(NSString *)key_word;
@end
