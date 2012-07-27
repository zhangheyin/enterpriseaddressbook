//
//  CallHistory.m
//  EnterpriseAddressBook
//
//  Created by admin on 12-7-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CallHistory.h"

@implementation CallHistory
+ (NSString *)filePathName {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
  NSString *documentsDirectory = [paths objectAtIndex:0];  
  if (!documentsDirectory) {  
    NSLog(@"Documents directory not found!");  
  }  
  NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"CallRecord.plist"];  
  
  return appFile;
}

+ (void)deleteFileDatabade {
  NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];  
  if (!documentsDirectory) {  
    NSLog(@"Documents directory not found!");  
    return;
  }  
  NSString *documentLibraryFolderPath = [documentsDirectory stringByAppendingPathComponent:@"CallRecord.plist"];
  
  [[NSFileManager defaultManager] removeItemAtPath:documentLibraryFolderPath error:nil];
}
+ (NSMutableArray *)loadCallRecordFromFilePath:(NSString *)filePath {
  NSMutableArray *record = nil;
  if (filePath == nil || [filePath length] == 0 || 
      [[NSFileManager defaultManager] fileExistsAtPath:filePath] == NO) {
    record = [[[NSMutableArray alloc] init] autorelease];
  } else {
    NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
    NSKeyedUnarchiver *vdUnarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    record = [vdUnarchiver decodeObjectForKey:kSaveKeyMarkerLines];
    [vdUnarchiver finishDecoding];
    [vdUnarchiver release];
    [data release];
  }
  return record;
}

+ (void)saveCallRecord:(NSMutableArray *)record toFilePath:(NSString *)filePath {
  NSLog(@"saveCallRecord %@", record);
  NSMutableData *data = [[NSMutableData alloc] init];
  NSKeyedArchiver *vdArchiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
  [vdArchiver encodeObject:record forKey:kSaveKeyMarkerLines];
  [vdArchiver finishEncoding];
  [data writeToFile:filePath atomically:YES];
  [vdArchiver release];
  [data release];
}

+ (NSDate *)dialTime {
  return  [NSDate date];
}

@end
