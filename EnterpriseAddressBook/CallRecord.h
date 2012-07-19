//
//  CallRecord.h
//  Tabbar_iOS5
//
//  Created by admin on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CallRecord : NSObject

@property (nonatomic, copy) NSString *callName;
@property (nonatomic, copy) NSString *callNumber;
@property (nonatomic, strong) NSDate *callTime;

@end
