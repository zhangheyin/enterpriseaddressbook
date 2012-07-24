//
//  EnterpriseContacts.m
//  EnterpriseContacts
//
//  Created by admin on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EnterpriseContacts.h"
#import "EnterpriseContactDatabase.h"
#import "POAPinyin.h"
#import "EnterpriseContact.h"

@implementation EnterpriseContacts

+ (NSString *)fetchDetailPinyinForNum:(NSString *)pinyinString{
  NSString *pinyin_key_to_num = [NSString stringWithString:@""];
  for (int i = 0; i < pinyinString.length; i++) {
    NSString *single = [NSString stringWithString:@""];
    int asciiCode = [pinyinString characterAtIndex:i];
    switch (asciiCode) {
      case 65:case 97:
      case 66:case 98:
      case 67:case 99:
        single = @"2";
        break;
      case 68:case 100:
      case 69:case 101:
      case 70:case 102:  
        single = @"3";
        break;
      case 71:case 103:
      case 72:case 104:  
      case 73:case 105:
        single = @"4";
        break;
      case 74:case 106:
      case 75:case 107:
      case 76:case 108:
        single = @"5";
        break;
      case 77:case 109:
      case 78:case 110:
      case 79:case 111:
        single = @"6";
        break;
      case 80:case 112:
      case 81:case 113:    
      case 82:case 114:    
      case 83:case 115:   
        single = @"7";
        break;
      case 84:case 116:
      case 85:case 117:    
      case 86:case 118:  
        single = @"8";
        break;
      case 87:case 119:    
      case 88:case 120:    
      case 89:case 121:    
      case 90:case 122:
        single = @"9";
        break;
        
      default:
        break;
    }
    pinyin_key_to_num = [pinyin_key_to_num stringByAppendingFormat:@"%@", single];
  }
  
  return pinyin_key_to_num;
}


+ (NSString *)fetchPinyinForNum:(NSMutableArray *)pinyin_array {
  NSString *pinyin_key_to_num = [NSString stringWithString:@""];
  for (NSString *single_pinyin in pinyin_array) {
    int asciiCode = [single_pinyin characterAtIndex:0]; // 65
    NSString *single = [NSString stringWithString:@""];
    switch (asciiCode) {
      case 65:
      case 66:
      case 67: 
        single = @"2";
        break;
      case 68:      
      case 69:      
      case 70:  
        single = @"3";
        break;
      case 71:
      case 72:  
      case 73:
        single = @"4";
        break;
      case 74:
      case 75:
      case 76:
        single = @"5";
        break;
      case 77:
      case 78:
      case 79:
        single = @"6";
        break;
      case 80:
      case 81:    
      case 82:    
      case 83:   
        single = @"7";
        break;
      case 84: 
      case 85:    
      case 86:  
        single = @"8";
        break;
      case 87:    
      case 88:    
      case 89:    
      case 90:
        single = @"9";
        break;
        
      default:
        break;
    }
    pinyin_key_to_num = [pinyin_key_to_num stringByAppendingFormat:@"%@", single];
  }
  return pinyin_key_to_num;
}

+ (NSString *) wholepinyin:(NSMutableArray *)array {
  NSString *whole = [[[NSMutableString alloc] init ] autorelease];
  for (NSString *string in array) {
    whole = [whole stringByAppendingFormat:string];
  }
  return whole;
}

+ (NSMutableString *) fetchWholePinyin:(NSString *)people_name {
  NSMutableString *name_pinyin = [[[NSMutableString alloc] init] autorelease];
  NSMutableArray *pinyinArray = [POAPinyin newQuickConvert:people_name];
  for (NSString *word in pinyinArray) {
    [name_pinyin appendFormat:@"%@", word];
  } 
  return name_pinyin;
}

+ (NSMutableArray *) contacts:(NSString *)company_id {
  NSMutableArray *all_enterprise_contact = [EnterpriseContactDatabase queryAllEnterpriseContacts2:company_id];

  for (EnterpriseContact *aContact in all_enterprise_contact) {     
    NSMutableArray *contacts_pinyin_array = [POAPinyin newQuickConvert:aContact.name];
    NSString *contacts_pinyin = [self fetchWholePinyin:aContact.name]; 
    aContact.name_pinyin_array =  contacts_pinyin_array;
    aContact.name_pinyin = contacts_pinyin; 
    aContact.name_pinyin_number = [self fetchPinyinForNum:contacts_pinyin_array];
    aContact.name_pinyin_index = (![contacts_pinyin isEqualToString:@""]) ? [contacts_pinyin substringToIndex:1] : [[aContact.name substringToIndex:1] uppercaseString];//   @"#";
  }
  return all_enterprise_contact;
}

+ (ABRecordRef) vCardStringtoABRecordRef:(NSString *)vcard_string {
  //NSLog(@"%@", vcard_string);
  // This version simply uses a string. I'm assuming you'll get that from somewhere else.
  //NSString *vCardString = @"vCardDataHere";
  // This line converts the string to a CFData object using a simple cast, which doesn't work under ARC
  CFDataRef vCardData = (CFDataRef)[vcard_string dataUsingEncoding:NSUTF8StringEncoding];
  // If you're using ARC, use this line instead:
  ABAddressBookRef book = ABAddressBookCreate();
  ABRecordRef defaultSource = ABAddressBookCopyDefaultSource(book);
  CFArrayRef vCardPeople = ABPersonCreatePeopleInSourceWithVCardRepresentation(defaultSource, vCardData);
  //for (CFIndex index = 0; index < CFArrayGetCount(vCardPeople); index++) {
  ABRecordRef person = CFArrayGetValueAtIndex(vCardPeople, 0);

  return person;
}

+ (ABContact *) vCardStringtoABContact:(NSString *)vcard_string {
  //NSLog(@"%@", vcard_string);
  // This version simply uses a string. I'm assuming you'll get that from somewhere else.
  //NSString *vCardString = @"vCardDataHere";
  // This line converts the string to a CFData object using a simple cast, which doesn't work under ARC
  CFDataRef vCardData = (CFDataRef)[vcard_string dataUsingEncoding:NSUTF8StringEncoding];
  // If you're using ARC, use this line instead:
  //CFDataRef vCardData = (__bridge CFDataRef)[vCardString dataUsingEncoding:NSUTF8StringEncoding];
  ABAddressBookRef book = ABAddressBookCreate();
  ABRecordRef defaultSource = ABAddressBookCopyDefaultSource(book);
  CFArrayRef vCardPeople = ABPersonCreatePeopleInSourceWithVCardRepresentation(defaultSource, vCardData);
  //for (CFIndex index = 0; index < CFArrayGetCount(vCardPeople); index++) {
  ABRecordRef person = CFArrayGetValueAtIndex(vCardPeople, 0);
  ABAddressBookAddRecord(book, person, NULL);
  ABContact *contact = [ABContact contactWithRecord:person];
  //CFRelease(person);
  //}
  //NSLog(@"%@", contact.contactName);
  CFRelease(vCardPeople);
  //CFRelease(defaultSource);
  ABAddressBookSave(book, NULL);
  CFRelease(book);
  // CFRelease(vCardData);
  return contact;
}
@end
