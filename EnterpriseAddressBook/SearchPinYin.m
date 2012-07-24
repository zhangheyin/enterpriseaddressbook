//
//  SearchPinYin.m
//  SearchPinYin
//
//  Created by Heyin Zhang on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SearchPinYin.h"
#import "EnterpriseContacts.h"
@implementation SearchPinYin
//判断是否为整形：

+ (NSDictionary*)number_pad {
  /*测试算法 20120621*/
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
//+ (BOOL)isPureInt:(NSString*)string
//{
//    
//    NSScanner* scan = [NSScanner scannerWithString:string]; 
//    int val; 
//    
//    return [scan scanInt:&val] && [scan isAtEnd];
//}
//
//+ (NSMutableArray *)fetchKeyAppearPinyinArray:(NSString *)key_word
//{
//    
//    NSMutableArray *all_pinyin_table = [POAPinyin fetchPinyinTableArray];
//    
//    NSArray *key_of_word_array = [self fetchKeyWordArray:key_word];
//    
//    NSMutableArray *searche_result_array = [[[NSMutableArray alloc] init] autorelease];
//    NSMutableArray *temp_pinyin_array = all_pinyin_table;//[all_pinyin_table copy];
//    //6 : M N O
//
//    for (int key_word_index = 0; key_word_index < [key_word length]; key_word_index++)
//    {
//        //key_of_word_array 6 4 6 2
//        NSString *single_key_word = [key_of_word_array objectAtIndex:key_word_index];
//        //M N O 6
//        NSArray *single_key_of_one_button = [self.number_pad objectForKey:single_key_word];
//        
//        for (NSString *current_key in single_key_of_one_button) 
//        {
//            if (![self isPureInt:current_key])
//            {
//                for (NSString *pinyin in temp_pinyin_array) {
//                    if ([pinyin rangeOfString:current_key 
//                                      options:NSCaseInsensitiveSearch].location == key_word_index) 
//                    {
//                        [searche_result_array addObject:pinyin];
//                    }
//                }
//            }   
//        }
//        temp_pinyin_array = searche_result_array;
//        [searche_result_array removeAllObjects];
//        //NSLog(@"temp_pinyin_database  %@", temp_pinyin_array);
//        //NSLog(@"%@", single_key_word);
//    }//for
//    //NSLog(@"%@", temp_pinyin_array);
//    return temp_pinyin_array;
//}

+ (NSMutableArray *)executeDetailPinyinSearch:(NSString *)key_word
                                  addressBook:(NSArray *)addressBook {
  //    NSMutableArray *appear_pinyin_array = [self fetchKeyAppearPinyinArray:key_word];
  //    
  //    NSMutableArray *searched_array = [[[NSMutableArray alloc] init] autorelease];
  //    //NSMutableArray *addressBook = [self.addressBookArray copy];
  //    for (NSMutableDictionary *people_info in addressBook) 
  //    {
  //        //NSLog(@"%@", people_info);
  //        for(NSString *pinyin_array in appear_pinyin_array)
  //        {
  //            NSRange range = [[people_info objectForKey:kNamePinyin] rangeOfString:pinyin_array];
  //            //NSLog(@"%@    pinyin_array:%@", [people_info objectForKey:kNamePinyin], pinyin_array);
  //            if (range.location != NSNotFound) 
  //            {   
  //                [searched_array addObject:people_info];
  //                break;
  //            }
  //        }
  //    }
  //    //NSLog(@"%@", searched_array); 
  //    return searched_array;
  
  
  // NSLog(@"key_word %@", key_word);
  // NSLog(@"appear_pinyin_array %@", appear_pinyin_array);
  NSMutableArray *searched_array = [[[NSMutableArray alloc] init] autorelease];
  for (NSMutableDictionary *people_info in addressBook) {
    // NSLog(@"%@ ", people_info.name_pinyin);
    NSRange range = [[EnterpriseContacts fetchDetailPinyinForNum:[people_info objectForKey:kNamePinyin] ] rangeOfString:key_word];
    //NSLog(@"%@    pinyin_array:%@", [people_info objectForKey:kNamePinyin], pinyin_array);
    if (range.location != NSNotFound) {   
      [searched_array addObject:people_info];
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
  
  for (NSMutableDictionary *people_info in addressBook) {
    NSString *appear_pinyin_num = [people_info objectForKey:kNamePinyinNum];
    
    if ([appear_pinyin_num isEqualToString:@""]) continue;
    NSRange range = [appear_pinyin_num rangeOfString:key_word];
    
    if (range.location != NSNotFound) {   
      [people_info setValue:[NSString stringWithFormat:@"%i", range.location]
                     forKey:kNameNumLocation];
      [searched_array addObject:people_info];
      //NSLog(@"%@", people_info);
      continue;
    }
  }
  //NSLog(@"%@", searched_array); 
  return [self sortedSearchArray:searched_array forKey:kNameNumLocation];
}


+ (NSArray *)sortedSearchArray:(NSMutableArray *)unsortedArray
                        forKey:(NSString *)forkey {
  NSArray *sortedArray = [unsortedArray sortedArrayUsingComparator:^(id obj1,id obj2) {
                            NSDictionary *dic1 = (NSDictionary *)obj1;
                            NSDictionary *dic2 = (NSDictionary *)obj2;
                            NSNumber *num1 = (NSNumber *)[dic1 objectForKey:forkey];
                            NSNumber *num2 = (NSNumber *)[dic2 objectForKey:forkey];
                            if ([num1 floatValue] > [num2 floatValue]) {
                              return (NSComparisonResult)NSOrderedDescending;
                            } else {
                              return (NSComparisonResult)NSOrderedAscending;
                            }
                            return (NSComparisonResult)NSOrderedSame;
                          }];
  
  return sortedArray;
}


+ (NSArray *) executeNumberSearch:(NSString *)key_word 
                      addressBook:(NSArray *)addressBook {
  NSMutableArray *tempResultArray = [[[NSMutableArray alloc] init] autorelease];
  
  for(NSMutableDictionary *people_info in addressBook) {
    // NSLog(@"%@", people_info);
    ABContact *contact = [people_info objectForKey:kContact];
    if (contact.phonenumbers != nil) {
      //NSLog(@"%@", contact.phonenumbers);
      NSString *phonenumbers = contact.phonenumbers;
      phonenumbers = [phonenumbers stringByReplacingOccurrencesOfString:@"(" withString:@""];
      phonenumbers = [phonenumbers stringByReplacingOccurrencesOfString:@")" withString:@""];
      phonenumbers = [phonenumbers stringByReplacingOccurrencesOfString:@"-" withString:@""];
      phonenumbers = [phonenumbers stringByReplacingOccurrencesOfString:@" " withString:@""];
      //NSLog(@"%@", phonenumbers); 
      NSRange range = [phonenumbers rangeOfString:key_word];
      //NSLog(@"%@", contact.phonenumbers);
      if (range.location != NSNotFound) {   
        [people_info setValue:[NSString stringWithFormat:@"%i", range.location]
                       forKey:@"range_location"];
        [tempResultArray addObject:people_info];
      }        
    }
  }
  return [self sortedSearchArray:tempResultArray forKey:kPhoneNumber];
}

+ (ABContact *) absoluteMatch:(NSString *)key_word 
                  addressBook:(NSArray *)addressBook {
  for(NSMutableDictionary *people_info in addressBook) {
    ABContact *contact = [people_info objectForKey:kContact];
    if (contact.phonenumbers != nil) {
      NSString *phonenumbers = contact.phonenumbers;
      phonenumbers = [phonenumbers stringByReplacingOccurrencesOfString:@"(" withString:@""];
      phonenumbers = [phonenumbers stringByReplacingOccurrencesOfString:@")" withString:@""];
      phonenumbers = [phonenumbers stringByReplacingOccurrencesOfString:@"-" withString:@""];
      phonenumbers = [phonenumbers stringByReplacingOccurrencesOfString:@" " withString:@""];
      if ([phonenumbers isEqualToString:key_word]) {
        return contact;
      }
    }
  }
  return nil;
}

@end
