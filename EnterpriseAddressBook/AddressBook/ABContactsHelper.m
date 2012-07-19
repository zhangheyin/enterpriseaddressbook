/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import "ABContactsHelper.h"

@implementation ABContactsHelper
/*
 Note: You cannot CFRelease the addressbook after ABAddressBookCreate();
 */
+ (ABAddressBookRef) addressBook
{
	return ABAddressBookCreate();
}
/* copy
 + (NSArray *) contacts
 {
 ABAddressBookRef addressBook = ABAddressBookCreate();
 NSArray *thePeople = (NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
 NSMutableArray *array = [NSMutableArray arrayWithCapacity:thePeople.count];
 for (id person in thePeople)
 [array addObject:[ABContact contactWithRecord:(ABRecordRef)person]];
 [thePeople release];
 NSLog(@"%@", array);
 return array;
 }*/
+ (NSString *)fetchPinyinForNum:(NSMutableArray *)pinyin_array
{
    NSString *pinyin_key_to_num = [NSString stringWithString:@""];
    for (NSString *single_pinyin in pinyin_array) {
        
        int asciiCode = [single_pinyin characterAtIndex:0]; // 65
        NSString *single = [NSString stringWithString:@""];
        // int num_for_pinyin = 0;
        switch (asciiCode) 
        {
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
+ (NSMutableString *) fetchWholePinyin:(NSString *)people_name
{
    NSMutableString *name_pinyin = [[[NSMutableString alloc] init] autorelease];
    for (NSString *word in [POAPinyin newQuickConvert:people_name]) {
        [name_pinyin appendFormat:@"%@", word];
    }
    //[POAPinyin clearCache];
    return name_pinyin;
}
+ (NSString *) wholepinyin:(NSMutableArray *)array
{
    NSString *whole = [[NSMutableString alloc] init ];
    for (NSString *string in array) {
        whole = [whole stringByAppendingFormat:string];
    }
    return whole;
}

+ (NSArray *) contacts
{
	ABAddressBookRef addressBook = ABAddressBookCreate();
	NSArray *thePeople = (NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:thePeople.count];
	for (id person in thePeople) {
        ABContact *contact = [ABContact contactWithRecord:(ABRecordRef)person];

        /*获取联系人拼音的数组*/
        NSMutableArray *contacts_pinyin_array = [POAPinyin newQuickConvert:contact.contactName];
        /*获取联系人拼音首字母对应键盘数字*/
        NSString *contacts_pinyin_num = [self fetchPinyinForNum:contacts_pinyin_array];
        /*获取联系人的全拼*/
        NSString *contacts_pinyin = [self fetchWholePinyin:contact.contactName]; 
        NSString *contacts_pinyin_key = (![contacts_pinyin isEqualToString:@""]) ? [contacts_pinyin substringToIndex:1] :   @"#";

		[array addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:contact, @"contact", contacts_pinyin, kNamePinyin, contacts_pinyin_array, kNamePinyinArray, contacts_pinyin_key, kNamePinyinKey, contacts_pinyin_num, kNamePinyinNum, nil]];
    }
    [thePeople release];
   // CFRelease(addressBook);
    
    //NSLog(@"%@", array);
	return array;
}


+ (int) contactsCount
{
	ABAddressBookRef addressBook = ABAddressBookCreate();
	return ABAddressBookGetPersonCount(addressBook);
}

+ (int) contactsWithImageCount
{
	ABAddressBookRef addressBook = ABAddressBookCreate();
	NSArray *peopleArray = (NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
	int ncount = 0;
	for (id person in peopleArray) if (ABPersonHasImageData(person)) ncount++;
	[peopleArray release];
	return ncount;
}

+ (int) contactsWithoutImageCount
{
	ABAddressBookRef addressBook = ABAddressBookCreate();
	NSArray *peopleArray = (NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
	int ncount = 0;
	for (id person in peopleArray) if (!ABPersonHasImageData(person)) ncount++;
	[peopleArray release];
	return ncount;
}

// Groups
+ (int) numberOfGroups
{
	ABAddressBookRef addressBook = ABAddressBookCreate();
	NSArray *groups = (NSArray *)ABAddressBookCopyArrayOfAllGroups(addressBook);
	int ncount = groups.count;
	[groups release];
	return ncount;
}

+ (NSArray *) groups
{
	ABAddressBookRef addressBook = ABAddressBookCreate();
	NSArray *groups = (NSArray *)ABAddressBookCopyArrayOfAllGroups(addressBook);
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:groups.count];
	for (id group in groups)
		[array addObject:[ABGroup groupWithRecord:(ABRecordRef)group]];
	[groups release];
	return array;
}

// Sorting
+ (BOOL) firstNameSorting
{
	return (ABPersonGetCompositeNameFormat() == kABPersonCompositeNameFormatFirstNameFirst);
}

#pragma mark Contact Management

// Thanks to Eridius for suggestions re: error
+ (BOOL) addContact: (ABContact *) aContact withError: (NSError **) error
{
	ABAddressBookRef addressBook = ABAddressBookCreate();
	if (!ABAddressBookAddRecord(addressBook, aContact.record, (CFErrorRef *) error)) return NO;
	return ABAddressBookSave(addressBook, (CFErrorRef *) error);
}

+ (BOOL) addGroup: (ABGroup *) aGroup withError: (NSError **) error
{
	ABAddressBookRef addressBook = ABAddressBookCreate();
	if (!ABAddressBookAddRecord(addressBook, aGroup.record, (CFErrorRef *) error)) return NO;
	return ABAddressBookSave(addressBook, (CFErrorRef *) error);
}

+ (NSArray *) contactsMatchingName: (NSString *) fname
{
	NSPredicate *pred;
	NSArray *contacts = [ABContactsHelper contacts];
	pred = [NSPredicate predicateWithFormat:@"firstname contains[cd] %@ OR lastname contains[cd] %@ OR nickname contains[cd] %@ OR middlename contains[cd] %@", fname, fname, fname, fname];
	return [contacts filteredArrayUsingPredicate:pred];
}

+ (NSArray *) contactsMatchingName: (NSString *) fname andName: (NSString *) lname
{
	NSPredicate *pred;
	NSArray *contacts = [ABContactsHelper contacts];
	pred = [NSPredicate predicateWithFormat:@"firstname contains[cd] %@ OR lastname contains[cd] %@ OR nickname contains[cd] %@ OR middlename contains[cd] %@", fname, fname, fname, fname];
	contacts = [contacts filteredArrayUsingPredicate:pred];
	pred = [NSPredicate predicateWithFormat:@"firstname contains[cd] %@ OR lastname contains[cd] %@ OR nickname contains[cd] %@ OR middlename contains[cd] %@", lname, lname, lname, lname];
	contacts = [contacts filteredArrayUsingPredicate:pred];
	return contacts;
}

+ (NSArray *) contactsMatchingPhone: (NSString *) number
{
	NSPredicate *pred;
	NSArray *contacts = [ABContactsHelper contacts];
	pred = [NSPredicate predicateWithFormat:@"phonenumbers contains[cd] %@", number];
	return [contacts filteredArrayUsingPredicate:pred];
}

+ (NSArray *) groupsMatchingName: (NSString *) fname
{
	NSPredicate *pred;
	NSArray *groups = [ABContactsHelper groups];
	pred = [NSPredicate predicateWithFormat:@"name contains[cd] %@ ", fname];
	return [groups filteredArrayUsingPredicate:pred];
}
@end