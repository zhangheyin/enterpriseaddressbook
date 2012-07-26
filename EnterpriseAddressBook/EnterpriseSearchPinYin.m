//
//  SearchPinYin.m
//  SearchPinYin
//
//  Created by Heyin Zhang on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EnterpriseSearchPinYin.h"
#import "EnterpriseContact.h"
#import "EnterpriseContacts.h"
@implementation EnterpriseSearchPinYin
//判断是否为整形：


+ (NSDictionary*)number_pad{
  NSArray *num_array0 = [NSArray arrayWithObject:@"0"];
  NSArray *num_array1 = [NSArray arrayWithObject:@"1"];
  NSArray *num_array2 = [NSArray arrayWithObjects:@"a", @"b", @"c", @"2", nil];
  NSArray *num_array3 = [NSArray arrayWithObjects:@"d", @"e", @"f", @"3", nil];
  NSArray *num_array4 = [NSArray arrayWithObjects:@"g", @"h", @"i", @"4", nil];
  NSArray *num_array5 = [NSArray arrayWithObjects:@"j", @"k", @"l", @"5", nil];
  NSArray *num_array6 = [NSArray arrayWithObjects:@"m", @"n", @"o", @"6", nil];
  NSArray *num_array7 = [NSArray arrayWithObjects:@"p", @"q", @"r", @"s", @"7", nil];
  NSArray *num_array8 = [NSArray arrayWithObjects:@"t", @"u", @"v", @"8", nil];
  NSArray *num_array9 = [NSArray arrayWithObjects:@"w", @"x", @"y", @"z", @"9", nil];
  
  NSDictionary *number_pad = [NSDictionary dictionaryWithObjectsAndKeys: 
                              num_array0, @"0", 
                              num_array1, @"1", 
                              num_array2, @"2", 
                              num_array3, @"3", 
                              num_array4, @"4", 
                              num_array5, @"5", 
                              num_array6, @"6", 
                              num_array7, @"7", 
                              num_array8, @"8", 
                              num_array9, @"9", 
                              nil];
  
  return number_pad;
}


+ (BOOL)isPureInt:(NSString*)string {
  NSScanner* scan = [NSScanner scannerWithString:string]; 
  int val; 
  return [scan scanInt:&val] && [scan isAtEnd];
}

+ (NSMutableArray *)fetchKeyAppearPinyinArray2:(NSString *)key_word {  
  NSMutableArray *all_pinyin_table = [POAPinyin fetchPinyinTableArray];
  //NSLog(@"%@", all_pinyin_table);
 // NSArray *key_of_word_array = [self fetchKeyWordArray:key_word];
  //NSLog(@"%@", key_of_word_array);
  NSMutableArray *searche_result_array = [[[NSMutableArray alloc] init] autorelease];
  NSMutableArray *temp_pinyin_array = all_pinyin_table;
  
  for (NSString *pinyin in temp_pinyin_array) {
    if ([[EnterpriseContacts fetchDetailPinyinForNum:pinyin ] rangeOfString:key_word 
                                                                    options:NSCaseInsensitiveSearch].location != NSNotFound) {
      [searche_result_array addObject:pinyin];
    }
  }
  
 // temp_pinyin_array = searche_result_array;
  //[searche_result_array removeAllObjects];
 // NSLog(@"searche_result_array  %@", searche_result_array);
 // NSLog(@"%@", single_key_word);
 // NSLog(@"%@", temp_pinyin_array);
  return searche_result_array;
}
  
+ (NSMutableArray *)fetchKeyAppearPinyinArray:(NSString *)key_word {  
  NSMutableArray *all_pinyin_table = [POAPinyin fetchPinyinTableArray];
  NSLog(@"%@", all_pinyin_table);
  NSArray *key_of_word_array = [self fetchKeyWordArray:key_word];
  NSLog(@"%@", key_of_word_array);
  NSMutableArray *searche_result_array = [[[NSMutableArray alloc] init] autorelease];
  NSMutableArray *temp_pinyin_array = all_pinyin_table;
  //6 : M N O
  
  for (int key_word_index = 0; key_word_index < [key_word length]; key_word_index++) {
    //key_of_word_array 6 4 6 2
    NSString *single_key_word = [key_of_word_array objectAtIndex:key_word_index];
    //M N O 6
    NSLog(@"%@", single_key_word);
    NSArray *single_key_of_one_button = [self.number_pad objectForKey:single_key_word];
    
    for (NSString *current_key in single_key_of_one_button) {
      if (![self isPureInt:current_key]) {
        for (NSString *pinyin in temp_pinyin_array) {
          if ([[EnterpriseContacts fetchDetailPinyinForNum:pinyin ] rangeOfString:current_key 
                            options:NSCaseInsensitiveSearch].location == key_word_index) {
            [searche_result_array addObject:pinyin];
          }
        }
      }   
    }
    temp_pinyin_array = searche_result_array;
    [searche_result_array removeAllObjects];
    NSLog(@"temp_pinyin_database  %@", temp_pinyin_array);
    NSLog(@"%@", single_key_word);
  }//for
  NSLog(@"%@", temp_pinyin_array);
  return temp_pinyin_array;
}

