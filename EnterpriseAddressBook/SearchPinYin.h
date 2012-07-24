//
//  SearchPinYin.h
//  SearchPinYin
//
//  Created by Heyin Zhang on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>  
#import <AddressBookUI/AddressBookUI.h> 
#import "POAPinyin.h"
#import "ABContactsHelper.h"

@interface SearchPinYin : NSObject
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
//select * from org where company_id = 3 and parent_id = 0
//+ (NSMutableArray *)fetchKeyAppearPinyinArray:(NSString *)key_word;
+ (ABContact *) absoluteMatch:(NSString *)key_word 
                  addressBook:(NSArray *)addressBook;
@end
