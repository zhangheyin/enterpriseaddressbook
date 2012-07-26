//
//  CallHistory.h
//  EnterpriseAddressBook
//
//  Created by admin on 12-7-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CallHistory : NSObject
+ (NSString *)filePathName;
+ (NSMutableArray *)loadCallRecordFromFilePath:(NSString *)filePath;
+ (void)saveCallRecord:(NSMutableArray *)record toFilePath:(NSString *)filePath;
+ (NSDate *)dialTime;
+ (void)deleteFileDatabade;
@end