+ (NSMutableArray *)executeDetailPinyinSearch:(NSString *)key_word
                                  addressBook:(NSArray *)addressBook {
 // NSLog(@"key_word %@", key_word);
  // NSLog(@"appear_pinyin_array %@", appear_pinyin_array);
  NSMutableArray *searched_array = [[[NSMutableArray alloc] init] autorelease];
  for (EnterpriseContact *people_info in addressBook) {
   // NSLog(@"%@ ", people_info.name_pinyin);
    NSRange range = [[EnterpriseContacts fetchDetailPinyinForNum:people_info.name_pinyin] rangeOfString:key_word];
    //NSLog(@"%@    pinyin_array:%@", [people_info objectForKey:kNamePinyin], pinyin_array);
    if (range.location != NSNotFound) {   
      [searched_array addObject:people_info];
      //break;
    }

  }
 // NSLog(@"%@", searched_array); 
  return searched_array;
}


+ (NSMutableArray *)fetchKeyWordArray:(NSString *)key_word_string {
  NSMutableArray *key_array = [[[NSMutableArray alloc] init] autorelease];
  for (int i = 0; i < [key_word_string length]; i++) {
    [key_array addObject: [key_word_string substringWithRange:NSMakeRange(i,1)]];
  }  
  
  return key_array;
}

+ (NSArray *)executePinyinKeySearch2:(NSString *)key_word 
                         addressBook:(NSArray *)addressBook {
  NSMutableArray *searched_array = [[[NSMutableArray alloc] init] autorelease];
  
  for (EnterpriseContact *people_info in addressBook) {
    if ([people_info.name_pinyin_number isEqualToString:@""]) continue;
    NSRange range = [people_info.name_pinyin_number rangeOfString:key_word];
    if (range.location != NSNotFound) {   
      NSMutableDictionary *people_info_dic = [NSMutableDictionary dictionaryWithObject:people_info 
                                                                                forKey:@"people_info"];
      [people_info_dic setValue:[NSString stringWithFormat:@"%i", range.location]
                         forKey:kNameNumLocation];
      [searched_array addObject:people_info_dic];
      //NSLog(@"%@", people_info_dic);
    }
  }
  NSArray *enterprise_contacts = [self sortedSearchArray:searched_array 
                                                  forKey:kNameNumLocation];
  
  NSMutableArray *searched_enterprise_contacts = [[[NSMutableArray alloc] init ] autorelease];
  for (NSMutableDictionary *people_info_dic in enterprise_contacts) {
    [searched_enterprise_contacts addObject:[people_info_dic objectForKey:@"people_info"]];
  }
  //NSLog(@"%@", searched_array); 
  return searched_enterprise_contacts;
}


+ (NSArray *)sortedSearchArray:(NSMutableArray *)unsortedArray
                        forKey:(NSString *)forkey {
  NSArray *sortedArray = [unsortedArray sortedArrayUsingComparator:^(id obj1,id obj2)
                          {
                            NSDictionary *dic1 = (NSDictionary *)obj1;
                            NSDictionary *dic2 = (NSDictionary *)obj2;
                            NSNumber *num1 = (NSNumber *)[dic1 objectForKey:forkey];
                            NSNumber *num2 = (NSNumber *)[dic2 objectForKey:forkey];
                            if ([num1 floatValue] > [num2 floatValue])
                            {
                              return (NSComparisonResult)NSOrderedDescending;
                            }
                            else
                            {
                              return (NSComparisonResult)NSOrderedAscending;
                            }
                            return (NSComparisonResult)NSOrderedSame;
                          }];
  
  return sortedArray;
}


+ (NSArray *) executeNumberSearch:(NSString *)key_word 
                      addressBook:(NSArray *)addressBook { 
  NSMutableArray *tempResultArray = [[[NSMutableArray alloc] init] autorelease];
  
  for(EnterpriseContact *people_info in addressBook) {
    
    if (people_info.phone_number != nil){
      NSRange range = [people_info.phone_number rangeOfString:key_word];
      //NSLog(@"%@", contact.phonenumbers);
      if (range.location != NSNotFound) {   
        NSMutableDictionary *people_info_dic = [NSMutableDictionary dictionaryWithObject:people_info 
                                                                                  forKey:@"people_info"];
        [people_info_dic setValue:[NSString stringWithFormat:@"%i", range.location]
                           forKey:@"range_location"];
        
        [tempResultArray addObject:people_info_dic];
      }        
    }
  }
  
  NSArray *enterprise_contacts = [self sortedSearchArray:tempResultArray 
                                                  forKey:kPhoneNumber];
  
  NSMutableArray *searched_enterprise_contacts = [[[NSMutableArray alloc] init ] autorelease];
  for (NSMutableDictionary *people_info_dic in enterprise_contacts) {
    [searched_enterprise_contacts addObject:[people_info_dic objectForKey:@"people_info"]];
  }
  //NSLog(@"%@", searched_array); 
  return searched_enterprise_contacts;
}
@end
